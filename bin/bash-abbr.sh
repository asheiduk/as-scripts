
declare -A _BASH_ABBR

abbr () {
	if [ -n "$READLINE_POINT" ]
	then
		local prefix=${READLINE_LINE%% *}
	
		[ -n "$prefix" ] || return
	
		local replace=${_BASH_ABBR[$prefix]}
		[ -n "$replace" ] || return

		# With "xxx" defined as "X Y Z" and "^" the cursor position:
		#
		#	xxx^		--> X Y Z ^		# note the space!
		#	xxx arg^	--> X Y Z arg^	# note no space
		#	xxx ar^g	--> X Y Z ar^g
		#
		if (( READLINE_POINT == ${#prefix} ))
		then
			# replace immediately after keyword --> insert additional space
			READLINE_LINE="$replace ${READLINE_LINE:${#prefix}}"
			(( READLINE_POINT = READLINE_POINT - ${#prefix} + ${#replace} + 1 ))
		else
			READLINE_LINE="$replace${READLINE_LINE:${#prefix}}"
			(( READLINE_POINT = READLINE_POINT - ${#prefix} + ${#replace} ))
		fi
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
