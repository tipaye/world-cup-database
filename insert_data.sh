#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]; then
  #teams
    # find team name from winners
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    # if not found insert
    if [[ -z $team_id ]]; then
      # insert major
      insert_name_result=$($PSQL "INSERT INTO teams (name) values('$winner')")
      if [[ $insert_name_result == 'INSERT 0 1' ]]; then
        echo Inserted into teams, $winner
      fi
    fi
    # find team name from opponents
    team_id=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    # if not found, insert
    if [[ -z $team_id ]]; then
      # insert major
      insert_name_result=$($PSQL "INSERT INTO teams (name) values('$opponent')")
      if [[ $insert_name_result == 'INSERT 0 1' ]]; then
        echo Inserted into teams, $opponent
      fi
    fi
    #games
    winner_id=$($PSQL "SELECT team_id FROM teams where name='$winner'") 
    opponent_id=$($PSQL "SELECT team_id FROM teams where name='$opponent'") 
    insert_game_result=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)")
    if [[ $insert_game_result == 'INSERT 0 1' ]]; then
      echo Inserted into games, $year, $round, $winner_id, $opponent_id, $winner_goals, $opponent_goals
    fi
  fi  
done