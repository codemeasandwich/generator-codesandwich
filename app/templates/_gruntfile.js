module.exports = function(grunt) {

  // Configuration goes here
  grunt.initConfig({

 pkg: grunt.file.readJSON('package.json'),

    // Coffee to JS compilation
    coffee: {
        compile:{
            files: [{
                expand: true,
                cwd: 'source/scripts',
                src: ['**/*.coffee'],
                dest: 'prod/scripts',
                ext: '.js'
            }]
        }
    },
    // Move other files to production folder
    copy: {
      target: {
        files: [{
          expand: true, // Enable dynamic expansion.
          dot: true,
          cwd: 'source',
          src: ['*.html',
                'styles/**.css',
                'images/**',<% if(iconsMoon){ %>
                'fonts/**',     <% } %>
                'scripts/**.js'],
          dest: 'prod'
        }
        <% if(iconsAwesome){ %>,
        {
          expand:true,
          cwd: 'bower_components/font-awesome/css',
          src: ['font-awesome.min.css'],
          dest:'prod/styles'
        }
        ,
        {
          expand:true,
          cwd: 'bower_components/font-awesome/fonts',
          src: ['**'],
          dest:'prod/fonts'
        }
        <% } %>
        ]
      }
    }
  });
      // Load plugins here
      grunt.loadNpmTasks('grunt-contrib-copy');
      grunt.loadNpmTasks('grunt-contrib-coffee');

  // Define your tasks here
  grunt.registerTask('default', ['coffee', 'copy']);
}