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
