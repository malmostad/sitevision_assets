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
    forDist: false

    # $ grunt sass
    sass:
      compile:
        options:
          style: '<%= forDist ? "compressed" : "expanded" %>'
          banner: '<%= banner %>'
          sourcemap: grunt.option('sourcemaps')
        files: [
          expand: true
          cwd: 'src/stylesheets'
          src: [
            # Use the Sass declarations `@import` in the main scss file application.scss
            'application.scss'
            # Individual files
            'ie7.scss'
          ]
          dest: '<%= forDist ? "dist" : "public" %>'
          ext: '.css'
        ]

    # $ grunt coffee
    coffee:
      compile:
        options:
          sourceMap: grunt.option('sourcemaps')
        files:
          '<%= forDist ? "dist" : "public" %>/application.js': [
            # Files to compile and concatenate in given order
            'src/javascripts/contact_us.coffee'
            'src/javascripts/feedback.coffee'
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
        files: 'src/stylesheets/*.scss'
        tasks: ['sass']
      coffee:
        files: 'src/javascripts/*.coffee'
        tasks: ['coffee']
      options:
        reload: true
        liveReload: true
        atBegin: true

    # $ grunt watch
    # $ grunt watch[build:dist]
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

  # $ grunt build
  grunt.registerTask 'build', ["clean:build", "sass", "coffee"]

  # $ grunt dist
  # $ grunt dist --war
  grunt.registerTask 'dist', ->
    grunt.log.writeln("\nYOUR GRUNT ENCODING IS: " + grunt.file.defaultEncoding + " (must be utf8)")
    grunt.config "forDist", true
    grunt.task.run [
      "clean:dist"
      "sass"
      "coffee"
      "uglify"
    ]
    grunt.task.run "war" if grunt.option('war')
