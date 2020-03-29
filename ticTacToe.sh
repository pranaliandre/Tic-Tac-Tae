#!/bin/bash -x
echo "Welcome to tic tac toe game"
#constMants
TOTAL_MOVES=9

#variables
playerMoves=0
playerTurn=0
#declare the gameboard
declare -a boardGame

#function of resetting the board
function resetBoard(){
	boardGame=(1 2 3 4 5 6 7 8 9)
	printBoard
}
#function of printing the board
function printBoard(){
	echo "---------"
	for (( i=0;i<7;i+=3 ))
	do
		echo "| ${boardGame[$i]} | ${boardGame[$((i+1))]} | ${boardGame[$((i+2))]} |"
		echo "---------"
	done
}
#function for assign letter to player
function assignLetterToPlayer(){
	if [ $(( RANDOM % 2 )) -eq 0 ]
	then
		computer=x
		player=0
	else
		player=x
		computer=0
	fi
	if [ $player == x ]
	then
		echo "Player play first with x sign"
	else
		echo "Computer play first with x sign"
	fi
	if [ $player == x ]
	then
		playerTurn
	else
		computerTurn
	fi
}

#function switch player to another player
function switchPlayer(){
	if [ $playerTurn == 1 ]
	then
		computerTurn
	else
		playerTurn
	fi
}
#function for user play
function playerTurn(){
	#function name is array containing all  the names of the functions in call stack
	playerTurn=1
	[ ${FUNCNAME[1]} == switchPlayer ] &&  echo "Player Turn sign $player"
	read -p "Enter position between 1 to 9 : " position	
	if [[ $position -ge 1 && $position -le 9 ]]
	then
		emptyCell $position $player
	else
		echo "please enter value"
		playerTurn	
	fi
}
#Function for computer play
function computerTurn(){
	[ $FUNCNAME[1]} == switchPlayer ] && echo "Computer Turn sign $computer "
	playerTurn=0
	position=$((RANDOM % 9))
	emptyCell $position $computer
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

#function for checking is already filled or empty
function  emptyCell(){
	local position=$1-1
	local sign=$2
	if (( ${boardGame[position]}!=x && ${boardGame[position]}!=0)) 
	then
		boardGame[$position]=$sign
		((playerMoves++))
	else
		[ ${FUNCNAME[1]} == "playerTurn" ] && echo "Position is occupied"
		${FUNCNAME[1]}
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
		[ $win1 == $player ] &&  winner=player || winner=computer
		echo "Winner win and have sign $win1 "
		exit
	fi
}
# function for played a game till not reached end
function playTillGameEnd(){
   resetBoard
   assignLetterToPlayer
   while [ $playerMoves -lt $TOTAL_MOVES ]
   do
      printBoard
      winnerCheckCells
      switchPlayer
   done
   printBoard
   echo "Game Tie"
}
#Starting game
playTillGameEnd
