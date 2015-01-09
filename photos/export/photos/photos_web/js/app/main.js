define(['./lib', 'knockout', './ViewModel/MainViewModel', 'underscore'], function (lib, ko, mainViewModel, _) {
  ko.applyBindings(new mainViewModel({
    host: 'https://ec2-54-165-129-228.compute-1.amazonaws.com'
  }));
});
