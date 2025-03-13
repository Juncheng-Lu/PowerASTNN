import re

import chardet

from flashtext01 import KeywordProcessor
import os
import sys
import time

sys.setrecursionlimit(10500)

current_file_path = os.path.dirname(os.path.abspath(__file__))

src_dir = os.path.join(current_file_path, "Deobfucated_AMSI") 
dict_dir = os.path.join(current_file_path, "fasttext_replace")  
dst_dir = os.path.join(current_file_path, "final_output")



files = [f for f in os.listdir(src_dir) if os.path.isfile(os.path.join(src_dir, f))]
files.sort()
start_all_time = time.time()
for file_name in files:
    src_filepath = os.path.join(src_dir, file_name)
    dict_filepath = os.path.join(dict_dir, file_name)
    dst_filepath = os.path.join(dst_dir, file_name)

    keyword_processor = KeywordProcessor()
    keyword_processor.case_sensitive = False

    '''
    keyword_processor.add_non_word_boundary('/')
    keyword_processor.add_non_word_boundary('-')
    keyword_processor.add_non_word_boundary('%')
    keyword_processor.add_non_word_boundary('>')
    keyword_processor.add_non_word_boundary('<')
    keyword_processor.add_non_word_boundary('+')
    keyword_processor.add_non_word_boundary('"')
    keyword_processor.add_non_word_boundary('{')
    keyword_processor.add_non_word_boundary('}')
    keyword_processor.add_non_word_boundary('.')
    keyword_processor.add_non_word_boundary('$')
    keyword_processor.add_non_word_boundary('(')
    keyword_processor.add_non_word_boundary(')')
    keyword_processor.add_non_word_boundary(' ')
    '''

    with open(src_filepath, encoding='utf-8') as f1:
        obfuscated_file = f1.read().strip()

    try:
        with open(dict_filepath) as f2:
            dict_file = f2.readlines()
    except FileNotFoundError:
        with open(dst_filepath, "w") as f3:
            f3.write(obfuscated_file)
        continue
    except UnicodeDecodeError:
        print("with unicode")


    start_time = time.time()
    """for i in range(len(dict_file)):
        if dict_file[i].startswith('1111111111'):
            if not dict_file[i + 1].startswith(r'n'):
                clean_words = dict_file[i + 1]
                j = i + 1
                while j < len(dict_file):
                    j += 1
                    if dict_file[j].startswith('000000000'):
                        break
                    clean_words += dict_file[j]
                dict_file[i - 1] = dict_file[i - 1].strip()
                clean_words = clean_words.strip()
                keyword_processor.add_keyword(dict_file[i - 1], clean_words)"""
    """
    if file_name == "31.ps1":
        print(dict_file)
        print(len(dict_file))
    """
    state = 'search_A'  
    mapping = {}
    for i in range(len(dict_file)):
        """
        if file_name == "31.ps1":
            print("当前状态: {}".format(state))
        """
        if state == 'search_A':
            if dict_file[i].startswith('0000000000'):
                A = ""
                state = 'collect_A'

        elif state == 'collect_A':
            if dict_file[i].startswith('1111111111'):

                state = 'collect_B'
                B = ""
            else:
                A += str(dict_file[i])


        elif state == 'collect_B':
            if dict_file[i].startswith('0000000000'):
                mapping[A.strip()] = B.strip()

                keyword_processor.add_keyword(A, B)
                """
                if file_name == "31.ps1":
                    print("A " +A)
                    print("B: "+B)
                """
                state = 'search_A'

            else:
                B += str(dict_file[i])




    """for i in range(len(dict_file)):
        if dict_file[i].startswith('1111111111'):
            if not dict_file[i + 1].startswith('n'):
                clean_words = dict_file[i + 1]
                j = i + 1
                while j + 1 < len(dict_file):  # 确保j+1不会超出范围
                    j += 1
                    if dict_file[j].startswith('000000000'):
                        break
                    clean_words += dict_file[j]
                dict_file[i - 1] = dict_file[i - 1].strip()
                clean_words = clean_words.strip()
                keyword_processor.add_keyword(dict_file[i - 1], clean_words)"""

    def replace_text(text, mapping):
        for key, value in mapping.items():
            text = text.replace(key, value)
        return text


    from flashtext import KeywordProcessor
    def replace_text_flashtext(text, mapping):
        processor = KeywordProcessor()
        for key, value in mapping.items():
            processor.add_keyword(key, value)
        return processor.replace_keywords(text)
    #if file_name == "63.ps1":
     #   print(mapping)
    new_script=replace_text_flashtext(obfuscated_file,mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    new_script = replace_text_flashtext(new_script, mapping)
    #new_script = replace_text(obfuscated_file, mapping)


    #new_script = keyword_processor.replace_keywords(obfuscated_file)

    with open(dst_filepath, "w") as f3:
        f3.write(new_script)

    end_time = time.time()
    # print(f"Processed {file_name} in {end_time - start_time} seconds")
end_all_time = time.time()
#print(f"all Processed in {end_all_time - start_all_time} seconds")
#print("All files processed.")

import os
import re


folder_path = dst_dir

for file_name in os.listdir(folder_path):
    if file_name.endswith('.ps1'):
        file_path = os.path.join(folder_path, file_name)

  
        with open(file_path, 'rb') as file:
            raw_data = file.read()
        encoding = chardet.detect(raw_data)['encoding']

     
        with open(file_path, 'r', encoding=encoding) as file:
            content = file.read()

        
        modified_content = re.sub(r"`", '', content)

        
        with open(file_path, 'w', encoding=encoding) as file:
            file.write(modified_content)

print("All file processing is completed.")
