#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get winner_id
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $W_ID ]]
    then
      # insert team
      INSERT_W_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_W_ID == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $WINNER"
      fi

      # get new winner_id
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # get opponent_id
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if not found
    if [[ -z $O_ID ]]
    then
      # insert team
      INSERT_O_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_O_ID == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $OPPONENT"
      fi

      # get new opponent_id
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # insert data into games table
    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $W_ID, $O_ID, $W_GOALS, $O_GOALS)")
    if [[ $INSERT_INTO_GAMES == "INSERT 0 1" ]]
    then
      echo "Inserted into games, $ROUND of $YEAR"
    fi
  fi
done