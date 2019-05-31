#!/usr/bin/env bats

load bats-testlib

setup () {
	say "=================================="
	private-test-dir
	git init .
	setup-default-repo
}

@test "test 'feature start' command (default 'develop')" {
	verify-graph <<-\EOF
		*  (HEAD -> develop, master)
	EOF
	git feature start topic1
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1, master, develop)
	EOF
	assert-config gitflow.branch.feature/topic1.base "develop"
}

@test "test 'feature start' command (gitflow 'develop')" {
	git branch -M develop develop-gf
	git config gitflow.branch.develop develop-gf
	verify-graph <<-\EOF
		*  (HEAD -> develop-gf, master)
	EOF
	git feature start topic1
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1, master, develop-gf)
	EOF
	assert-config gitflow.branch.feature/topic1.base "develop-gf"
}

@test "verify base branch checks" {
	# default is 'develop' -- should work
	run git feature start topic1
	(( status == 0 ))
	git checkout develop

	# rename 'develop' to 'dev' -- should fail
	git branch -M develop dev
	run git feature start topic2
	(( status == 6 ))
	[ "$output" = "The base branch 'develop' for this feature branch does not exists." ]

	# change/set config -- should work again
	git config gitflow.branch.develop dev
	run git feature start topic2
	(( status == 0 ))
}

@test "verify feature-branch checks" {
	git checkout -b feature/topic1
	run git feature start topic1
	(( $status == 7 ))
	[ "$output" = "The feature branch 'feature/topic1' does already exist!" ]
}
