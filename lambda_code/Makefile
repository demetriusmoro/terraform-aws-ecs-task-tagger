.PHONY: all pack test deploy

all:
	make pack
	make test
	make deploy

pack:
	rm -rf .deploy/ 2> /dev/null || true
	mkdir .deploy
	cd .deploy; cp ../start.py ./start.py
	cd .deploy; zip -q lambda_package.zip start.py && rm start.py

test:
	test -f .deploy/lambda_package.zip || false

deploy:
	cp .deploy/lambda_package.zip ../assets
	rm -rf .deploy/ 2> /dev/null
