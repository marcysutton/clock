'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'
//
module.exports = function(grunt) {
  // show elapsed time at the end
  require('time-grunt')(grunt);

  grunt.loadNpmTasks('grunt-notify');

  require('load-grunt-tasks')(grunt);

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // configurable paths
    config: {
      app: 'app',
      dist: 'dist',
      test: 'test'
    },
    watch: {
      coffee: {
        files: ['<%= config.app %>/scripts/{,*/}*.coffee'],
        tasks: ['coffeelint:app','browserify']
      },
      compass: {
        files: ['<%= config.app %>/styles/{,*/}/*.{scss,sass}'],
        tasks: ['compass:server']
      },
      styles: {
        files: ['<%= config.app %>/styles/{,*/}*.css'],
        tasks: ['copy:styles']
      },
      tests: {
        files: ['<%= config.test %>/specs/*.coffee'],
        tasks: ['browserify', 'mocha']
      },
      livereload: {
        options: {
          livereload: '<%= connect.options.livereload %>'
        },
        files: [
          '<%= config.app %>/*.html',
          '.tmp/styles/{,*/}*.css',
          '{.tmp,<%= config.app %>}/scripts/{,*/}*.js',
          '<%= config.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      }
    },
    connect: {
      options: {
        port: 8001,
        livereload: 35729,
        // change this to '0.0.0.0' to access the server from outside
        hostname: '0.0.0.0'
      },
      livereload: {
        options: {
          open: true,
          base: [
            '.tmp',
            '<%= config.app %>'
          ]
        }
      },
      test: {
        options: {
          hostname: 'localhost',
          port: 3000,
          base: [
            '.tmp',
            'test',
            '<%= config.app %>'
          ]
        }
      },
      dist: {
        options: {
          open: true,
          base: '<%= config.dist %>'
        }
      }
    },
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= config.dist %>',
            '!<%= config.dist %>/.git*'
          ]
        }]
      },
      server: '.tmp'
    },
    coffeelint: {
      options: {
        max_line_length: {
          level: 'ignore'
        }
      },
      app: [
        '<%= config.app %>/scripts/{,*/}*.coffee'
      ],
      test: [
        '<%= config.test %>/specs/{,*/}*.coffee'
      ]
    },
    compass: {
      options: {
        sassDir: '<%= config.app %>/styles',
        cssDir: '.tmp/styles',
        generatedImagesDir: '.tmp/images/generated',
        imagesDir: '../images',
        javascriptsDir: '<%= config.app %>/scripts',
        fontsDir: '<%= config.app %>',
        httpImagesPath: '../images',
        httpGeneratedImagesPath: '/images/generated',
        httpFontsPath: '../fonts',
        relativeAssets: false,
        assetCacheBuster: false
      },
      dist: {
        options: {
          generatedImagesDir: '<%= config.dist %>/images/generated',
          debugInfo: false
        }
      },
      server: {
        options: {
          debugInfo: false
        }
      }
    },
    htmlmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= config.app %>',
          src: '*.html',
          dest: '<%= config.dist %>'
        }]
      }
    },
    useminPrepare: {
      options: {
        dest: '<%= config.dist %>'
      },
      html: '<%= config.app %>/index.html'
    },
    usemin: {
      options: {
        dirs: ['<%= config.dist %>']
      },
      html: ['<%= config.dist %>/{,*/}*.html'],
      css: ['<%= config.dist %>/styles/{,*/}*.css']
    },
    // Put files not handled in other tasks here
    copy: {
      js_css: {
        expand: true,
        cwd: '.tmp',
        dest: '<%= config.dist %>',
        src: ['{,*/}*.css', '{,*/}*.js']
      },
      assets: {
        expand: true,
        cwd: '<%= config.app %>',
        dest: '<%= config.dist %>',
        src: ['images/*', 'fonts/*']
      },
      styles: {
        expand: true,
        dot: true,
        cwd: '<%= config.app %>/styles',
        dest: '.tmp/styles/',
        src: '{,*/}*.css'
      }
    },
    concat: {
      basic: {
        src: ['<%= config.app %>/bower_components/underscore/underscore-min.js',
              '<%= config.app %>/bower_components/backbone/backbone-min.js',
              '<%= config.app %>/bower_components/jquery/jquery.min.js',
              '<%= config.app %>/vendor_scripts/*.js'
              ],
        dest: '.tmp/scripts/vendor.js'
      }
    },
    browserify: {
      options: {
        transform: ['coffeeify'],
        extensions: ['.js', '.coffee']
      },
      app: {
        src: ['<%= config.app %>/scripts/**/*.js', '<%= config.app %>/scripts/**/*.coffee'],
        dest: '.tmp/scripts/application.js'
      },
      test: {
        src: ['<%= config.test %>/specs/*.js', '<%= config.test %>/specs/*.coffee'],
        dest: '<%= config.test %>/spec.js'
      }
    },
    mocha: {
      all: {
        options: {
          run: true,
          urls: ['http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html']
        },
        src: ['<%= config.test %>/specs/{,*/}.js']
      }
    },
    concurrent: {
      server: [
        'compass:dist',
        'browserify:app'
      ],
      test: [
        'browserify:test'
      ],
      dist: [
        'compass:dist',
        'browserify:app',
        'copy:styles',
        'htmlmin'
      ]
    },
    notify: {
      mocha: {
        options: {
          message: 'All tests passed!'
        }
      }
    }
  });

  grunt.registerTask('server', function (target) {
    if (target === 'dist') {
        return grunt.task.run(['build', 'connect:dist:keepalive']);
    }

    grunt.task.run([
      'clean:server',
      'coffeelint:app',
      'test',
      'concurrent:server',
      'connect:livereload',
      'watch'
    ]);
  });

  grunt.registerTask('test', [
    'clean:server',
    'coffeelint:test',
    'concurrent:test',
    'connect:test',
    'mocha',
    'notify'
  ]);

  grunt.registerTask('build', [
    'coffeelint:app',
    'clean:dist',
    'useminPrepare',
    'concurrent:dist',
    'concat',
    'usemin',
    'copy:js_css',
    'copy:assets'
  ]);

  grunt.registerTask('default', [
    'build'
  ]);

};
