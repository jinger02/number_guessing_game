#!/bin/bash
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN () {
    echo -e "\nEnter your username:\n"
    read USERNAME
    # check database if username exists
    USERNAME_RESULT=$($PSQL "SELECT username FROM username WHERE username='$USERNAME'")
    # if the user does not exists
    if [[ -z $USERNAME_RESULT ]]
    then
        INSERT_USERNAME=$($PSQL "INSERT INTO username(username) VALUES('$USERNAME')")
        echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
        
    fi
    # if user already in the database
    

    GUESS
    # insert data to games played
    USER_ID_RESULT=$($PSQL "SELECT user_id FROM username WHERE username='$USERNAME_RESULT'")
    echo $USER_ID_RESULT
    echo $COUNTER
    
    # input in the database
    GAME_RESULT=$($PSQL "INSERT INTO games_played(user_id,number_of_guess) VALUES($USER_ID_RESULT,$COUNTER)")
    

}

GUESS () {
    THE_NUMBER=$[ RANDOM %100 + 1 ]
    echo -e "\nGuess the secret number between 1 and 100:"
    read GUESS
    COUNTER=1

    while [[ $GUESS != $THE_NUMBER ]]
    do
        # if input is empty
        if [[ -z $GUESS ]]
        then
            echo "Input a number between 1 and 100, guess again:"

        # if input is a number between 1 and 100
        elif [[ $GUESS =~ ^[0-9]+$ ]]
        then
            # if the number is greater than max number
            if [[ $GUESS -gt 100 ]]
            then
                echo -e "Input a number between 1 and 100 only, guess again:"
            # if the number is less than
            elif (( $GUESS > $THE_NUMBER && $GUESS <= 100 ))
            then
                echo -e "It's lower than that, guess again:"
            elif (( $GUESS < $THE_NUMBER && $GUESS <= 100 ))
            then
                echo -e "It's higher than that, guess again:"
            else
                echo -e "Input a number between 1 and 100 only, guess again:"
            fi

        elif (( $GUESS <= 0 ))
        then
            echo -e "Input a number between 1 and 100, guess again:"  
        else
            echo -e "That is not an integer, guess again:"
        fi 

        ((COUNTER++))
        read GUESS
     
    done

echo -e "You guessed it in $COUNTER tries. The secret number was $THE_NUMBER. Nice job!"

}

MAIN