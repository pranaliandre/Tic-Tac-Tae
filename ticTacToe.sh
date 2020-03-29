#!/bin/bash -x

echo "Welcome To Tic Tac Toe"

#constants
TOTAL_MOVES=9

#variables
playerMoves=0

#array for game board
declare -a gameBoard

#Restting game board
function resetBoard(){
	gameBoard=(1 2 3 4 5 6 7 8 9)
	printBoard
}

#Displaying board
function printBoard(){
	echo "-------------"
	for((i=0;i<7;i+=3))
	do
		echo "| ${gameBoard[$i]} | ${gameBoard[$((i+1))]} | ${gameBoard[$((i+2))]} |"
		echo "-------------"
	done
}

#Assiging letter X or O to player and decide who play first
function assignLetterToPlayer(){
	if [ $(( RANDOM % 2 )) -eq 0 ]; then
		computer=X
		player=O
	else
		player=X
		computer=O
	fi
	[ $player == X ] && echo "Player play first with X sign" || echo "Computer play first with X sign"
	[ $player == X ] && playerTurn || computerTurn
}

#Switching players
function switchPlayer(){
	#Checking condition using Ternary operators
	[ $currentPlayer == 1 ] && computerTurn || playerTurn
}

#Function for user play
function playerTurn(){
	currentPlayer=1
	#FUNCNAME is an array containing all the names of the functions in the call stack
	[ ${FUNCNAME[1]} == switchPlayer ] && echo "Player Turn Sign : $player"
	read -p "Enter Position Between 1 to 9 : " position
	if [[ $position -ge 1 && $position -le 9 && $position != ' ' ]]; then
		isCellEmpty $position $player
		checkWinningCells
	else
		echo "Please enter value"
		playerTurn
	fi
}

#Function for computer play
function computerTurn(){
	currentPlayer=0
	checkWinningCells $computer
	[ ${FUNCNAME[1]} == switchPlayer ] && echo " Computer Turn Sign $computer"
	#$?-The exit status of the last command executed.
	[ $? == 0 ] && checkWinningCells $player
	[ $? == 0 ] && takeProperPosition 0
	[ $? == 0 ] && takeProperPosition 1
	[ $? == 0 ] && isCellEmpty $((RANDOM % 9)) $computer
	printBoard
}

#checking position is already filled or blank
function isCellEmpty() {
	local position=$1-1
	local sign=$2
	if((${gameBoard[position]}!=X && ${gameBoard[position]}!=O))
	then
		gameBoard[$position]=$sign
		((playerMoves++))
	else
		[ ${FUNCNAME[1]} == "playerTurn" ] && echo "Position is Occupied"
		${FUNCNAME[1]}
	fi
}

#Checking column, rows and diagonals
function checkWinningCells(){
	[ ${FUNCNAME[1]} == "playerTurn" ] && call=checkWinner || call=checkForComputer; sign=$1;
	col=0
	for((row=0;row<7;row+=3))
	do
		[ $?==0 ] && $call $row $((row+1)) $((row+2)) || return 1
		[ $?==0 ] && $call $col $((col+3)) $((col+6)) || return 1
		((col++))
	done
	[ $?==0 ] && $call 0 4 8 || return 1
	[ $? == 0 ] && $call 2 4 6 || return 1
}

#Checking winner
function checkWinner(){
	local win1=$1 win2=$2 win3=$3
	if [ ${gameBoard[$win1]} == ${gameBoard[$win2]} ] && [ ${gameBoard[$win2]} == ${gameBoard[$win3]} ]; then
		[ ${gameBoard[$win1]} == $player ] && winner=player || winner=computer
		printBoard
		echo "$winner Win and Have Sign ${gameBoard[$cell1]}"
		exit
	fi
}

#Computer tring to win
function checkForComputer(){
	local win1=$1 win2=$2 win3=$3
	for((i=0;i<3;i++))
	do
		if [ ${gameBoard[$win1]} == ${gameBoard[$win2]} ] && [ ${gameBoard[$win1]} == $sign ] && [[ ${gameBoard[$win3]} == *[[:digit:]]* ]] 
		then
			gameBoard[$win3]=$computer
			checkWinner $win1 $win2 $win3
			((playerMoves++))
			return 1
		else
			eval $(echo win1=$win2\;win2=$win3\;win3=$win1)
		fi
	done
}
#function of take proper position
function takeProperPosition()
{
	local startValue=$1
	for(( i=startValue;i<9;i+=2))
	do
		if [[ ${gameBoard[$i]} == *[[:digit:]]* && $i != 4 ]]; then
			gameBoard[$i]=$computer
			((playerMoves++))
			return 1
		fi
	done
	if [[ ${gameBoard[((TOTAL_MOVES/2))]} == *[[:digit:]]*  ]]; then
		gameBoard[$i]=$computer
		((playerMoves++))
		return 1
	fi
} 
#Running game untill game ends
function playTillGameEnd(){
	resetBoard
	assignLetterToPlayer
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		switchPlayer
	done
	printBoard
	echo "Game Tie"
}

#starting game
playTillGameEnd
