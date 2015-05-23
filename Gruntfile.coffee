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
        cwd: 'specs'
        src: ['**.coffee']
        dest: 'specs'
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
      files: ['specs/*.coffee', 'src/*.coffee']
      tasks: ['test']

    # Coding standards
    coffeelint:
      components: ['Gruntfile.coffee', 'specs/*.coffee', 'src/*.coffee']
      options:
        max_line_length:
          level: 'ignore'

  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-browserify'

  @registerTask 'build', ['coffee', 'browserify']
  @registerTask 'test', ['coffeelint', 'coffee']
  @registerTask 'default', ['build']
