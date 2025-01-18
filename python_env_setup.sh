#!/bin/bash

# running this script should be sourced for it to have effect
current_dir=$(pwd)
# put into a function to call it later so all functions would be defined and they are defined in probable order of execution
main () {
	#if the file contains the -s flag use the default settings
	if [[ "${@//-/}" =  s ]]
	then
		init "default_env"
		activate
		return 0
	else
		echo -e "please enter your env name: "
		read env_name 
		init $env_name
		activate	
	fi

	select opt in "load" "freeze" "interactive" "return"
	do
		case $REPLY in
			1)
				load
				;;
			2)
				freeze
				return 0
				;;
			3)
				prepping
				return 0
				;;
			4)
				return 0
				;;
			*)
				echo "please enter a valid option"
				;;
		esac	
	done
}

activate () {
	# activating the current venv as your main python env
	source "$path/bin/activate"
}

init () {

	path="$current_dir/$1"
	if [[ -d $path ]]
	then
		echo "already exists"
	else
		# using -m runs the venv module found in the sysfile form python
		python3 -m venv "$path"
	fi
	git_ignore $1

}

git_ignore () {

	ignore_path="$current_dir/.gitignore"

	if [[ -e $ignore_path ]]
	then
		check=$(grep -o "$1/" $ignore_path)
		if [[ -z $check ]]
		then
			echo "$1/" >> $ignore_path
			echo "__pycache__/"  >> $ignore_path
		fi
	else

		git --git-dir "$current_dir/.git" init
		echo "$1/" >> $ignore_path
		echo "__pycache__/"  >> $ignore_path
	fi

	echo "all set up"
}

freeze () {

	echo "enter your requirements file"
	read req
	
	pip freeze >> "$current_dir/$req"
}

load () {
	echo  "please specify your requirements file location and name: "	
	read req
	pip install -r $req	
}

prepping () {

	select opt in "install a library" "freeze" "quit" 
	do
		case $REPLY in
			1)
				echo "enter library name: "
				read lib
				pip install $lib
				;;
			2)
				freeze
				return 0
				;;
			3)
				return 0
				;;
			*)
				echo "please enter a valid option"
				;;
		esac	
	done
}


main $@
