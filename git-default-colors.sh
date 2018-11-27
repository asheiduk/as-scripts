
git_color () {
	# "normal" is used n code but doesn not generate any escape sequence.
	# translating this to "reset" works better in custom formats
	local normal=reset
	# same order as in corresponding *.c file
	case "$1" in
		# from "builtin/branch.c"
		color.branch.plain)				echo $normal;;
		color.branch.remote)			echo red;;
		color.branch.local)				echo $normal;;
		color.branch.current)			echo green;;
		color.branch.upstream)			echo blue;;
		color.branch.*)
			unknown_color_default "$1";;
		# from "log-tree.c"
		color.decorate.branch)			echo "bold green";;
		color.decorate.remoteBranch)	echo "bold red";;
		color.decorate.tag)				echo "bold yellow";;
		color.decorate.stash)			echo "bold magenta";;
		color.decorate.HEAD)			echo "bold cyan";;
		color.decorate.grafted)			echo "bold blue";;
		color.decorate.*)
			unknown_color_default "$1";;
		color.diff.context)				echo $normal;;
		color.diff.meta)				echo bold;;
		color.diff.frag)				echo cyan;;
		color.diff.old)					echo red;;
		color.diff.new)					echo green;;
		color.diff.commit)				echo yellow;;
		color.diff.whitespace)			echo "normal red";;
		color.diff.func)				echo $normal;;
		color.diff.oldMoved)			echo "bold magenta";;
		color.diff.oldMovedAlternative)	echo "bold blue";;
		color.diff.oldMovedDimmed)		echo dim;;
		color.diff.oldMovedAlternativeDimmed)	echo "dim italic";;
		color.diff.newMoved)			echo "bold cyan";;
		color.diff.newMovedAlternative)	echo "bold yellow";;
		color.diff.newMovedDimmed)		echo dim;;
		color.diff.newMovedAlternativeDimmed)	echo "dim italic";;
		color.diff.contextDimmed)		echo dim;;
		color.diff.oldDimmed)			echo "dim red";;
		color.diff.newDimmed)			echo "dim green";;
		color.diff.contextBold)			echo bold;;
		color.diff.oldBold)				echo "bold red";;
		color.diff.newBold)				echo "bold green";;
		color.diff.*)
			unknown_color_default "$1";;
		color.grep.context)				echo $normal;;
		color.grep.filename)			echo $normal;;
		color.grep.function)			echo $normal;;
		color.grep.lineNumber)			echo $normal;;
		color.grep.column)				echo $normal;;
		color.grep.matchContext)		echo "bold red";;
		color.grep.matchSelected)		echo "bold red";;
		color.grep.selected)			echo $normal;;
		color.grep.separator)			echo cyan;;
		color.grep.*)
			unknown_color_default "$1";;
	esac
}