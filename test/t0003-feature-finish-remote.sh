#!/usr/bin/env bats

load bats-testlib

setup () {
	say "=================================="
	private-test-dir
	git init --bare repo-central.git
	git clone --origin origin42 repo-central.git repo-work
	cd repo-work
	setup-default-repo
	git push --set-upstream origin42 master develop
}

@test "test setup function" {
	verify-graph <<-\EOF
		*  (HEAD -> develop, origin42/master, origin42/develop, master)
	EOF
}

@test "feature finish with remote branches" {
	# start feature branch
	git checkout -b feature/topic1
	commit t1
	commit t2
	commit t3
	git push --set-upstream origin42 feature/topic1
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1, origin42/feature/topic1)
		* 
		* 
		*  (origin42/master, origin42/develop, master, develop)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	neither local nor remote feature branches
	#	branches merged
	#	upstreams untouched
	verify-graph <<-\EOF
		*    (HEAD -> develop)
		|\  
		| * 
		| * 
		| * 
		|/  
		*  (origin42/master, origin42/develop, master)
	EOF
}

@test "feature finish while develop ahead upstream" {
#	skip "value of this test is questionable"
	# we are ahead of origin42/develop
	commit d1
	# now start feature branch
	git tag develop-old
	git checkout -b feature/topic1
	commit t1
	commit t2
	commit t3
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1)
		* 
		* 
		*  (tag: develop-old, develop)
		*  (origin42/master, origin42/develop, master)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	no "feature/topic1" branch
	#	branches merged
	#	upstreams untouched
	verify-graph <<-\EOF
		*    (HEAD -> develop)
		|\  
		| * 
		| * 
		| * 
		|/  
		*  (tag: develop-old)
		*  (origin42/master, origin42/develop, master)
	EOF
}

@test "feature finish while develop behind upstream with fetch" {
	# we are behind develop@{upstream} (and don't know it!)
	commit d1
	git push
	git reset --hard @~
	git update-ref refs/remotes/origin42/develop @
	# now start feature branch
	git tag develop-old
	git checkout -b feature/topic1
	commit t1
	commit t2
	commit t3
	verify-graph <<-\EOF
		*  (HEAD -> feature/topic1)
		* 
		* 
		*  (tag: develop-old, origin42/master, origin42/develop, master, develop)
	EOF
	git feature finish
	# implicit checks:
	#	on develop
	#	develop@{upstream} was updated
	#	feature branch was rebased onto updated develop@{upstream}
	#	feature branch was merged
	#	feature branch is gone
	verify-graph <<-\EOF
		*    (HEAD -> develop)
		|\  
		| * 
		| * 
		| * 
		|/  
		*  (origin42/develop)
		*  (tag: develop-old, origin42/master, master)
	EOF
}

@test "feature finish with diverged develop" {
	# create develop@{upstream}
	commit d1
	git push
	git reset --hard @~
	# create diverged develop
	commit d2
	git tag develop-old
	# now start feature branch from develop~
	git checkout -b feature/topic1 @~
	commit t1
	commit t2
	commit t3
	verify-graph <<-\EOF
		*  (tag: develop-old, develop)
		| *  (HEAD -> feature/topic1)
		| *
		| *
		|/
		| *  (origin42/develop)
		|/
		*  (origin42/master, master)
	EOF
	run git feature finish
	(( status == 10 ))
	# implicit checks:
	#	nothing changed
	verify-graph <<-\EOF
		*  (tag: develop-old, develop)
		| *  (HEAD -> feature/topic1)
		| *
		| *
		|/
		| *  (origin42/develop)
		|/
		*  (origin42/master, master)
	EOF
}
