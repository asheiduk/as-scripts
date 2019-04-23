
declare -A _BASH_ABBR

abbr () {
	if [ -n "$READLINE_POINT" ]
	then
		local prefix=${READLINE_LINE%% *}
	
		[ -n "$prefix" ] || return
	
		local replace=${_BASH_ABBR[$prefix]}
		[ -n "$replace" ] || return
	
		replace="$replace "
		READLINE_LINE="$replace${READLINE_LINE:${#prefix}}"
		READLINE_POINT=${#replace}
		
		return
	fi

	case $# in
		0 )
			local name
			for name in $(printf "%s\n" "${!_BASH_ABBR[@]}" | sort)
			do
				printf "abbr %s '%s'\n" "$name" "${_BASH_ABBR[$name]}"
			done
			;;
		1 )
			unset _BASH_ABBR[$1]
			;;
		* )
			local name="$1"
			shift
			_BASH_ABBR[$name]="$*"
			;;
	esac	
}
