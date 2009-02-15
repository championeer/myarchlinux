#!/bin/sh

# NOTE: project.sh requires the .todo configuration file to run.
# Place the .todo file in your home directory or use the -d option for
# a custom location.

version() { sed -e 's/^    //' <<EndVersion
        PROJECT.TXT Manager
        Version 1.1
        Author: Michael Stiber (stiber@acm.org), with code liberally
                "borrowed" from TODO.TXT v1.7.3 by Gina Trapani
                (ginatrapani@gmail.com) -- OK, it's basically a
                hacked-up version of todo.txt
        Release date:  8/29/06
        Last updated:  12/10/06
        Version history:
           1.0 (8/29/06): Public release
           1.1 (12/10/06): Added "done" command
        License:  GPL, http://www.gnu.org/copyleft/gpl.html
        More information and mailing list at http://todotxt.com
EndVersion
    exit 1
}

usage()
{
    sed -e 's/^    //' <<EndUsage 
    Usage: project.sh  [-acfhpqvV] [-d todo_config] action project_name [task_number] [task_description]
    Try 'project.sh -h' for more information.    
EndUsage
    exit 1
}


help()
{ 
    sed -e 's/^    //' <<EndHelp
      PROJECT.SH: Add tasks to individual project files; move tasks to
                  main todo.txt file when needed

      Usage:  project.sh [-fhpqvV] [-d todo_config] action [project_name] [task_number] [task_description]

      Actions:
        add PROJECT_NAME "@context THING I NEED TO DO"
        a PROJECT_NAME "@context THING I NEED TO DO"
          Adds everything after PROJECT_NAME to your project file
          PROJECT_NAME.txt in the "projects" subdirectory of your
          todo.txt directory (as defined in your todo_config
          file). Project files are named after the "raw" project name,
          regardless of presence or absence of "+", "p:", or "p-"
          notation.
          Context notation optional.
          Quotes optional.

        append PROJECT_NAME NUMBER "TEXT TO APPEND"
        app PROJECT_NAME NUMBER "TEXT TO APPEND"
          Adds TEXT TO APPEND to the end of the task on line NUMBER of
          project file PROJECT_NAME.txt in your "projects"
          subdirectory.
          Quotes optional.

        del PROJECT_NAME NUMBER
        rm PROJECT_NAME NUMBER
          Deletes the task on line NUMBER in file PROJECT_NAME.txt in
          your "projects" subdirectory.

        done PROJECT_NAME NUMBER
          Moves task on line NUMBER in file PROJECT_NAME.txt in your
          "projects" subdirectory to your todo.txt file, marked as
          done (as the todo.sh "do" command does).

        list PROJECT_NAME [TERM...] 
        ls PROJECT_NAME [TERM...]
          Displays all tasks that contain TERM(s), with line
          numbers, for file PROJECT_NAME.txt in your "projects"
          subdirectory.  If no TERM specified, lists entire
          PROJECT_NAME.txt. See the -s option for sorting options.

        listall
        la
          List all tasks in all projects, with project names prepended
          using '+' notation. Useful for providing input to other
          programs that expect to process todo.txt format files. See
          the -a and -c options for alternative listing notation.

        next [PROJECT_NAME] [NUMBER] 
        n [PROJECT_NAME] [NUMBER] 
          For the specified file PROJECT_NAME.txt in your "projects"
          subdirectory (or all files in that directory, if no
          PROJECT_NAME given), removes task NUMBER (or the first task,
          if no NUMBER given) and adds it to your todo.txt file (with
          +PROJECT_NAME prepended, see the '-a' and '-c' options for
          other prefix styles).

        overview
        over
          List all projects in the project directory.

        prepend PROJECT_NAME NUMBER "TEXT TO PREPEND"
        prep PROJECT_NAME NUMBER "TEXT TO PREPEND"
          Adds TEXT TO PREPEND to the beginning of the task on line
          NUMBER of file PROJECT_NAME.txt in your "projects"
          subdirectory.
          Quotes optional.

        replace PROJECT_NAME NUMBER "UPDATED TODO"
          Replaces task on line NUMBER of file PROJECT_NAME.txt in
          your "projects" subdirectory with UPDATED TODO.
          Quotes optional.

        update [PROJECT_NAME]
        up [PROJECT_NAME]
          For the specified file PROJECT_NAME.txt in your "projects"
          subdirectory (or all files in that directory, if no
          PROJECT_NAME given), removes the first task and adds it to
          your todo.txt file (with +PROJECT_NAME prepended, see the
          '-a' and '-c' options for other prefix styles), if there
          does not already exist a line in todo.txt containing
          PROJECT_NAME.

      Options:

        Note that all relevant options are passed to todo.sh if
        project.sh uses todo.sh to complete its command (for example,
        with the "next" command).

        -a
            Use dash (p-) notation when adding tasks to todo file
        -c
            Use colon (p:) notation when adding tasks to todo file
        -d CONFIG_FILE
            Use a configuration file other than the default ~/.todo
        -f
            Forces actions without confirmation or interactive input
        -h
            Display this help message
        -p
            Plain mode turns off colors
        -s
            List project files sorted like todo.sh (default is in same
            order as in the project file)
        -v 
            Verbose mode turns on confirmation messages
        -V 
            Displays version, license and credits
EndHelp

    exit 1
}

