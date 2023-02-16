#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Empty existing database
echo $($PSQL "TRUNCATE games, teams;")

# Read lines from games.csv
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  # Select winning team
  TEAM_W=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  
  # Check if value is not a header
  if [[ $WINNER != "winner" ]]
  then
    # Check if value already exists in table
    if [[ -z $TEAM_W ]]
    then 

      # Insert value
      INSERT_TEAM_W=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

      # Verify if insertion was succesful
      if [[ $INSERT_TEAM_W == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $WINNER"
      fi
    fi
  fi

  # Select opponent team
  TEAM_O=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

  # Check if value is not a header
  if [[ $OPPONENT != "opponent" ]]
  then

    # Check if value already exists in table
    if [[ -z $TEAM_O ]]
    then 
      # Insert row
      INSERT_TEAM_O=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
      # Verify if insertion was successful
      if [[ $INSERT_TEAM_O == "INSERT 0 1" ]]
      then
        echo "Inserted into teams: $OPPONENT"
      fi
    fi
  fi

  TEAM_ID_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # Check if value exists
  if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
    then

      # Check if value is not a header
      if [[ $YEAR != "year" ]]
      then

        # Insert row
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$TEAM_ID_W', '$TEAM_ID_O', '$WINNER_GOALS', '$OPPONENT_GOALS')")
        
        # Verify if insertion was successful 
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
          echo "Inserted into games: $YEAR, $ROUND, $TEAM_ID_W, $TEAM_ID_O, $WINNER_GOALS, $OPPONENT_GOALS"
        fi
      fi
  fi
done
