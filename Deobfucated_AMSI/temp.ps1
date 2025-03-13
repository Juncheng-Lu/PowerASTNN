# 3 laylers: echo "Amsiutils1" -> string -> encoding -> string

echo "Amsiutils1"

# 2layers split
echo "Amsiutils2" 

#2 layers: echo "Amsiutils2" -> encoding ->encoding
 echo "Amsiutils" 


#3 hiding in variables
$i = (((("{6}{1}{3}{5}{4}{0}{2}"-f 'ils','ho','3{0}',' {0}Amsi','t','u','ec')) -F [char]34))
echo "Amsiutils3"

echo "Amsiutils5"
