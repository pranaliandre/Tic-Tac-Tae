#!/bin/bash -x
echo "Welcome to tic tac toe game"
#constMants
TOTAL_MOVES=9

#variables
playerMoves=0

#declare the gameboard
declare -a boardGame

#function of resetting the board
function resetBoard(){
	boardGame=(1 2 3 4 5 6 7 8 9)
}
function printBoard(){
	echo "---------"
	for (( i=0;i<9;i+=3 ))
	do
		echo "| ${boardGame[$i]} | ${boardGame[$((i+1))]} | ${boardGame[$((i+2))]} |"
		echo "---------"
	done
}
#function for assign letter to player
function assignLetterToPlayer(){
	if [ $((RANDOM%2)) -eq 0 ]
	then
		player=x
		playerTurn=true
	else
		player=0
		playerTurn=true
	fi
	echo "player sign $player"
}

#function switch player to another player
function switchPlayer(){
	if [ $player == x ]
	then
		player=0
	else
		player=x
	fi
}
#function of player play the game enter position for playing game
function playUser(){
	read -p " Enter Position Between 1 to 9 : " position 
	if [[ $position -ge 1 && $position -le 9 ]]
	then
		emptyCell $position
	else
		echo "Invalid Position"
		playUser
	fi
}
# function for played a game till not reached end
function playTillGameEnd(){
	while [ $playerMoves -lt $TOTAL_MOVES ]
	do
		playUser
		printBoard
		winnerCheckCells
		switchPlayer
	done
	echo "Game Tie"
}
#function for checking is already filled or empty
function  emptyCell(){
	local position=$1-1
	if (( ${boardGame[position]}!=$player))
	then
		boardGame[$position]=$player
		((playerMoves++))
	else
		echo "position is occupied"
	fi
}
#function for checking diagonal, row and column
function winnerCheckCells(){
	column=0
	for ((row=0;row<7;row+=3))
	do
		checkWinner ${boardGame[$row]} ${boardGame[$((row+1))]} ${boardGame[$((row+2))]}
		checkWinner ${boardGame[$column]} ${boardGame[$((column+3))]} ${boardGame[$((column+6))]}
		(( column++ ))
	done
		checkWinner ${boardGame[0]} ${boardGame[4]} ${boardGame[8]}
		checkWinner ${boardGame[2]} ${boardGame[4]} ${boardGame[6]}
}

#function of check winner or not
function checkWinner(){
	local win1=$1 win2=$2 win3=$3
	if [ $win1 == $win2 ] && [ $win2 == $win3 ]
	then
		echo "Player win "
		exit
	fi
}
#Starting game
resetBoard
assignLetterToPlayer
playTillGameEnd
