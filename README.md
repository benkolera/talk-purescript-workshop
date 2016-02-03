# Purescript Workshop - Getting Started

## Tooling Installation

You'll want the following things:

- NodeJS and NPM
- the purescript compiler (binary compiled haskell program)
- pulp, a build tool for purescript (you may want this for a repl)
- bower (used by pulp for managing purescript dependencies. See [http://harry.garrood.me/blog/purescript-why-bower/|Why Bower?])

All of these can be install via NPM:

```npm install -g purescript pulp bower```

## Running this Module

- ```npm install && bower install```
- ```npm run-script server```
- Open your browser to http://localhost:8080/ and open the JS console.
- You should see a web page and a console message that says "Purescript Workshop Loaded OK! :)"
