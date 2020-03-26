#!/bin/bash -x
echo "Welcome to tic tac toe game"

#declare the gameboard
declare boardGame
#function of resetting the board
function resetBoard(){
	boardGame=(- - - - - - - - -)
}
resetBoard
