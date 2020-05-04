#!/bin/bash

# update_all_body.sh

#REPO_PATH=/home/user/workspace
WORKSPACE=$HOME/workspace
ROSE_SYSTEM=$HOME/.rose

GITHUB_NETGROUP="https://github.com/netgroup"

i=0

REPO_NAMES[$i]=rose-vm-build
GIT_BASE[$i]=$GITHUB_NETGROUP
TARGET[$i]=$ROSE_SYSTEM
i=$((i+1))

REPO_NAMES[$i]=draft-srv6-tutorial
GIT_BASE[$i]=$GITHUB_NETGROUP
TARGET[$i]=$WORKSPACE
i=$((i+1))

END=$i

printandexec () {
		echo "$@"
		eval "$@"
}


for ((i=0;i<END;i++)); 

do
	REPO_NAME="${REPO_NAMES[$i]}"
        echo "$REPO_NAME"
	REPO_DIR="${TARGET[$i]}/$REPO_NAME"
        echo "$REPO_DIR"
	if [ -d $REPO_DIR ]; then
		echo ""
  		# It will enter here if $REPO_dir exists.
		printandexec cd $REPO_DIR

		if [ "$(git status | grep 'nothing to commit')" ]; then
			#echo "nothing to commit, working directory clean"
			git pull
		else
		#if [ ! "$(git status | grep 'nothing to commit, working directory clean')" ]; then
			printandexec git status
			echo ""
			echo "Your working directory $REPO_DIR has some changes."
			echo "What do you want to do:"
			echo "- Delete (stash) your changes and pull from git [d/D]"
			echo "- Do nothing (skip pull) [n/N]"
			echo "- Try to pull [Press any other key]"
			read -r -p "? " response
			if [[ $response =~ ^([dD])$ ]]; then
	    		printandexec git stash
	    		printandexec git pull
	    	else
				if [[ $response =~ ^([nN])$ ]]; then
					echo "skipped"
		    	else
		    		printandexec git pull
		    	fi
			fi
		fi	
	else 
		echo ""
		echo "Directory $REPO_DIR is not present"
		if [ "$1" = "clone_repos" ];then
			cd "${TARGET[$i]}"
				printandexec git clone "${GIT_BASE[$i]}/$REPO_NAME.git"
		fi	

	fi
done