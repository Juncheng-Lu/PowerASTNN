import pandas as pd
import random
import torch
import time
from matplotlib import pyplot as plt
import numpy as np
from gensim.models.word2vec import Word2Vec
from sklearn.metrics import precision_score, recall_score, f1_score, accuracy_score


from model_for_PowerShell_with_multiheadattention import BatchProgramClassifier
from torch.autograd import Variable
from sklearn.metrics import roc_curve, auc
#from matplotlib import pyplot as plt


from torch.utils.data import DataLoader
import os
import sys


def get_batch(dataset, idx, bs):
    tmp = dataset.iloc[idx: idx+bs]
    data, labels = [], []
    for _, item in tmp.iterrows():
        data.append(item[1])
        labels.append(item[2]-1)
    #注意label也必须转移为张量
    #print(data)
    return data, torch.LongTensor(labels)


if __name__ == '__main__':
    root = 'data/'
    train_data = pd.read_pickle(root+'train/AST_blocks_PowerShell.pkl')
    val_data = pd.read_pickle(root + 'dev/AST_blocks_PowerShell.pkl')
    test_data = pd.read_pickle(root+'test/AST_blocks_PowerShell.pkl')
    #36621  36621  [[32, [2, [30, [40, [4]]]]], [6], [2, [0, [4]]...     2

    word2vec = Word2Vec.load(r'word2vec_128_powershell_origin').wv
    #word2vec = Word2Vec.load(r'D:\BaiduSyncdisk\PowerShell_deobfuscation\all_code\astnn_for_PowerShell_2\data\train\embedding\node_w2v_128').wv
    #词汇表的大小（行数），词汇表向量维数
    embeddings = np.zeros((word2vec.vectors.shape[0] + 1, word2vec.vectors.shape[1]), dtype="float32")
    embeddings[:word2vec.vectors.shape[0]] = word2vec.vectors

    HIDDEN_DIM = 100
    ENCODE_DIM = 128
    LABELS = 2
    EPOCHS = 10
    BATCH_SIZE = 8
    USE_GPU = True
    MAX_TOKENS = word2vec.vectors.shape[0]
    EMBEDDING_DIM = word2vec.vectors.shape[1]

    model = BatchProgramClassifier(embedding_dim=EMBEDDING_DIM, hidden_dim=HIDDEN_DIM, vocab_size=MAX_TOKENS+1, encode_dim=ENCODE_DIM, label_size=LABELS, batch_size=BATCH_SIZE,
                                   use_gpu=USE_GPU)
    if USE_GPU:
        model.cuda()

    parameters = model.parameters()
    optimizer = torch.optim.Adamax(parameters)
    loss_function = torch.nn.CrossEntropyLoss()

    train_loss_ = []
    val_loss_ = []
    train_acc_ = []
    val_acc_ = []
    best_acc = 0.0
    print('Start training...')
    # training procedure
    best_model = model
    for epoch in range(EPOCHS):
        start_time = time.time()

        total_acc = 0.0
        total_loss = 0.0
        total = 0.0
        i = 0
        while i < len(train_data):
            batch = get_batch(train_data, i, BATCH_SIZE)

            i += BATCH_SIZE
            train_inputs, train_labels = batch
            if USE_GPU:
                train_inputs, train_labels = train_inputs, train_labels.cuda()

            model.zero_grad()
            model.batch_size = len(train_labels)
            model.hidden = model.init_hidden()
            output = model(train_inputs)
            #print(output)
            #用交叉熵损失
            loss = loss_function(output, Variable(train_labels))
            #反向传播
            loss.backward()
            #Adamax
            optimizer.step()

            # calc training acc
            _, predicted = torch.max(output.data, 1)
            total_acc += (predicted == train_labels).sum()
            total += len(train_labels)
            total_loss += loss.item()*len(train_inputs)

        train_loss_.append(total_loss / total)
        train_acc_.append(total_acc.item() / total)
        # validation epoch
        total_acc = 0.0
        total_loss = 0.0
        total = 0.0
        i = 0
        while i < len(val_data):
            batch = get_batch(val_data, i, BATCH_SIZE)
            i += BATCH_SIZE
            val_inputs, val_labels = batch
            if USE_GPU:
                val_inputs, val_labels = val_inputs, val_labels.cuda()

            model.batch_size = len(val_labels)
            model.hidden = model.init_hidden()
            output = model(val_inputs)

            loss = loss_function(output, Variable(val_labels))

            # calc valing acc
            _, predicted = torch.max(output.data, 1)
            total_acc += (predicted == val_labels).sum()
            total += len(val_labels)
            total_loss += loss.item()*len(val_inputs)
        val_loss_.append(total_loss / total)
        val_acc_.append(total_acc.item() / total)
        end_time = time.time()
        if total_acc/total > best_acc:
            best_model = model
        print('[Epoch: %3d/%3d] Training Loss: %.4f, Validation Loss: %.4f,'
              ' Training Acc: %.3f, Validation Acc: %.3f, Time Cost: %.3f s'
              % (epoch + 1, EPOCHS, train_loss_[epoch], val_loss_[epoch],
                 train_acc_[epoch], val_acc_[epoch], end_time - start_time))

    total_acc = 0.0
    total_loss = 0.0
    total = 0.0
    i = 0
    model = best_model
    while i < len(test_data):
        batch = get_batch(test_data, i, BATCH_SIZE)
        i += BATCH_SIZE
        test_inputs, test_labels = batch
        if USE_GPU:
            test_inputs, test_labels = test_inputs, test_labels.cuda()

        model.batch_size = len(test_labels)
        model.hidden = model.init_hidden()
        output = model(test_inputs)

        loss = loss_function(output, Variable(test_labels))

        _, predicted = torch.max(output.data, 1)
        total_acc += (predicted == test_labels).sum()
        total += len(test_labels)
        total_loss += loss.item() * len(test_inputs)
    print("Testing results(Acc):", total_acc.item() / total)

    #添加AUC曲线
    model.eval()
    all_predicted_probs = []
    all_true_labels = []
    i = 0
    while i < len(test_data):
        batch = get_batch(test_data, i, BATCH_SIZE)
        i += BATCH_SIZE
        test_inputs, test_labels = batch
        if USE_GPU:
            test_inputs, test_labels = test_inputs, test_labels.cuda()

        model.batch_size = len(test_labels)
        model.hidden = model.init_hidden()
        output = model(test_inputs)

        # 获取模型输出的概率分布
        softmax_output = torch.nn.functional.softmax(output, dim=1)
        predicted_probs = softmax_output[:, 1].detach().cpu().numpy()  # 1 表示正例的概率

        all_predicted_probs.extend(predicted_probs)
        all_true_labels.extend(test_labels.cpu().numpy())

    # 测试循环结束，计算总体测试指标
    predicted_all = []
    labels_all = []

    i = 0
    model = best_model
    while i < len(test_data):
        batch = get_batch(test_data, i, BATCH_SIZE)
        i += BATCH_SIZE
        test_inputs, test_labels = batch
        if USE_GPU:
            test_inputs, test_labels = test_inputs, test_labels.cuda()

        model.batch_size = len(test_labels)
        model.hidden = model.init_hidden()
        output = model(test_inputs)

        loss = loss_function(output, Variable(test_labels))

        _, predicted = torch.max(output.data, 1)
        total_acc += (predicted == test_labels).sum()
        total += len(test_labels)
        total_loss += loss.item() * len(test_inputs)

        # 添加到总体预测和标签列表中
        predicted_all.extend(predicted.cpu().numpy())
        labels_all.extend(test_labels.cpu().numpy())

    # 计算和打印指标
    accuracy = accuracy_score(labels_all, predicted_all)
    precision = precision_score(labels_all, predicted_all)
    recall = recall_score(labels_all, predicted_all)
    f1 = f1_score(labels_all, predicted_all)

    print("最终测试结果:")
    print("准确度(Accuracy): {:.4f}".format(accuracy))
    print("精确度(Precision): {:.4f}".format(precision))
    print("召回率(Recall): {:.4f}".format(recall))
    print("F1分数(F1 Score): {:.4f}".format(f1))

    # 计算 ROC 曲线和 AUC
    fpr, tpr, _ = roc_curve(all_true_labels, all_predicted_probs)
    roc_auc = auc(fpr, tpr)

    # 绘制 ROC 曲线
    plt.figure()
    plt.plot(fpr, tpr, color='darkorange', lw=2, label='ROC curve (area = {:.2f})'.format(roc_auc))
    plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title('Receiver Operating Characteristic (ROC) Curve')
    plt.legend(loc='lower right')
    plt.show()