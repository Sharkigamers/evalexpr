#/usr/bin/bash

test_exit_status () {
    command ./funEvalExpr $2 &> /dev/null
    if [ $? == $1 ] ; then
        echo -e "\e[1m\e[92m"OK"\e[0m": $2 = $1
    else
        echo -e "\e[1m\e[91m"KO"\e[0m": $2 = $1
    fi
}

test_result () {
    res=`./funEvalExpr "$1"`

    if [ $res == $2 ] ; then
        echo -e "\e[1m\e[92m"OK"\e[0m": $1 = $2
    else
        echo -e "\e[1m\e[91m"KO Got:"\e[0m": $res "\e[1m\e[91m" expected:"\e[0m" $2
    fi
}

echo -e "\e[1m\e[92m> FuncEvalExpr Compilation Test:\e[0m"
make clean && make && make fclean && make re

echo -e "\e[1m\e[92m> FuncEvalExpr Tests:\e[0m"
echo -e "\n\e[1m\e[33m[Division by 0]\e[0m"

test_exit_status 84 "10/0"
test_exit_status 84 "10/10/0"
test_exit_status 84 "5+4*8*1/0+5"
test_exit_status 84 "5+4*8*1/(1-1)+5"

echo -e "\n\e[1m\e[33m[Empty parenthesis]\e[0m"

test_exit_status 84 "()"
test_exit_status 84 "((()))"
test_exit_status 84 "5+4*8*(())1/0+5"
test_exit_status 84 "5+()1"
test_exit_status 84 "5+1()"

echo -e "\n\e[1m\e[33m[Empty string]\e[0m"

test_exit_status 84 ""

echo -e "\n\e[1m\e[33m[Illegal character]\e[0m"

test_exit_status 84 "5.."
test_exit_status 84 "..5"
test_exit_status 84 "5+a+6"
test_exit_status 84 "5*$"

echo -e "\n\e[1m\e[33m[Missing number]\e[0m"

test_exit_status 84 "5*"
test_exit_status 84 "5+"
test_exit_status 84 "5-"
test_exit_status 84 "5/"
test_exit_status 84 "5^"

echo -e "\n\e[1m\e[33m[Missing parenthesis]\e[0m"

test_exit_status 84 "5--1"
test_exit_status 84 "5*-1"
test_exit_status 84 "5/-1"
test_exit_status 84 "5+-1"
test_exit_status 84 "5^-1"

echo -e "\n\e[1m\e[33m[No number]\e[0m"

test_exit_status 84 "+"
test_exit_status 84 "-"
test_exit_status 84 "/"
test_exit_status 84 "^"
test_exit_status 84 "?"

echo -e "\n\e[1m\e[33m[Reversed parenthesis]\e[0m"

test_exit_status 84 ")("
test_exit_status 84 "5+)5(+5"
test_exit_status 84 "5+)-5(+5"
test_exit_status 84 "5*)5(+5"

echo -e "\n\e[1m\e[33m[Two enchained operators]\e[0m"

test_exit_status 84 "5**5"
test_exit_status 84 "5++5"
test_exit_status 84 "5--5"
test_exit_status 84 "5//5"
test_exit_status 84 "5^^5"
test_exit_status 84 "5-/*+^5"

echo -e "\n\e[1m\e[33m[Two enchained operators]\e[0m"

test_exit_status 84 "5 5"
test_exit_status 84 "5*5+2-7/8*9 9"
test_exit_status 84 "5 5/5*9"
test_exit_status 84 "5*5 8*7"

echo -e "\n\e[1m\e[33m[Return value correct]\e[0m"

test_exit_status 0 "5"
test_exit_status 0 "5."
test_exit_status 0 ".5"
test_exit_status 0 "5*5"
test_exit_status 0 "5/10"
test_exit_status 0 "5+9*8/7-2+3+9+15*5"

echo -e "\n\e[1m\e[92m> Testing results\e[0m"

echo -e "\n\e[1m\e[33m[Simple operations]\e[0m"

test_result "1+2+3" 6.00
test_result "1-2-3" -4.00
test_result "2*2" 4.00
test_result "4/2" 2.00
test_result "3^2" 9.00
test_result "1+2-3" 0.00
test_result "-5-.5" -5.50

echo -e "\n\e[1m\e[33m[Complex operations]\e[0m"

test_result "14-2*2+12*2" 34.00
test_result "12*(2+2)^2" 192.00
test_result "3^(4*3+12-(4^2))" 6561.00
test_result "(0.345+5)*(-2-1)/3" -5.34

echo -e "\n\e[1m\e[33m[Large and complex operations]\e[0m"

test_result "12*2+4*(12^(2^2)*2)-(12543-12*2/3+(14^3)*2/2)" 150633.00
test_result "(165*14^2)-(13+2*12)*(2^2^2^2)" -2392492.00

echo -e "\n\e[1m\e[33m[Syntax]\e[0m"

test_result " 1+2 +3" 6.00
test_result " 1-2        +3" 2.00
test_result " 1*2 -  3" -1.00

echo -e "\n\e[1m\e[92m> FuncEvalExpr tests done\e[0m"
echo -e "\e[1m\e[92m> Hard cleaning repository\e[0m"

make fclean

echo -e "\e[1m\e[92m> Done\e[0m"
echo -e "\e[1m\e[92m> Thank you for having using me\e[0m"