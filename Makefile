##
## EPITECH PROJECT, 2025
## Makefile
## File description:
## PROJECT
##

EXEC = wolfram
EXEC_BASE = wolfram-exe

all:
	stack build
	cp $$(stack path --local-install-root)/bin/$(EXEC_BASE) .
	mv $(EXEC_BASE) $(EXEC)

wolfram_bonus:
	make fclean
	cd bonus && ghc -package-db ~/.cabal/store/ghc-*/package.db -package extra -o wolfram_b Main_bonus.hs && mv wolfram_b ../

run:
	stack exec $(EXEC)


clean:
	rm -rf $(EXEC)
	stack clean

fclean:
	rm -rf $(EXEC)
	stack clean

re:		clean all

.PHONY: 	clean all
