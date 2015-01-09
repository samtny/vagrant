define(['jquery', 'underscore', 'knockout', './FolderViewModel', './ResourceViewModel'], function ($, _, ko, folderViewModel, resourceViewModel) {
  return function mainViewModel(options) {
    var main = this,
      resourceWidth = 214,
      debounceSearch = 500,
      debounceLayout = 300;

    main.title = ko.observable('Photos');
    main.host = options.host;
    main.searchValue = ko.observable();
    main.folders = ko.observableArray([]);
    main.folders_display = ko.observable('list');
    main.resources = ko.observableArray([]);
    main.preview = ko.observable();

    main.doSearch = function () {
      main.resources.removeAll();
      main.getResources({ search: main.searchValue() });
    };

    main.doSearchDebounced = _.debounce(main.doSearch, debounceSearch);

    main.searchKeyUp = function (unused, e) {
      main.searchValue(e.currentTarget.value);
      main.doSearchDebounced();
    };

    main.resourceClick = function (resource) {
      resource.selected(!resource.selected());
      main.preview(new resourceViewModel(resource.data, main.host, '722x722'));
      main.initLayout();
    };

    main.folderClick = function (folder) {
      main.resources.removeAll();
      main.getResources({ folder_id: folder.id() });
    };

    main.addResources = function (data) {
      _.each(data, function (item) {
        main.resources.push(new resourceViewModel(item, main.host));
      });
    };

    main.addFolders = function (data) {
      _.each(data, function (item) {
        main.folders.push(new folderViewModel(item));
      });
    };

    main.getResources = function (data) {
      $.ajax({
        url: main.host + '/resource_list',
        data: data
      })
        .done(main.addResources);
    };

    main.getFolders = function (data) {
      $.ajax({
        url: main.host + '/folder_list',
        data: data
      })
        .done(main.addFolders);
    };

    main.initLayout = function () {
      var innerHeight = window.innerHeight,
        resourcesWrapperWidth = $('.resources-wrapper').width();

      $(".folders-wrapper, .resources-wrapper, .preview-wrapper").height((innerHeight - 72) + 'px');
      $(".resources").width((Math.floor(resourcesWrapperWidth / resourceWidth) * resourceWidth) + 'px');
    };

    main.initLayoutDebounced = _.debounce(main.initLayout, debounceLayout);

    main.init = function () {
      main.initLayout();
      window.onresize = main.initLayoutDebounced;
      main.getFolders({ parent: '' });
    };

    main.init();
  };
});
