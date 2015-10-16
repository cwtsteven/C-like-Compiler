.PHONY: all

MENHIRFLAGS     := --explain --table --inspection

OCAMLBUILD      := ocamlbuild -use-ocamlfind -use-menhir -menhir "menhir $(MENHIRFLAGS)" -package menhirLib

MAIN            := src/Main
TEST 			:= src/TestBench

all:
	$(OCAMLBUILD) $(MAIN).native
	$(OCAMLBUILD) $(TEST).native