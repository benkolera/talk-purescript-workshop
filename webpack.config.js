'use strict';

var PurescriptWebpackPlugin = require('purescript-webpack-plugin');

var src = ['bower_components/purescript-*/src/**/*.purs', 'src/**/*.purs'];

var ffi = ['bower_components/purescript-*/src/**/*.js', 'src/**/*FFI.js'];

var modulesDirectories = [
  'node_modules',
  'bower_components'
];

var config
  = { entry: './src/entry'
    , debug: "true"
    , output: 
      { path: __dirname
      , pathinfo: true
      , filename: 'app.js'
      }
    , module: 
      { loaders: [ 
        { test: /\.purs$/
        , loader: 'purs-loader?output=output'
        }
      ] }
    , resolve: 
      { modulesDirectories: ["node_modules","bower_components","output"]
      , extensions: [ '', '.js', '.purs'] 
      }
    , plugins: 
      [ new PurescriptWebpackPlugin(
        { src: src
        , ffi: ffi
        , stats: 
          { cached: false
          , cachedAssets: false
          }
        })
      ]
    };

module.exports = config;
