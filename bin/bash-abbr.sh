
declare -A _BASH_ABBR

abbr () {
	if [ -n "$READLINE_POINT" ]
	then
		local prefix=${READLINE_LINE:0:$READLINE_POINT}
	
		[ -n "$prefix" ] || return
	
		local replace=${_BASH_ABBR[$prefix]}
		[ -n "$replace" ] || return
	
		replace="$replace "
		READLINE_LINE="$replace${READLINE_LINE:$READLINE_POINT}"
		READLINE_POINT=${#replace}
		
		return
	fi

	case $# in
		0 )
			local name
			for name in "${!_BASH_ABBR[@]}"
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
