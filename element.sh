#!/bin/bash
# function to print out infos
PRINT_INFO() {
   atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE $1='$2'")
   atomic_symbol=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$atomic_number'")
   atomic_name=$($PSQL "SELECT name FROM elements WHERE atomic_number='$atomic_number'")
   atomic_type_id=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$atomic_number'")
   atomic_type=$($PSQL "SELECT type FROM types WHERE type_id='$atomic_type_id'")
   atomic_mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$atomic_number'")
   boiling_temp=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$atomic_number'")
   melting_temp=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$atomic_number'")
   echo "The element with atomic number $atomic_number is $atomic_name ($atomic_symbol). It's a $atomic_type, with a mass of $atomic_mass amu. $atomic_name has a melting point of $melting_temp celsius and a boiling point of $boiling_temp celsius."
}
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# check if argument is a character
if [[ $1 =~ ^[[:alpha:]]+$ ]]
then
  is_name=$($PSQL "SELECT name FROM elements WHERE name='$1';")
  # check if it is a name
  if [[ $is_name ]]
  then
     PRINT_INFO 'name' $is_name
   

  else 
  # check if it is a symbol
     is_symbol=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1';")
     if [[ $is_symbol ]]
     then
        PRINT_INFO 'symbol' $is_symbol
     else
        #  inform user that their input is wrong
        echo "I could not find that element in the database."
     fi

  fi
else if [[ $1 =~ [0-9] ]]
then
  is_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1';")
  if [[ $is_number ]]
  then 
    PRINT_INFO 'atomic_number' $1
  else
     echo "I could not find that element in the database."

  fi
else
  echo "Please provide an element as an argument."
fi
fi