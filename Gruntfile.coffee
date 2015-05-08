module.exports = ->
  grunt = @
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    browserify:
      dist:
        files:
          'dist/alan-view.js': ['src/main.coffee']
        options:
          browserifyOptions:
            extensions: ['.coffee']
            fullPaths: false
            standalone: 'alan-view'

    # CoffeeScript compilation of tests
    coffee:
      spec:
        options:
          bare: true
        expand: true
        cwd: 'spec'
        src: ['**.coffee']
        dest: 'spec'
        ext: '.js'
      src:
        options:
          bare: true
        expand: true
        cwd: 'src'
        src: ['**.coffee']
        dest: 'src'
        ext: '.js'

    # Automated recompilation and testing when developing
    watch:
      files: ['spec/*.coffee', 'src/*.coffee']
      tasks: ['test']

    # Coding standards
    coffeelint:
      components: ['Gruntfile.coffee', 'spec/*.coffee', 'src/*.coffee']
      options:
        'max_line_length':
          'level': 'ignore'

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-contrib-coffee'
  # @loadNpmTasks 'grunt-contrib-uglify'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-contrib-watch'
  #@loadNpmTasks 'grunt-cafe-mocha'
  #@loadNpmTasks 'grunt-mocha-phantomjs'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-browserify'

  @registerTask 'build', 'Build for the chosen target platform', (target = 'all') =>
    @task.run 'coffee'
    @task.run 'browserify'
    # if target is 'all' or target is 'browser'
    #   @task.run 'uglify'

  @registerTask 'test', 'Build and run automated tests', (target = 'all') =>
    @task.run 'coffeelint'
    @task.run 'coffee'
    # if target is 'all' or target is 'nodejs'
    #   @task.run 'cafemocha'
    # if target is 'all' or target is 'browser'
    #   @task.run 'mocha_phantomjs'


  @registerTask 'default', ['test']
