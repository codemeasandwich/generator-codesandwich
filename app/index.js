'use strict';
var util   = require('util');
var path   = require('path');
var yeoman = require('yeoman-generator');
var prompts = require('./prompts.js');
var build = require('./build.js');

var CodesandwichGenerator = yeoman.generators.Base.extend({
  init: function () {
    this.pkg = require('../package.json');

    this.on('end', function () {
      if ( ! this.options['skip-install']) {
        this.installDependencies();
      }
    });
  },

  askFor: prompts.genPrompt,
  app: build.genApp,

  projectfiles: function () {
    this.copy('editorconfig', '.editorconfig');
    this.copy('jshintrc', '.jshintrc');
    this.copy('_package.json', 'package.json');
    this.template('_bower.json', 'bower.json');
    this.template('_gruntfile.js','Gruntfile.js');
  }
});

module.exports = CodesandwichGenerator;
