#!/bin/bash -x
echo "Welcome to tic tac toe game"

#declare the gameboard
declare boardGame
#function of resetting the board
function resetBoard(){
	boardGame=(- - - - - - - - -)
}
function assignLetterToPlayer(){
	if [ $((RANDOM%2)) -eq 1 ]
	then
		player=X
	else
		player=0
	fi
}
resetBoard
assignLetterToPlayer
