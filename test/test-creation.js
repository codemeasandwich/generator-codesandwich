/*global describe, beforeEach, it */
'use strict';
var path = require('path');
var helpers = require('yeoman-generator').test;
var devDir = "source";

describe('codesandwich generator', function () {
  beforeEach(function (done) {
    helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
      if (err) {
        return done(err);
      }

      this.app = helpers.createGenerator('codesandwich:app', [
        '../../app'
      ]);
      done();
    }.bind(this));
  });

  it('creates expected files', function (done) {
    var expected = [
      // add files you expect to exist here.
      '.jshintrc',
      '.editorconfig',
      'bower.json',
      'package.json',
      'Gruntfile.js',

        devDir+'/crossdomain.xml',
        devDir+'/favicon.ico',
        devDir+'/index.html',
        devDir+'/404.html',
        devDir+'/robots.txt',
        devDir+'/manifest.webapp',

        devDir+'/styles/boilerplate.css',
        devDir+'/styles/foundation.css',
        devDir+'/styles/normalize.css',

        devDir+'/scripts/helper.coffee',
        devDir+'/scripts/plugins.coffee'
    ];
    //This Object is what will be passed to "prompts" function as the argument
    //So you are better of setting all the values ;)
    helpers.mockPrompt(this.app, {
      'appName': 'placeName',
      'addIcons': [ 'awesome', 'moon' ],
      'addTouchIcons': true,
      'gAnalyticsID': 'UA-000000-01',
      'crossDomainXML': true
    });

    this.app.options['skip-install'] = true;
    this.app.run({}, function () {
      helpers.assertFile(expected);
      done();
    });
  });
});
