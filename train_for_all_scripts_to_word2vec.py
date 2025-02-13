from gensim.models import Word2Vec
from nltk.tokenize import word_tokenize  # 需要安装 nltk，使用 pip install nltk
import re
# 数据集
import os

# 指定本地路径
#folder_path = r'D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset\malware_dataset_2021\final\03_with_delimeters\all\train'
folder_path = r'D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset_for_my_model\dataset_Power-ASTNN\00_all_samples_train_for_Word2vec'
# 初始化一个空列表，用于存储文档内容
text_list = []


def replace_http_links(input_string, replacement="httpstring"):
    # 匹配HTTP链接的正则表达式
    http_regex = r'https?://\S+|www\.\S+'

    # 使用正则表达式进行替换
    result_string = re.sub(http_regex, replacement, input_string)

    return result_string

def custom_tokenizer(sentence):


    # 使用正则表达式按照空格、'.'、','、'='和'::'进行分词，保留'='、'.'和'::'作为一个token
    tokens = re.findall(r"[^\s\.,=;:]+|\.|,|::|=", sentence)

    # 过滤特殊字符 '{', '}', '(', ')', 单引号、双引号和 ';'
    tokens = [re.sub(r'[{}()\[\]\'\";]', '', token) for token in tokens]

    # 将符合形式0x[0-9a-z][0-9a-z]的数据替换为0x11
    tokens = [re.sub(r'0x[0-9a-z][0-9a-z]', '0x11', token) for token in tokens]

    # 将所有tokens转换为小写
    tokens = [token.lower() for token in tokens]

    # 去掉空的token和包含逗号的token
    tokens = [token for token in tokens if token != '' and ',' not in token]

    return tokens

# 遍历文件夹
for filename in os.listdir(folder_path):
    if filename.endswith(".ps1"):
        file_path = os.path.join(folder_path, filename)
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            text = file.read()
            text_list.append(text)

corpus = text_list
#print(corpus)
# 分词
#tokens = [word_tokenize(sentence.lower()) for sentence in corpus]
#tokens = [sentence.split() for sentence in corpus]
tokens = [replace_http_links(sentence) for sentence in corpus]
tokens =  [custom_tokenizer(sentence) for sentence in corpus]
print(tokens)

# 构建 Word2Vec 模型
model = Word2Vec(tokens, vector_size=128, workers=16, sg=1,min_count = 3)


# 训练模型
model.train(tokens, total_examples=len(tokens), epochs=1000, word_count = 0)

# 获取单词的嵌入向量
word_vectors = model.wv

# 打印单词的嵌入向量
for word in word_vectors.key_to_index:
    embedding = word_vectors[word]
    print(f'{word}: {embedding}')

model.save(r'D:\BaiduSyncdisk\PowerShell_deobfuscation\all_code\astnn_for_PowerShell_2\word2vec_128_powershell_all_final')

word = "$var0"
if word in model.wv:
    vector = model.wv[word]
    print(f"Vector for '{word}': {vector}")
else:
    print(f"{word} not in vocabulary.")


from gensim.models import Word2Vec

