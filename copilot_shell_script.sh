#!/bin/bash

# Ask for the name used to create the project folder
read -p "Enter your name (used when you created the project): " yourname

# Build the folder path
var="submission_reminder_${yourname}"
config_path="${var}/config/config.env"
startup_script="${var}/startup.sh"

# Check if the folder exists
if [ ! -d "$var" ]; then
    echo "Error: Directory $var does not exist."
    exit 1
fi

# Prompt for new assignment and days remaining
read -p "Enter new assignment name: " new_assignment
read -p "Enter number of days remaining: " days_remaining

# Check if inputs are valid
if [ -z "$new_assignment" ] || [ -z "$days_remaining" ]; then
    echo "Error: Both fields are required."
    exit 1
fi

# Overwrite the config.env file with new values
cat > "$config_path" << EOF
# This is the config file
ASSIGNMENT="$new_assignment"
DAYS_REMAINING=$days_remaining
EOF

echo "Config updated:"
cat "$config_path"
echo "-------------------------"

# Run the reminder app
echo "Starting the reminder application..."
bash "$startup_script"
 
