#!/usr/bin/env bats

load bats-testlib

setup () {
	say "=================================="
	private-test-dir
	git init .
	setup-default-repo
}

@test "test setup function" {
	verify-graph <<-\EOF
		*  (HEAD -> develop, master)
	EOF
}

@test "simple feature finish" {
	git tag develop-old
	git checkout -b feature/topic1
	git roboedit -n3
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1)
		* 
		* 
		*  (tag: develop-old, master, develop)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	no "feature/topic1" branch
	#	branches merged
	verify-graph <<-\EOF
		*    (HEAD -> develop)
		|\  
		| * 
		| * 
		| * 
		|/  
		*  (tag: develop-old, master)
	EOF
	# TODO: checks:
	#	no fb-branch config
	#	no gitflow config
}

@test "feature finish with NOP feature" {
	git checkout -b feature/topic1
	git feature finish
	# implicit checks:
	#	on develop
	#	no "feature/topic1" branch
	#	no changes
	verify-graph <<-\EOF
		*  (HEAD -> develop, master)
	EOF
}

@test "feature finish with rebase" {
	git checkout -b feature/topic1
	git roboedit -n3
	# "concurrent" commits in develop
	git checkout develop
	git roboedit -n2
	git tag develop-old
	# back to topic1
	git checkout -
	verify-graph <<-\EOF
		*  (tag: develop-old, develop)
		* 
		| *  (HEAD -> feature/topic1)
		| * 
		| * 
		|/  
		*  (master)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	no "feature/topic1" branch
	#	rebase happened
	#	branches merged
	verify-graph <<-\EOF
		*    (HEAD -> develop)
		|\  
		| * 
		| * 
		| * 
		|/  
		*  (tag: develop-old)
		* 
		*  (master)
	EOF
	# TODO: checks:
	#	no fb-branch config
	#	no gitflow config
}

@test "feature finish with rebase and ff merge" {
	git checkout -b feature/topic1 &&
	git roboedit -n1
	# "concurrent" commits in develop
	git checkout develop
	git roboedit -n2
	git tag develop-old
	# back to topic1
	git checkout -
	verify-graph <<-\EOF
		*  (tag: develop-old, develop)
		* 
		| *  (HEAD -> feature/topic1)
		|/  
		*  (master)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	no "feature/topic1" branch
	#	rebase happened
	#	branches merged
	verify-graph <<-\EOF
		*  (HEAD -> develop)
		*  (tag: develop-old)
		* 
		*  (master)
	EOF
	# TODO: checks:
	#	no fb-branch config
	#	no gitflow config
}

@test "feature finish rebase error" {
	git checkout -b feature/topic1
	git roboedit -n1 -f develop.txt
	# "concurrent" commits in develop
	git checkout develop
	git roboedit -n2
	git tag develop-old
	# back to topic1
	git checkout -
	verify-graph <<-\EOF
		*  (tag: develop-old, develop)
		* 
		| *  (HEAD -> feature/topic1)
		|/  
		*  (master)
	EOF
	run git feature finish
	(( status != 0 ))
	# implicit checks:
	#	on develop
	#	in rebase (due to refs/rewritten/onto)
	#	topic1 still open
	verify-graph <<-\EOF
		*  (HEAD, tag: develop-old, refs/rewritten/onto, develop)
		* 
		| *  (feature/topic1)
		|/  
		*  (master)
	EOF
}