die()
{
    echo "$*"
    exit 1
}

cleanup()
{
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
    exit 0
}

# Remove the "+", "p:", or "p-" from the "project" environment
# variable. This allows users to enter project names in any format
# they want, with project files still named after the "raw" project
# name.
clean_project()
{
    project=${project#+}
    project=${project#p:}
    project=${project#p-}
    return
}


#--------------------------------------------------
#
# Start of main part of shell script

THIS_CMD=`basename $0`

# == PROCESS OPTIONS ==
# defaults
VERBOSE=0
PLAIN=0
CFG_FILE=$HOME/.todo
FORCE=0
OPTION_STRING=""
PROJECT_PREFIX="+"
TODO_SORT=0

while getopts ":acd:fhpqsvV" Option
do
    case $Option in
	a)
	    PROJECT_PREFIX="p-"
	    ;;
	c)
	    PROJECT_PREFIX="p:"
	    ;;
	d)  
	    OPTION_STRING="${OPTION_STRING} -${Option} $OPTARG"
	    CFG_FILE=$OPTARG
	    ;;
	f)
	    OPTION_STRING="${OPTION_STRING} -${Option}"
	    FORCE=1
	    ;;
	h)
	    help
	    ;;
	p)
	    OPTION_STRING="${OPTION_STRING} -${Option}"
	    PLAIN=1 
	    ;;
	q) 
	    OPTION_STRING="${OPTION_STRING} -${Option}"
	    QUIET=1
	    ;;
	s) 
	    TODO_SORT=1
	    ;;
	v) 
	    OPTION_STRING="${OPTION_STRING} -${Option}"
	    VERBOSE=1
	    ;;
	V)
	    version
	    ;;
    esac
done
shift $(($OPTIND - 1))

# === SANITY CHECKS (thanks Karl!) ===
[ -r "$CFG_FILE" ] || die "Fatal error:  Cannot read configuration file $CFG_FILE"

. "$CFG_FILE"

[ -z "$1" ]         && usage
[ -d "$TODO_DIR" ]  || die "Fatal Error: $TODO_DIR is not a directory"  
cd "$TODO_DIR"      || die "Fatal Error: Unable to cd to $TODO_DIR"

echo '' > "$TMP_FILE" || die "Fatal Error:  Unable to write in $TODO_DIR"  
[ -f "$TODO_FILE" ]   || cp /dev/null "$TODO_FILE"
[ -f "$DONE_FILE" ]   || cp /dev/null "$DONE_FILE"
[ -f "$REPORT_FILE" ] || cp /dev/null "$REPORT_FILE"


