##Partner: Deyan
----------------------------------------------

##Comments:
1. The test cases include the comparison of the generated Parse tree which is very helpful when testing expressions like <code>3 + 5 * 4</code>. In that case, we can make sure the expression is evaluated as we expected. 
2. The instructions on how to compile and run the parser are clearly stated. 
3. The documentation includes a brief introduction on what expressions are valid with examples which helps a lot when understanding the grammar. 


##Suggestions:
1. The error msg generated shows where the error came from, but the line number in the position is always 1. The line number should be consistent with the input.
2. It may be better if testing includes comparison on what the error is (Syntax/Parse) and the position of the error. 
3. I am not sure about the use of 'var' in the grammar. If 'var' is used as a declaration, then the grammar does not have assignemnt statement. If the 'var' is used as assignment, then it may not be neccesary, i.e. just a := 5 will serve the purpose.
4. The documentation can provide some more examples for both valid and invaild input because for now, only a valid input is shown.
5. It may be better if the Testing procedure is seperated from the main program (exp_test.ml) so the structure of the program will be clearer. 


##Reply to Deyan'suggestions:
