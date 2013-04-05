% : %.y %.l test.txt
	bison -d -v $@.y
	lex $@.l
	gcc lex.yy.c $@.tab.c -lfl -o $@
	echo "---"
	./$@ < test.txt
#gcc -o lignesBrisees  res.c -I /usr/include/cairo -L /usr/lib -lcairo
# ./ligneBrisees
#ouvrir le pdf
	
clean :
	rm *.tab.h
	rm *.yy.c
	rm *.output
	rm *.tab.c
