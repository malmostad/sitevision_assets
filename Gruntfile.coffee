module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-war'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd hh:mm:ss") %> */'
    dist: false

    # $ grunt sass
    sass:
      compile:
        options:
          style: '<%= dist ? "compressed" : "expanded" %>'
          banner: '<%= banner %>'
          sourcemap: grunt.option('sourcemaps')
        files: [
          expand: true
          cwd: 'stylesheets'
          src: [
            # Use the Sass declarations `@import` in the main scss file application.scss
            'application.scss'
            # Individual files
            'ie7.scss'
          ]
          dest: '<%= dist ? "dist" : "public" %>'
          ext: '.css'
        ]

    # $ grunt coffee
    coffee:
      compile:
        options:
          sourceMap: grunt.option('sourcemaps')
        files:
          '<%= dist ? "dist" : "public" %>/application.js': [
            # Files to compile and concatenate in given order
            'javascripts/contact_us.coffee'
            'javascripts/feedback.coffee'
          ]

    uglify:
      options:
        banner: '<%= banner %>\n'
      build:
        src: 'dist/application.js'
        dest: 'dist/application.js'

    # $ grunt watch
    watch:
      sass:
        files: 'stylesheets/*.scss'
        tasks: ['sass']
      coffee:
        files: 'javascripts/*.coffee'
        tasks: ['coffee']
      options:
        reload: true
        liveReload: true
        atBegin: true

    clean:
      build: ["public/*.*"],
      dist: ["dist/*.*"]

    # Make a war file for servlet deployment
    # $ grunt war
    war:
      target:
        options:
          war_dist_folder: 'dist'
          war_verbose: true
          war_name: 'local-assets-v4'
          webxml_display_name: 'Local Assets v4'
          webxml_welcome: ""
        files: [
          expand: true
          cwd: 'dist'
          src: ['*.js', '*.css']
          dest: ''
        ]

  # tasks
  # grunt.registerTask 'default', ['sass', 'coffee', 'concat', 'uglify', 'war', 'watch']

  # $ grunt build
  grunt.registerTask 'build', ->
    grunt.task.run [
      "clean:build"
      "sass"
      "coffee"
    ]

  # $ grunt dist
  # $ grunt dist --war
  grunt.registerTask 'dist', ->
    grunt.config "dist", true
    grunt.task.run [
      "clean:dist"
      "sass"
      "coffee"
      "uglify"
    ]
    grunt.task.run "war" if grunt.option('war')
