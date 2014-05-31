module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    # $ grunt sass
    sass:
      compile:
        options:
          style: 'expanded'
          banner: '/*! <%= pkg.name %> <%= pkg.version %> <%= grunt.template.today("yyyy-mm-dd hh:mm:ss") %> */\n'
        files: [
          expand: true
          cwd: 'stylesheets'
          src: ['application.scss']
          dest: 'dist'
          ext: '.css'
        ]

    # $ grunt coffee
    coffee:
      compile:
        # expand: true
        # cwd: 'javascripts'
        files:
          'dist/application.js': [
            'javascripts/application.coffee'
            'javascripts/foo.coffee'
          ]
        # src: ['*.coffee']
        # dest: 'build'
        # ext: '.js'
        options:
          # bare: false
          sourceMap: true
          # preserve_dirs: true

    concat:
      options:
        separator: '\n'
      cwd: 'build'
      dist:
        src: [
          'application.js'
          'foo.js'
        ]
        dest: 'dist/application.js'

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

    # $ grunt watch (or simply grunt)
    watch:
      html:
        files: ['**/*.html']
      sass:
        files: '<%= sass.compile.files[0].src %>'
        tasks: ['sass']
      coffee:
        files: '<%= coffee.compile.src %>'
        tasks: ['coffee']
      options:
        livereload: true

  # load plugins
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-war'

  # tasks
  grunt.registerTask 'default', ['sass', 'coffee', 'concat', 'uglify', 'war', 'watch']
