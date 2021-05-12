##
## EPITECH PROJECT, 2019
## Makefile
## File description:
## Makefile for clean.
##

SRC			=		Main.hs

CC			=		stack build

COPY_EXE	=		--copy-bins --local-bin-path .

NAME		=		funEvalExpr

EXE_NAME	=		funEvalExpr-exe

RM			=		rm -f

all:
	@echo -e " -> \e[96mCompilation\033[0m"
	@$(CC) $(COPY_EXE)
	@mv $(EXE_NAME) $(NAME)
	@echo -e " -> \e[96mCompilation ok\033[0m"
clean:
	@echo -e " -> \e[96mCleaning\033[0m"
	@stack clean --full
	@${RM} funEvalExpr.cabal
	@echo -e " -> \e[96mRepository cleaned\033[0m"

fclean: clean
	@echo -e " -> \e[96mCleaning radically\033[0m"
	@${RM} ${NAME}
	@echo -e " -> \e[96mRepository radical cleaned\033[0m"

re:	fclean all

.PHONY:	all	clean fclean re