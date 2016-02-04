// These are dirty hacks to make the livereloading work. Remember to add new files here!

// Webpack when watching is smart enough to only watch files that are part of the build
// process. But the files that are loaded as purescript deps don't get added to this list.
// pulp server fixes this with a hack: https://github.com/bodil/pulp/blob/master/src/Pulp/Server.purs#L62
require("./ThermiteEx/Intro.purs");
require("./ThermiteEx/State.purs");
require("./ThermiteEx/Actions.purs");
require("./ThermiteEx/Components.purs");
require("./ThermiteEx/Lists.purs");
require("./ThermiteEx/Hax.purs");

// Maybe this is because purs-loader could be better or maybe it's a limitation of webpack. Dunno.

require("./Main.purs").main()
