# PowerASTNN
This is a software library for the paper "Power-ASTNN: A Deobfuscation and AST Neural Network Enabled Effective Detection Method for Malicious PowerShell Scripts."

pipeline_for_PowerShell_AST.py:
This python file is used to construct the pkl files for the samples utilized during the training and testing processes. You can modify the data address parameters within to build pkl files for your own benign and malicious code, thereby adapting them to the format required for the training files.At the same time, modifications to the word2vec file are required. Please perform word2vec on the text file before running this file to obtain your pkl file. If you wish to replicate the experiments in this paper, you do not need to run the word2vec file, as the corresponding word2vec file has already been uploaded to this project.

#train_for_all_scripts_to_word2vec.py:
This script is designed to process PowerShell script data and train a Word2Vec model. Its main functions include reading PowerShell script files from a specified folder, preprocessing the text, training the Word2Vec model, and saving the model for future use.

#train_for_PowerShell_AST.py
This document serves as the training and testing file corresponding to the model presented in this paper. The input format is in pkl format (you may modify it accordingly). If you wish to replicate the experiments in this paper, simply adjust the file paths as needed. If you intend to use your own dataset, you can follow the steps outlined above systematically.

If this article has been helpful to you, feel free to cite our work: Power-ASTNN: A Deobfuscation and AST Neural Network Enabled Effective Detection Method for Malicious PowerShell Scripts.
