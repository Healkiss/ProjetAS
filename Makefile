% : %.y %.l test.txt
	bison -d -v $@.y
	lex $@.l
	gcc lex.yy.c $@.tab.c -lfl -o $@
	echo "---"
	./$@ < test.txt
	
clean :
	rm *.tab.h
	rm *.yy.c
	rm *.output
	rm *.tab.c
