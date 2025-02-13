import re
import ast

import numpy as np
import pandas as pd
import os


class Pipeline:
    def __init__(self, ratio, root):
        self.ratio = ratio
        self.root = root
        self.sources = None
        self.train_file_path = None
        self.dev_file_path = None
        self.test_file_path = None
        self.size = 100

    # parse source code 有AST用ast.pkl，没有的话生成ast.pkl, programs.pkl的code是真实的code
    def prepare_sourcecode(self):
        import pandas as pd
        import os
        # 定义文件夹路径
        #folder_path1 = r"D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset\malware_dataset_2021\final\03_with_delimeters\all_with_delimeters\benign"  #
        #folder_path1 = r"D:\BaiduSyncdisk\PowerShell_deobfuscation\all_code\Power-Blend\数据集\mixed_benign_pure_0_2000"
        #folder_path1 = r"D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset\malware_dataset_2021\final\03_with_delimeters\all_with_delimeters\"

        #folder_path0 = r"D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset\malware_dataset_2021\final\03_with_delimeters\all_with_delimeters\malware"
        #folder_path0 =r"D:\BaiduSyncdisk\PowerShell_deobfuscation\dataset_for_my_model\dataset_Power-ASTNN\with_delimeters\all_with_delimeters\mixed_malicious_20"
        #folder_path0 = r"D:\BaiduSyncdisk\PowerShell_deobfuscation\all_code\Power-Blend\数据集\mixed_malicious_100"

        folder_path1 = r'C:\Users\Mi  Manchi\Desktop\PowerASTNN\04-Power-ASTNN\Power-ASTNN\dataset_ASTNN\mixed_dataset\benign_1k'
        folder_path0 = r'C:\Users\Mi  Manchi\Desktop\PowerASTNN\04-Power-ASTNN\Power-ASTNN\dataset_ASTNN\mixed_dataset\malware_1k'

        ps1_malware_files = [file for file in os.listdir(folder_path1) if file.endswith(".ps1")]
        ps1_benign_files = [file for file in os.listdir(folder_path0) if file.endswith(".ps1")]
        # 创建DataFrame
        data = {'id': range(0, len(ps1_malware_files) + len(ps1_benign_files)),
                'code': [],
                'label': [2] * len(ps1_malware_files) + [1] * len(ps1_benign_files)}

        # 读取txt文件的内容并添加到DataFrame
        for file in ps1_malware_files:
            file_path = os.path.join(folder_path1, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                data['code'].append(content)

        for file in ps1_benign_files:
            file_path = os.path.join(folder_path0, file)
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                data['code'].append(content)

        df = pd.DataFrame(data)
        # 打印DataFrame
        print(df)
        self.sources = df

    # split data for training, developing and testing
    def split_data(self):
        data = self.sources
        data_num = len(data)
        ratios = [int(r) for r in self.ratio.split(':')]
        train_split = int(ratios[0] / sum(ratios) * data_num)
        val_split = train_split + int(ratios[1] / sum(ratios) * data_num)
        data = data.sample(frac=1, random_state=666)
        train = data.iloc[:train_split]
        dev = data.iloc[train_split:val_split]
        test = data.iloc[val_split:]

        def check_or_create(path):
            if not os.path.exists(path):
                os.mkdir(path)

        train_path = self.root + 'train/'
        check_or_create(train_path)
        self.train_file_path = train_path + 'train_PowerShell.pkl'
        train.to_pickle(self.train_file_path)

        dev_path = self.root + 'dev/'
        check_or_create(dev_path)
        self.dev_file_path = dev_path + 'dev_PowerShell.pkl'
        dev.to_pickle(self.dev_file_path)

        test_path = self.root + 'test/'
        check_or_create(test_path)
        self.test_file_path = test_path + 'test_PowerShell.pkl'
        test.to_pickle(self.test_file_path)

    # generate block sequences with index representations
    def generate_block_seqs(self, data_path, part):

        from gensim.models.word2vec import Word2Vec

        w2v_model = Word2Vec.load(
            r'D:\BaiduSyncdisk\PowerShell_deobfuscation\all_code\astnn_for_PowerShell_2\word2vec_128_powershell_origin').wv
        vocab = w2v_model.key_to_index
        # "vocab: {'i': 0, 'ArrayRef': 1, 'Decl': 2, '=': 3, 'int': 4, '0': 5, 'End': 6, 'Compound': 7,"
        max_token = w2v_model.vectors.shape[0]

        def custom_tokenizer(sentence):
            # 使用正则表达式按照空格、'.'、','、'='和'::'进行分词，保留'='、'.'和'::'作为一个token
            tokens = re.findall(r"[^\s\.,=;:]+|\.|,|::|=", sentence)

            # 过滤特殊字符 '{', '}', '(', ')', 单引号、双引号、';'、'['和']'
            tokens = [re.sub(r'[{}()\[\]\'\";]', '', token) for token in tokens]

            # 将符合形式0x[0-9a-z][0-9a-z]的数据替换为0x11
            tokens = [re.sub(r'0x[0-9a-z][0-9a-z]', '0x11', token) for token in tokens]

            # 将所有tokens转换为小写
            tokens = [token.lower() for token in tokens]

            # 去掉空的token和包含逗号的token
            tokens = [token for token in tokens if token != '' and ',' not in token]

            return tokens

        def convert_to_new_list(nested_list, is_first_node=True):
            if not isinstance(nested_list, list):
                return [nested_list] if not is_first_node else nested_list

            new_list = []
            for i, item in enumerate(nested_list):
                new_list.append(convert_to_new_list(item, i == 0))

            return new_list

        def text_to_word2vec(text):
            print("text is :")
            print(text)
            #tokens = text.split()
            #for token in tokens:
            #   token = custom_tokenizer(token)
            tokens = custom_tokenizer(text)
            print(tokens)

            # tokens = [custom_tokenizer(token) for token in tokens]

            print("tokens:",tokens)
            for i, token in enumerate(tokens):
                if token == "-||->":
                    tokens[i] = "["
                elif token == "<-||-":
                    tokens[i] = "]"
                else:
                    # 如果不是替换标记，尝试将其替换为对应的Word2Vec嵌入

                    tokens[i] = vocab[token] if token in w2v_model else max_token

            print("tokens:",tokens)
            #add_tokens = []
            '''
                        for i, item in enumerate(tokens):
                # if i > 0 and isinstance(item, int) and not isinstance(tokens[i - 1], str) and tokens[
                if i > 0 and isinstance(item, int) and tokens[
                    i - 1] != '[':
                #if i > 0 and isinstance(item, int):
                    add_tokens.extend(['[', str(item), ']'])
                else:
                    add_tokens.append(item)
            '''


            # tokens = (',').join(tokens)
            tokens = ','.join(str(item) for item in tokens)
            print(tokens)

            result_string = re.sub(r',(?=\])|(?<=\[),', '', tokens)

            #result_string = '[' + str(result_string) + ']'

            # embeddings = [vocab[token] for token in tokens if token in w2v_model]
            # if not embeddings:
            #    return [0] * w2v_model.vector_size  # 或者你可以选择其他的默认值
            try:
                results =ast.literal_eval(result_string)
            except SyntaxError as e:
                print("------------------------------------------------------------------------------------------------------------------------------------")
                results = ast.literal_eval('[' + result_string)


            # results = eval(result_string)
            # results = list(results)
            # results = convert_to_new_list(results)
            # print(results[0][0])
            print("results:")
            print(results)
            print(results[0])
            print('end')

            return results

        trees = pd.read_pickle(data_path)
        # 每行数据都使用trans2seq

        trees['code'] = trees['code'].apply(text_to_word2vec)
        trees.to_pickle(self.root + part + '/AST_blocks_PowerShell.pkl')
        # 36621  36621  [[32, [2, [30, [40, [4]]]]], [6], [2, [0, [4]]...     1  ASTNN
        # [[32, [2, [30, [40, [4]]]]], [6], [2, [13, [4]]], [11, [36], [12, [46], [29, [13]]]], [2, [23, [23, [9, [4]], [13]], [13]]], [2, [0, [4]]], [2, [8, [4]]], [2, [119, [4]]], [2, [151, [4]]], [2, [134, [4]]], [2, [140, [4]]], [2, [58, [4]]], [16, [3, [0], [5]], [20, [0], [13]], [14, [0]]], [6], [16, [3, [8], [5]], [20, [8], [13]], [14, [8]]], [6], [11, [36], [12, [46], [29, [1, [1, [9], [0]], [8]]]]], [7], [7], [16, [3, [0], [5]], [20, [0], [13]], [14, [0]]], [6], [16, [3, [8], [5]], [20, [8], [13]], [14, [8]]], [6], [15, [31, [31, [19, [1, [1, [9], [0]], [8]], [5]], [19, [1, [1, [9], [0]], [18, [8], [10]]], [401]]], [1, [1, [9], [18, [0], [10]]], [8]]]], [6], [3, [119], [0]], [3, [151], [8]], [7], [15, [31, [31, [19, [1, [1, [9], [0]], [8]], [5]], [19, [1, [1, [9], [0]], [17, [8], [10]]], [401]]], [1, [1, [9], [17, [0], [10]]], [8]]]], [6], [3, [134], [0]], [3, [140], [8]], [7], [7], [7], [3, [58], [27, [18, [18, [134], [119]], [10]], [18, [18, [140], [151]], [10]]]], [11, [25], [12, [4..

    # run for processing data to train
    def run(self):
        print('parse source code...')
        # self.parse_source(output_file='ast.pkl', option='existing')
        self.prepare_sourcecode()
        print('split data...')
        self.split_data()
        print('wait for generate block sequences...')
        self.generate_block_seqs(self.train_file_path, 'train')
        self.generate_block_seqs(self.dev_file_path, 'dev')
        self.generate_block_seqs(self.test_file_path, 'test')


ppl = Pipeline('3:1:1', r'data/')
ppl.run()

