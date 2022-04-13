.PHONY: watch all setup

all: node_modules out/server.js out/extension.js
	

watch: node_modules
	tsc --watch

setup: node_modules
node_modules:
	npm install yarn
	yarn

src/%.ne.ts: syntaxes/%.ne
	npx nearleyc $< | $@

out/server.js: src/server.ts src/intercal.ne.ts
	tsc

out/%.js: src/%.ts
	tsc
