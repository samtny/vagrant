requirejs.config({
  baseUrl: 'js/lib',
  paths: {
    'app': '../app',
    'bootstrap': '//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min',
    'knockout': '//cdnjs.cloudflare.com/ajax/libs/knockout/3.1.0/knockout-min',
    'jquery': '//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min',
    'underscore': '//cdnjs.cloudflare.com/ajax/libs/underscore.js/1.7.0/underscore-min'
  },
  shim: {
    bootstrap: {
      deps: ['jquery']
    },
    jquery: {
      exports: '$'
    },
    underscore: {
      exports: '_'
    }
  }
});
