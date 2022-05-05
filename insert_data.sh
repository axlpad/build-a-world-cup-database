#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE  teams, games RESTART IDENTITY CASCADE")
echo -e "\nInserting DATA games "
cat games.csv | while IFS=","  read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
   then
   #insert team_id  by Winner name
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
   #if not found
   if [[ -z $WINNER_ID ]]
     then
     #insert winner name
     INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
     if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
       then
        echo Inserted into teams, $WINNER
     fi
      #get current winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   fi
    #get opponent team_id by opponent nameOPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
      then
      #insert opponent name
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #if not found
      if [[ INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
        echo Inserted into the teams, $OPPONENT
      fi
      #get current opponent_id name
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    #get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = '$YEAR' AND round = '$ROUND' AND winner_id = '$WINNER_ID'")
    #if not found
    if [[ -z $GAME_ID ]]
     then
     #insert game
     INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
     if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
       then
        echo Inserted into games, $YEAR $ROUND: $WINNER Defeat $OPPONENT $WINNER_GOALS to $OPPONENT_GOALS
     fi
    fi 
  fi
done