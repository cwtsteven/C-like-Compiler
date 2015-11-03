.PHONY: all

MENHIRFLAGS     := --explain --table --inspection

BUILDMAIN       := ocamlbuild -use-ocamlfind -use-menhir -menhir "menhir $(MENHIRFLAGS)" -package menhirLib
BUILDTEST       := ocamlbuild -Is src -use-ocamlfind -use-menhir -menhir "menhir $(MENHIRFLAGS)" -package menhirLib

MAIN            := src/Main
TEST 			:= testing/TestBench

all:
	$(BUILDMAIN) $(MAIN).native
	$(BUILDTEST) $(TEST).native