#!/bin/bash
# Provide an interractive menu to create-delete users, create-delete groups, add users to group,
# lock-unlock user account and list all users or groups.

source ~/linux-health-monitor/config.cfg

while true; do
	echo ""
	echo "	|-------------------------------- User Manager Menu ------------------------------------|
	|		1) ➕ Create user		6) 📋 List all users			|
	|		2) 🗑️ Delete user		7) 📋 List all groups with their users	|
	|		3) ➕ Create group		8) 🔒︎Lock user account			|
	|		4) 🗑️ Delete group		9) ꗃ Unlock user account		|
	|		5) ➕ Add user to group		0) ➜] Exit				|
	|---------------------------------------------------------------------------------------|"
	echo ""

	read -p 'Choose option [0-9]: ' option


	case $option in
		1) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			echo ""
			read -p "👉 The user's name is: " username
			if id "$username" &>/dev/null; then
				echo ""
				echo "❌ The user $username is already existing"
			else
				sudo useradd -m -s /bin/bash $username	# Create a new user
				echo ""
				echo "✅ The user $username has been created"
				echo -e "To: $EMAIL\nSubject: Creating a user\n\nThe user $username has been created at $TIMESTAMP.\nHome directory: /home/$username\nLogin shell: /bin/bash" | msmtp -t
			fi;;


		2) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 The user's name is: " username
                        if id "$username" &>/dev/null; then
                                sudo userdel -r $username	# Delete the user
				echo ""
				echo "✅ The user $username has been deleted"
				echo -e "To: $EMAIL\nSubject: Deleting a user\n\nThe user $username has been deleted completly at $TIMESTAMP." | msmtp -t
                        else
				echo ""
                                echo "❌ The user $username does not exist"
			fi;;


		3) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 The group's name is: " groupname
                        if getent group | grep "$groupname" &>/dev/null; then
                                echo ""
				echo "❌ The group $groupname is already existing"
                        else
                                sudo groupadd $groupname  # Create a new group
                                echo ""
				echo "✅ The group $groupname has been created"
				echo -e "To: $EMAIL\nSubject: Creating a group\n\nThe group $groupname has been created at $TIMESTAMP." | msmtp -t
                        fi;;


                4) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 The group's name is: " groupname
                        if getent group | grep "$groupname" &>/dev/null; then
                                sudo groupdel $groupname   # Delete the group
				echo ""
				echo "✅ The group $groupname has been deleted"
				echo -e "To: $EMAIL\nSubject: Deleting a group\n\nThe group $groupname has been deleted at $TIMESTAMP." | msmtp -t
                        else
				echo ""
				echo "❌ The group $groupname does not exist"
			fi;;


		5) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 Please write the user's name: " username
			if id $username &>/dev/null; then
				read -p "👉 Please give which group you want to use: " groupname
				if getent group | grep "$groupname" &>/dev/null; then
					sudo usermod -aG $groupname $username	# Add a user to a group
					echo ""
					echo "✅ The user $username has been added to $groupname group"
					echo -e "To: $EMAIL\nSubject: Adding a user to a group\n\nThe user $username has been added successfully to $groupname at $TIMESTAMP." | msmtp -t
				else
					echo ""
					echo "❌ Sorry, the group $groupname is not existing"
				fi
			else
				echo ""
				echo "❌ Sorry, the user $username is not existing"
			fi;;
		
		
		6) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			echo "👉 The users are: "	# List all users
			awk -F: '$3 >= 1000 {print $1}' /etc/passwd;;


		7) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			echo "👉 The groups are: "	# List all groups that have users
			getent group | awk -F: '$3 >= 1000 && $3 <= 2000 && $4 != "" {print $1 ": " $4}';;


		8) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 Which user you want to lock? " username
			if id $username &>/dev/null; then
				sudo usermod -L $username	# Lock a user
				echo ""
				echo "✅ The user $username has been locked"
				echo -e "To: $EMAIL\nSubject: Locking a user\n\nThe user $username has been locked at $TIMESTAMP." | msmtp -t
			else
				echo ""
				echo "❌ The user $username does not exist"
			fi;;


		9) TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
			read -p "👉 Which user you want to unlock? " username
                        if id $username &>/dev/null; then
                                sudo usermod -U $username       # unLock a user
				echo ""
				echo "✅ The user $username has been unlocked"
				echo -e "To: $EMAIL\nSubject: unlocking a user\n\nThe user $username has been unlocked at $TIMESTAMP." | msmtp -t
                        else
				echo ""
				echo "❌ The user $username does not exist"
			fi;;


		0) echo ""
			echo "Have a nice day, sir 👋"
			exit 0;;

		*) echo "⚠️  Looks like you choose an invalid option. Try again please";;

	esac
done