if [ $PLAIN = 1 ]; then
	PRI_A=$NONE
	PRI_B=$NONE
	PRI_C=$NONE
	PRI_X=$NONE
	DEFAULT=$NONE
fi

PROJ_DIR=${TODO_DIR}/projects
[ -d "$PROJ_DIR" ]  || die "Fatal Error: $PROJ_DIR is not a directory"

# === HEAVY LIFTING ===
shopt -s extglob

# == HANDLE ACTION ==
action=$( printf "%s\n" "$1" | tr 'A-Z' 'a-z' )

case $action in 
"add" | "a")
	errmsg="usage: $THIS_CMD add PROJECT_NAME \"NEW ITEM\""
	shift; project=$1;
	
	clean_project

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt

	if [[ -z "$1" && $FORCE = 0 ]]; then
		echo -n "Add: "
		read input
	else
		[ -z "$1" ] && die "$errmsg"
		shift
		input=$*
	fi
	[[ $VERBOSE = 1 && ! ( -f $projfile ) ]] && echo "$THIS_CMD: Creating project file ${projfile}."
	echo "$input" >> "$projfile" || die "$THIS_CMD: unable to write $projfile"

	TASKNUM=$(wc -l "$projfile" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
	[[ $VERBOSE = 1 ]] && echo "$THIS_CMD: '$input' added as task $TASKNUM of project $project."
	cleanup;;


"append" | "app" )
	errmsg="usage: $THIS_CMD append PROJECT_NAME ITEM# \"TEXT TO APPEND\""
	shift; project=$1; shift; item=$1; shift

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	[ -z "$item" ] && die "$errmsg"
	[[ "$item" = +([0-9]) ]] || die "$errmsg"

	if [[ -z "$1" && $FORCE = 0 ]]; then
		echo -n "Append: "
		read input
	else
		input=$*
	fi

	if sed -ne "$item p" "$projfile" | grep "^."; then
		if sed -i.bak $item" s|^.*|& $input|" "$projfile"; then
		        NEWTODO=$(sed "$item!d" "$projfile")
		        [[ $VERBOSE = 1 ]] && echo "$item: $NEWTODO"
		else
			echo "$THIS_CMD:  Error appending task $item."
		fi
	else
		echo "$item: No such item in file $projfile."
	fi
	cleanup;;


"del" | "rm" )
	errmsg="usage: $THIS_CMD del PROJECT_NAME ITEM#"
	shift; project=$1;

	clean_project

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	item=$2
	[ -z "$item" ] && die "$errmsg"
	[[ "$item" = +([0-9]) ]] || die "$errmsg"
	if sed -ne "$item p" "$projfile" | grep "^."; then
		DELETEME=$(sed "$2!d" "$projfile")

		if  [ $FORCE = 0 ]; then
		    echo "Delete '$DELETEME'?  (y/n)"
			read ANSWER
		else
			ANSWER="y"
		fi
		
	    if [ "$ANSWER" = "y" ]; then
		       sed -i.bak -e $2"s/^.*//" -e '/./!d' "$projfile"
		       [[ $VERBOSE = 1 ]] && echo "$THIS_CMD:  '$DELETEME' deleted."
		       cleanup
		else
			echo "$THIS_CMD:  No tasks were deleted."
		fi
	else
		echo "$item: No such todo."
        fi ;;


"done" )
	errmsg="usage: $THIS_CMD done PROJECT_NAME ITEM#"
	shift; project=$1; shift; item=$1

	clean_project

	# Both arguments are required
	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	[ -z "$item" ] && die "$errmsg"

	[[ $VERBOSE = 1 ]] && echo "Adding item $item from project $project to todos; marking as done."

	# the following must be modified if the todo.sh file syntax
	# for marking items done is modified
	now=`date '+%Y-%m-%d'`
	todo.sh $OPTION_STRING add x $now ${PROJECT_PREFIX}${project} $(sed "${item}!d" "$projfile") || die "Unable to add $item from project $project to todos"

	    sed -i.bak -e "${item}s/^.*//" -e '/./!d' "$projfile"
	cleanup;;


