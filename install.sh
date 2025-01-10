#!/bin/bash
set -e

# stick the script execution context in the project root dir
SCRIPT_DIR=$(dirname "$0")
cd "$SCRIPT_DIR" || exit

prompt_yes_no() {
    local response
    while true; do
        read -r -p "$1 [y/N]: " response
        response=$(echo "$response" | tr '[:upper]' '[:lower]')  # convert to lowercase
        if [[ "$response" == "y" || "$response" == "yes" ]]; then
            return 0
        elif [[ "$response" == "n" || "$response" == "no" || -z "$response" ]]; then
            return 1
        else
            echo "Invalid input. Please enter 'y(es)' or 'n(o)'."
        fi
    done
}

validate_email() {
    local email=$1
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# initialize and update submodules
git submodule init || exit
git submodule update || exit

# Build the images, start the services
docker-compose up -d || exit

# even though we use OAuth initial admin account must me created to be able to login
if prompt_yes_no "Do you want to create the initial admin account?"; then
    while true; do
        read -r -p "Enter admin email (must be a valid OAuth provider email otherwise you will not be able to login): " admin_email
        if validate_email "$admin_email"; then
            break
        else
            echo "Invalid email address. Please try again."
        fi
    done

    curl --location 'http://localhost:42070/dev/users' \
    --header 'Content-Type: application/json' \
    --data-raw "{
        \"email\": \"$admin_email\",
        \"fullName\": \"Admin Admin\",
        \"firstName\": \"Admin\",
        \"lastName\": \"Admin\",
        \"role\": \"admin\"
    }"
fi

echo "Thank you for trying Ragu, now that you have completed the initial setup you can manage the Ragu stack with docker-compose"