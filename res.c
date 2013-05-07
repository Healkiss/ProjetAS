#include <cairo.h> 
#include <cairo-pdf.h> 
int main(void){ 
	cairo_surface_t *surface; 
	cairo_t *cr; 
	cairo_surface_t* pdf_surface = cairo_pdf_surface_create("dessin.pdf",100,100); 
	cr = cairo_create(pdf_surface);
	cairo_move_to(cr,0, 0) ;
	cairo_move_to(cr,5, 10) ;
	cairo_move_to(cr,5, 10) ;
	cairo_line_to(cr,5, 10);
	cairo_set_line_width(cr, 1.0);
	cairo_stroke(cr);
	cairo_destroy(cr);
	cairo_surface_destroy(pdf_surface);
	return 0;
}