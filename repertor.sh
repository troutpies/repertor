# !bin/bash

# repertor
#  quickly find a file and open it

# TODO:
#   - check mimetype for an existing app
#

# load the config
#
configfile="$HOME/.config/thud/repertor/config.sh"
if [[ -e $configfile ]]; then
    source "$configfile"
fi

# process the args, and get then get the last argument
while getopts 'd:p:t:v:bh' OPTION; do
    case "$OPTION" in
    
    d)  # search dir
        dval="$OPTARG"
        ;;

    p)  # picker: fzf, rofi, dmenu
        pval="$OPTARG"
        ;;

    t)  # type: pdf,txt,jpg,png,etc.
        tval="$OPTARG"
        ;;

    v)  # viewer
        vval="$OPTARG"
        ;;

    b)  # verBose
        verbose=1
        ;;

    h)  # help text
        echo "This is the help text"
        exit 0
        ;;

    ?)  # catchall: return error and help text
        echo "see the help text"
        exit 1
        ;;
    esac
done
shift "$(($OPTIND -1))"

# let's set some vars

# get the value
#  directory with the -d parameter takes precedence
#  default to current dir
searchdir=$( if [[ -n $dval ]]; then 
        echo $dval 
    elif [[ -n $1 ]]; then
        echo $1
    elif [[ -n $default_dir ]]; then
        echo $default_dir
    else 
        echo "$PWD"
    fi
)

# if the specified directory is relative, we need to check it
searchdir=$( if [[ "$searchdir" =~ ^[^/] ]]; then       # valid directory
        if [[ -d "$PWD/$searchdir" ]]; then
            echo "$PWD/$searchdir/"
        elif [[ -d "$HOME/$searchdir" ]]; then
            echo "$HOME/$searchdir"
        else
            echo "Not a valid directory"
            exit 1
        fi
    elif [[ -d "$searchdir" ]]; then
        echo "$searchdir/"
    else
        echo "$searchdir is not a valid directory"
    fi
)

fprompt=$( echo $searchdir | sed -e 's/^.*\/\([^/]*\)\/$/\1/')

picker=$( if [[ -n $pval ]]; then 
        echo $pval 
    elif [[ -n $default_picker ]]; then
        echo $default_picker
    else 
        echo "fzf" 
    fi )

type=$( if [[ -n $tval ]]; then 
        echo ".*($tval)$"
    elif [[ -n $default_type ]]; then
        echo ".*($default_type)$"
    else 
        echo ".*\.(.*)$" 
    fi )

viewer=$( if [[ -n $vval ]]; then 
        echo "$vval"
    elif [[ -n $default_viewer ]]; then
        echo $default_viewer
    else 
        echo "xdg-open" 
    fi )

if [[ $verbose -gt 0 ]]; then
    echo "searchdir: $searchdir"
    echo "picker: $picker"
    echo "type: $type"
    echo "viewer: $viewer"
    echo "fprompt: $fprompt"
fi

# copied from my original script
export FZF_DEFAULT_OPTS

selected=$( find "$searchdir" -type f -regextype "egrep" -regex "$type" | 
    sed -e "s/^${searchdir//\//\\\/}//g" |
    $picker )
echo $selected

# check if selected exists before passing it to the command
if [[ -n "$selected" && -e "$searchdir$selected" ]]; then
    $($viewer "$searchdir$selected") &
fi
