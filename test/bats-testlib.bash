
say () {
	printf 1>&3 "%s\n" "$*"
}

# call like this:
#	git-flow-config-for feature &&
#	git-flow-config-for bugfix
git-flow-config-for () {
	local type="$1"
	git config gitflow.$type.finish.fetch true           # Fetch
	git config gitflow.$type.finish.rebase true          # Rebase auf develop
	git config gitflow.$type.finish.no-ff false          # Merge-Commit nur bei mehr als
	git config gitflow.$type.finish.keep false           # Branch löschen
	git config gitflow.$type.finish.keepremote false     # Remote-Branch löschen
	git config gitflow.$type.finish.keeplocal false      # Lokalen Branch löschen
	git config gitflow.$type.finish.preserve-merges true # Merge-Commits Rebasen
	git config gitflow.$type.rebase.preserve-merges true # Merge-Commits Rebasen
}

private-test-dir () {
	local test_filename="$(basename "$BATS_TEST_FILENAME")"
	test_filename="${test_filename%.*}"
	
	local private_dir
	printf -v private_dir "tmp/%s/%02d-%s" "$test_filename" "$BATS_TEST_NUMBER" "$BATS_TEST_NAME"

	if [ -e "$private_dir" ]
	then
		rm -rf "$private_dir"
	fi &&
	mkdir -p "$private_dir" &&
	cd "$private_dir"
}

setup-default-repo (){
	git commit --quiet --allow-empty -m "0" &&
	git checkout -b develop
}

commit () {
	local message="$1"
	local branch="$2"
	
	[ -n "$branch" ] || branch=$(git symbolic-ref --quiet --short HEAD || echo 'HEAD')
	local file=$(echo "$branch" | tr / - ).txt
	
	printf "%s\n" "$message" >> "$file" &&
	git add -- "$file" &&
	git commit --quiet -m "$message" &&
	printf "committed %s\n" "$message"
}
	
verify-graph (){
	sed 's/[[:space:]]*$//' > log.exp &&
	git log --format="%d" --graph --all | sed 's/[[:space:]]*$//' > log.act &&
	diff -c log.exp log.act
}

assert-config () {
	local key="$1"
	local exp="$2"
	local act

	if [ -z "${2+X}" ]
	then
		# check for unset values
		act=$(git config "$key") && {
			printf "git-config '%s' returned value '%s' instead of an error\n" "$key" "$act"
			return 10
		}
		return 0
	else
		# check for value match
		act=$(git config "$key") || {
			printf "git-config '%s' returned error %d\n" "$key" $?
			return 11
		}
		[ "$act" = "$exp" ] || {
			printf "git-config value is wrong: actual='%s', expected='%s'\n" "$act" "$exp"
			return 12
		}
	fi
}
