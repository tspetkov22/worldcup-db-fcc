#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# year,round,winner,opponent,winner_goals,opponent_goals

echo $($PSQL "truncate teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent &&
        $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]; then
    
        #-------------#
        #insert winner#
        #-------------#

        #get winner tean_id
        WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

        #if not found
        
        if [[ -z $WINNER_ID ]]; then
           #insert team
            INSERT_WINNER=$($PSQL "insert into teams(name) values('$WINNER')") 
              if [[ $INSERT_WINNER == "INSERT 0 1" ]]; then
                echo $INSERT_WINNER
                #get new team_id
                WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
                WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$WINNER_ID'")
                echo "Insert success : ${WINNER_NAME}"
              fi
        fi
    

        #---------------#
        #insert opponent#
        #---------------#

        #get opp team_id
        OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

        #if not found 

        if [[ -z $OPPONENT_ID ]]; then
           #insert team
            INSERT_OPPONENT=$($PSQL "insert into teams(name) values('$OPPONENT')") 
              if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]; then
                echo $INSERT_OPPONENT
                #get new team_id
                OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
                OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE team_id='$OPPONENT_ID'")
                echo "Insert success : ${OPPONENT_NAME}"
              fi
        fi

        #------------#
        #insert games#
        #------------#

        INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS, $OPPONENT_GOALS)")
          if [[ $INSERT_GAMES == "INSERT 0 1" ]]; then
            echo $INSERT_GAMES
            echo "Insert success : $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
          fi

      fi
    done
