projet : projet.y projet.l test.txt
	bison -d -v $@.y
	lex $@.l
	gcc lex.yy.c $@.tab.c -lfl -o $@
	echo "---"
	./$@ < test.txt

dessin :
	gcc -o dessin res.c -I /usr/include/cairo -L /usr/lib -lcairo
	./dessin
	
clean :
	rm *.tab.h
	rm *.yy.c
	rm *.output
	rm *.tab.c
	rm res.c
	rm projet dessin
	rm dessin.pdf
