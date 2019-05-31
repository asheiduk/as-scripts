#!/usr/bin/env bats

load bats-testlib

@test "no command" {
	run git feature
	(( status == 1 ))
}

@test "wrong command" {
	run git feature xyz
	(( status == 1 ))
}