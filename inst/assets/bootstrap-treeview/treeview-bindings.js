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
  getType: function(el) {
    if ($(el).attr("data-return") == "name") {
      return "treeview.name";
    } else {
      return "treeview.all";
    }
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
    $(el).on("nodeUnselected", function(event, data) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".treeviewInputBinding");
  },
  receiveMessage: function(el, data) {
    var tree = $(el).data("treeview");
    if (data.hasOwnProperty("search")) {
      if (data.search.collapse) {
        tree.collapseAll();
      }
      tree.search(data.search.pattern, data.search.options);
    }
    if (data.hasOwnProperty("expand")) {
      if (data.expand.hasOwnProperty("nodeId")) {
        var expandedNode = tree.findNodes("^" + data.expand.nodeId + "$", "nodeId");
        tree.expandNode(expandedNode, data.expand.options);
      } else {
        tree.expandAll(data.expand.options);
      }
    }
    if (data.hasOwnProperty("collapse")) {
      if (data.collapse.hasOwnProperty("nodeId")) {
        var collapsedNode = tree.findNodes("^" + data.collapse.nodeId + "$", "nodeId");
        tree.collapseNode(collapsedNode);
      } else {
        tree.collapseAll();
      }
    }
  },
  getState: function(el) {},
  initialize: function(el) {
    var element = document.getElementById(el.id);

    var options = element.querySelector('script[data-for="' + el.id + '"]');
    options = JSON.parse(options.innerHTML);

    $(el).treeview(options.config);
    var tree = $(el).treeview(true);
    $(el).on("rendered ", function(event, data) {
      if (options.hasOwnProperty("selected")) {
        var selected = tree.search(options.selected, {
          ignoreCase: false,
          exactMatch: true,
          revealResults: false
        });
        tree.selectNode(selected);
        tree.search("", {
          ignoreCase: false,
          exactMatch: true,
          revealResults: false
        });
      }
      var nodes = tree.getNodes().map(function(o) {
        return {text: o.text, nodeId: o.nodeId, parentId: o.parentId};
      });
      Shiny.onInputChange(el.id + "_nodes:treeview.nodes", nodes);
    });
  }
});
Shiny.inputBindings.register(
  treeviewInputBinding,
  "shinytreeview.treeviewInput"
);