"list" | "ls" )
	errmsg="usage: THIS_CMD list PROJECT_NAME [TERM...]"
	shift; project=$1;

	clean_project

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	item=$2
	if [ -z "$item" ]; then
	    if [ $TODO_SORT = 0 ]; then
		cat -b $projfile
	    else
		echo -e "`sed = "$projfile" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/'`"
	    fi
	    echo "--"
	    NUMTASKS=$(wc -l "$projfile" | sed 's/^[[:space:]]*\([0-9]*\).*/\1/')
	    echo "$THIS_CMD: $NUMTASKS tasks in project $project."
	else
	    if [ $TODO_SORT = 0 ]; then
		cat -b $projfile | grep -i $item
	    else
		command=`sed = "$projfile" | sed 'N; s/^/  /; s/ *\(.\{2,\}\)\n/\1 /' | sed 's/^ /0/' | sort -f -k2 | sed '/^[0-9][0-9] x /!s/\(.*(A).*\)/'$PRI_A'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(B).*\)/'$PRI_B'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*(C).*\)/'$PRI_C'\1'$DEFAULT'/g' | sed '/^[0-9][0-9] x /!s/\(.*([A-Z]).*\)/'$PRI_X'\1'$DEFAULT'/' | grep -i $item `
		shift
		shift
		for i in $*
		do
		    command=`echo "$command" | grep -i $i `
		done
		command=`echo "$command" | sort -f -k2`
	    
		echo -e "$command"
	    fi
	fi
	cleanup ;;


"listall" | "la")
	errmsg="usage: $THIS_CMD listall"

	projfiles="${PROJ_DIR}/*.txt"
	for f in $projfiles
	do
	    project=`basename $f`
	    project=${project%.txt}
	    awk -v projname="${PROJECT_PREFIX}${project}" '{print projname, $0;}' $f
	done
	cleanup;;


"next" | "n")
	errmsg="usage: $THIS_CMD next [PROJECT_NAME] [ITEM#]"
	shift; project=$1; shift; item=$1

	clean_project

	# If project name not given, command applies to all project files
	if [[ -n "$project" ]]; then
	    projfile=${PROJ_DIR}/${project}.txt
            [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"
	    [[ -z "$item" ]] && item=1
	    [[ $VERBOSE = 1 ]] && echo "Adding item $item from project $project to todos"
	    todo.sh $OPTION_STRING add ${PROJECT_PREFIX}${project} $(sed "${item}!d" "$projfile") || die "Unable to add $item from project $project to todos"

	    sed -i.bak -e "${item}s/^.*//" -e '/./!d' "$projfile"
	else
            if  [ $FORCE = 0 ]; then
                echo "Add task from all project files? (y/n)"
                read ANSWER
            else    
                ANSWER="y"
            fi      
                
            if [ "$ANSWER" = "y" ]; then
	        projfiles="${PROJ_DIR}/*.txt"
	        for f in $projfiles
	        do
		    project=`basename $f`
		    project=${project%.txt}
		    [[ $VERBOSE = 1 ]] && echo "Adding item 1 from project $project to todos"
		    todo.sh $OPTION_STRING add ${PROJECT_PREFIX}${project} `head -1 $f` || die "Unable to add item from project $project to todos"
		    sed -i.bak -e "1s/^.*//" -e '/./!d' "$f"
	        done
            fi
	fi
	cleanup;;


"overview" | "over" )
	echo "Projects in project file directory:"
	printf "%-20s\t%-10s\n" "PROJECT" "TASKS"
	
	projfiles="${PROJ_DIR}/*.txt"
	for f in $projfiles
	do
	    project=`basename $f`
	    project=${project%.txt}
	    printf "%-20s\t%-4d\n" $project `cat $f | wc -l`
	done
	cleanup;;


