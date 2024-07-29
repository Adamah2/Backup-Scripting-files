#!/bin/bash

# Set variable for current date. We take the current date 
# and the +%s converts the date time into seconds
current_date=$(date +%s)

# Set the maximum password age to 90 days. 24 hours in a day, 60 minutes in an hour, and 60 seconds in a minute
# so 90*24*60*60 will convert 90 days to seconds 
max_passwd_age=$((90*24*60*60))

# Read the /etc/shadow file where all encrypted passwords for all accounts are stored
shadow_lines=$(sudo cat /etc/shadow)

# Looping through the shadow file
IFS=$'\n' # Set Internal Field Separator to newline to handle spaces in usernames
for eachline in $shadow_lines; do
    # For each line in the shadow file, cut is used with the -d: (-d: means cut to where there is a :)
    # so we cut the first line -f1 and set to variable username and we do same for the various variables that follow
    # each shadow line contains the username, the password, last access date for the password, each of them separated by a :
    username=$(echo "$eachline" | cut -d: -f1)
    encrypted_passwd=$(echo "$eachline" | cut -d: -f2)
    last_changed_date=$(echo "$eachline" | cut -d: -f3)

    # We check if the last changed date is an empty string, if it is we continue with our code
    # -z is used to check for strings that are empty 
    if [ -z "$last_changed_date" ]; then
        continue
    fi

    # Get the UID of the user
    user_uid=$(id -u "$username" 2>/dev/null)

    # Check if the user UID is greater than or equal to 1000 (regular user) and not root (UID 0)
    if [ "$user_uid" -ge 1000 ] && [ "$user_uid" -ne 0 ]; then
        # After we have access to our last changed date which is in seconds, we subtract the current date 
        # from the last access date to get the password age
        password_age=$(( (current_date / 86400) - last_changed_date ))

        # Here we check if the password age is greater than the required password age criteria, 
        # if it is, we expire the password so that they'll be forced to set a new one on login
        if [ "$password_age" -gt "$max_passwd_age" ]; then
            echo "$username has a password that is more than 90 days old. Forcing a change on login."
            sudo passwd --expire "$username"
        fi
    fi
done

