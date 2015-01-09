define(['knockout', 'underscore'], function (ko, _) {
  var folderViewModel = function (data) {
    var folder = this;

    folder.id = ko.observable(data._id.$id);
    folder.name = ko.observable(data.name);
    folder.children = ko.observableArray([]);
    folder.expanded = ko.observable(false);

    _.each(data.children, function (item) {
      folder.children.push(new folderViewModel(item));
    });
  };

  folderViewModel.prototype.toggleExpanded = function () {
    this.expanded(!this.expanded());
  };

  return folderViewModel;
});
