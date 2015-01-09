define(['bootstrap', 'jquery', 'knockout'], function (bootstrap, $, ko) {
  ko.bindingHandlers.pageTitle = {
    update: function (element, pageTitle) {
        document.title = ko.unwrap(pageTitle());
    }
  };

  return {
    getBody: function () {
      return $('body');
    }
  }
});
