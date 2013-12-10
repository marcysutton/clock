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
        tasks: ['browserify']
      },
      compass: {
        files: ['<%= config.app %>/styles/{,*/}/*.{scss,sass}'],
        tasks: ['compass:server']
      },
      styles: {
        files: ['<%= config.app %>/styles/{,*/}*.css'],
        tasks: ['copy:styles']
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
        port: 8888,
        livereload: 35729,
        // change this to '0.0.0.0' to access the server from outside
        hostname: 'localhost'
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
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: [
        '<%= config.app %>/scripts/{,*/}*.js',
        '!<%= config.app %>/scripts/vendor_scripts/*',
        '<%= config.test %>/spec/{,*/}*.js'
      ]
    },
    mocha: {
      all: {
        options: {
          run: true,
          urls: ['http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html']
        },
        src: ['.tmp/spec/{,*/}.js']
      }
    },
    compass: {
      options: {
        sassDir: '<%= config.app %>/styles',
        cssDir: '.tmp/styles',
        generatedImagesDir: '.tmp/images/generated',
        imagesDir: '<%= config.app %>/images',
        javascriptsDir: '<%= config.app %>/scripts',
        fontsDir: '<%= config.app %>/styles/fonts',
        httpImagesPath: '/images',
        httpGeneratedImagesPath: '/images/generated',
        httpFontsPath: '/styles/fonts',
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
          debugInfo: true
        }
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
    browserify: {
      options: {
        transform: ['coffeeify'],
        extensions: ['.js', '.coffee']
      },
      basic: {
        src: ['<%= config.app %>/scripts/**/*.js', '<%= config.app %>/scripts/**/*.coffee'],
        dest: '.tmp/scripts/application.js'
      },
      test: {
        src: ['<%= config.test %>/spec/{,*/}.coffee'],
        dest: '.tmp/spec/spec.js'
      }
    },
    concurrent: {
      server: [
        'compass:dist',
        'browserify'
      ],
      test: [
        'compass:dist',
        'browserify',
        'browserify:test'
      ],
      dist: [
        'compass:dist',
        'browserify',
        'copy:styles',
        'htmlmin'
      ]
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
    // Put files not handled in other tasks here
    copy: {
      main: {
        expand: true,
        cwd: '/',
        dest: '<%= config.dist %>',
        src: ['.tmp/**']
      },
      styles: {
        expand: true,
        dot: true,
        cwd: '<%= config.app %>/styles',
        dest: '.tmp/styles/',
        src: '{,*/}*.css'
      }
    }
  });

  grunt.registerTask('server', function (target) {
    if (target === 'dist') {
        return grunt.task.run(['build', 'connect:dist:keepalive']);
    }

    grunt.task.run([
      'clean:server',
      'concurrent:server',
      'connect:livereload',
      'watch'
    ]);
  });

  grunt.registerTask('test', [
    'jshint',
    'clean:server',
    'concurrent:test',
    'connect:test',
    'mocha'
  ]);

  grunt.registerTask('build', [
    'jshint',
    'clean:dist',
    'useminPrepare',
    'concurrent:dist',
    'usemin',
    'copy:main'
  ]);

  grunt.registerTask('default', [
    'build'
  ]);

};