"prepend" | "prep" )
	errmsg="usage: $THIS_CMD prepend PROJECT_NAME ITEM# \"TEXT TO PREPEND\""
	shift; project=$1; shift; item=$1; shift

	clean_project

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	[ -z "$item" ] && die "$errmsg"
	[[ "$item" = +([0-9]) ]] || die "$errmsg"

	if [[ -z "$1" && $FORCE = 0 ]]; then
		echo -n "Prepend: "
		read input
	else
		input=$*
	fi

	if sed -ne "$item p" "$projfile" | grep "^."; then
		if sed -i.bak $item" s|^.*|$input &|" "$projfile"; then
		        NEWTODO=$(sed "$item!d" "$projfile")
		        [[ $VERBOSE = 1 ]] && echo "$item: $NEWTODO"
		else
			echo "$THIS_CMD:  Error prepending task $item."
		fi
	else
		echo "$item: No such item in file $projfile."
	fi
	cleanup;;


"replace" )
	errmsg="usage: $THIS_CMD replace PROJECT_NAME ITEM# \"UPDATED ITEM\""
	shift; project=$1; shift; item=$1; shift

	clean_project

	[ -z "$project" ] && die "$errmsg"
        projfile=${PROJ_DIR}/${project}.txt
        [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"

	[ -z "$item" ] && die "$errmsg"
	[[ "$item" = +([0-9]) ]] || die "$errmsg"
	
	if [[ -z "$1" && $FORCE = 0 ]]; then
		echo -n "Replacement: "
		read input
	else
		input=$*
	fi
	
	if sed -ne "$item p" "$projfile" | grep "^."; then
		sed -i.bak $item" s|^.*|$input|" "$projfile"
		[[ $VERBOSE = 1 ]] && NEWTODO=$(head -$item "$projfile" | tail -1)
		[[ $VERBOSE = 1 ]] && echo "replaced with"
		[[ $VERBOSE = 1 ]] && echo "$item: $NEWTODO"
	else
		echo "$item: No such item in file $projfile."
	fi
	cleanup;;


"update" | "up")
	errmsg="usage: $THIS_CMD update [PROJECT_NAME]"
	shift; project=$1;

	clean_project

	# If project name not given, command applies to all project files
	if [[ -n "$project" ]]; then
	    projfile=${PROJ_DIR}/${project}.txt
            [ -f "$projfile" ] || die "$THIS_CMD: $projfile nonexistent"
	    if grep "${PROJECT_PREFIX}${project}" $TODO_FILE > /dev/null; then
		[[ $VERBOSE = 1 ]] && echo "Task for ${project} already in todo file; use \"next\" command to force."
	    else
		[[ $VERBOSE = 1 ]] && echo "Adding item 1 from project $project to todos"
		todo.sh $OPTION_STRING add ${PROJECT_PREFIX}${project} `head -1 $projfile` || die "Unable to add item from project $project to todos"
		sed -i.bak -e "1s/^.*//" -e '/./!d' "$projfile"
	    fi
	else
	    projfiles="${PROJ_DIR}/*.txt"
	    printf "%-10s\t%4s\t%-50s\n" "PROJECT" "LINE" "COMMENT"
	    for f in $projfiles
	    do
		project=`basename $f`
		project=${project%.txt}
		if grep "${PROJECT_PREFIX}${project}" $TODO_FILE > /dev/null ; then
		    printf "%-10s\t%4s\t%-50s\n" $project "*" "Todo file already has task; use \"next\" to force."
		else
		    printf "%-10s\t%4d\t%-50s\n" $project 1 "Added to todo file"
		    todo.sh $OPTION_STRING add ${PROJECT_PREFIX}${project} `head -1 $f` || die "Unable to add item from project $project to todos"
		    sed -i.bak -e "1s/^.*//" -e '/./!d' "$f"
		fi
	    done
	fi
	cleanup;;


    * )
	usage
esac
