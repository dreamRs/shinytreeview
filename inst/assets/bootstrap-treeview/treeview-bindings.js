/**
 * treeviewInput Shiny bindings
 *
 *
 */

var treeviewInputBinding = new Shiny.InputBinding();
$.extend(treeviewInputBinding, {
  find: function(scope) {
    return scope.querySelectorAll(".treeview-input");
  },
  getId: function(el) {
    return el.id;
  },
  getValue: function(el) {
    var tree = $(el).data("treeview");
    try {
      return tree.getSelected();
    } catch (error) {
      return null;
    }
  },
  setValue: function(el, value) {},
  subscribe: function(el, callback) {
    $(el).on("nodeSelected", function(event, data) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".treeviewInputBinding");
  },
  receiveMessage: function(el, data) {},
  getState: function(el) {},
  initialize: function(el) {
    var element = document.getElementById(el.id);

    var config = element.querySelector('script[data-for="' + el.id + '"]');
    config = JSON.parse(config.innerHTML);

    $(el).treeview(config);
  }
});
Shiny.inputBindings.register(
  treeviewInputBinding,
  "shinytreeview.treeviewInput"
);

