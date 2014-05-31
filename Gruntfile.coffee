module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-war'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    dist: false

    # $ grunt sass
    sass:
      compile:
        options:
          style: '<%= dist ? "compressed" : "expanded" %>'
          banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd hh:mm:ss") %> */\n'
          sourcemap: true
        files: [
          expand: true
          cwd: 'stylesheets'
          src: ['application.scss']
          dest: '<%= dist ? "dist" : "public" %>'
          ext: '.css'
        ]

    # $ grunt coffee
    coffee:
      compile:
        options:
          separator: ';\n'
          sourceMap: true
        files:
          '<%= dist ? "dist" : "public" %>/application.js': [
            'javascripts/application.coffee'
            'javascripts/foo.coffee'
          ]

    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd hh:mm:ss") %> */\n'
      build:
        src: 'src/<%= pkg.name %>.js'
        dest: 'build/<%= pkg.name %>.min.js'


    # Make a war file for servlet style deployment
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

    # $ grunt watch
    watch:
      sass:
        files: 'stylesheets/<%= sass.compile.files[0].src %>'
        tasks: ['sass']
      # coffee:
      #   files: '<%= coffee.compile.src %>'
      #   tasks: ['coffee']
      options:
        reload: true
        atBegin: true

    clean:
      build: ["public/*.*"],
      dist: ["dist/*.*"]

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
    ]
    grunt.task.run "war" if grunt.option('war')
