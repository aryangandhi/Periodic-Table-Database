#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi


if [[ $1 =~ ^[1-9]+$ ]]
then
  DATA=$($PSQL "SELECT atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1'")
else
  DATA=$($PSQL "SELECT atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1' or symbol = '$1'")
fi

if [[ -z $DATA ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo $DATA | while IFS=" |" read atomic_number el_type atomic_mass mp_celsius bp_celsius symbol name 
do
  echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $el_type, with a mass of $atomic_mass amu. $name has a melting point of $mp_celsius celsius and a boiling point of $bp_celsius celsius."
done
