#!/bin/bash
read -p "What is your name :" yourname
var="submission_reminder_${yourname}"
mkdir -p "$var"
mkdir -p "$var/app" "$var/modules" "$var/assets" "$var/config"
cat << EOF > "$var/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
cat << EOF > "$var/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
cat << EOF > "$var/assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Teta, Shell Basics, submitted
Francis, Shell Basics, not submitted
ghissy, Shell Basics, submitted
Jospin, Shell Basics, not submitted
marie, Shell Basics, submitted
Sarah, Shell Basics, not submitted
EOF
cat << EOF > "$var/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2# 
EOF
cat << EOF > "$var/startup.sh"
#!/bin/bash
source /config/config.env
source /modules/functions.sh
./$var/app/reminder.sh
EOF
chmod +x *.sh

echo "The working directory has been successfullly created in $var"
