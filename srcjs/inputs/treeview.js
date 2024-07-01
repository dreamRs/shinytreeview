/* jshint esversion: 6 */
/* globals Shiny */
import $ from "jquery";
import "shiny";
import "patternfly-bootstrap-treeview/dist/bootstrap-treeview.min.js";
import "patternfly-bootstrap-treeview/dist/bootstrap-treeview.min.css";
import * as utils from "../modules/utils";
import "../css/styles.css";

var treeviewInputBinding = new Shiny.InputBinding();
$.extend(treeviewInputBinding, {
  find: function(scope) {
    return $(scope).find(".treeview-input");
  },
  getId: function(el) {
    return el.id;
  },
  getType: function(el) {
    if ($(el).attr("data-return") == "name") {
      return "treeview.name";
    } else if ($(el).attr("data-return") == "id") {
      return "treeview.id";
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
    $(el).on("initialized", function(event, data) {
      callback();
    });
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
    if (data.hasOwnProperty("label")) {
      var labelNode = document.getElementById(el.id + "-label");
      utils.updateLabel(data.label, $(labelNode));
    }
    if (data.hasOwnProperty("selected")) {
      if (data.selected.length < 1) {
        var nodes = tree.getSelected();
        tree.unselectNode(nodes);
      }
      var selected;
      for (let i = 0; i < data.selected.length; i++) {
        selected = data.selected[i];
        selected = selected.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
        selected = tree.search(selected, {
          ignoreCase: false,
          exactMatch: true,
          revealResults: false
        });
        if (selected.length < 1) {
          selected = tree.findNodes("^" + data.selected[i] + "$", "id");
        }
        tree.selectNode(selected);
        var parents = tree.getParents(selected);
        var maxLevel = Math.max.apply(
          Math,
          parents.map(function(o) {
            return o.level;
          })
        );
        tree.expandNode(parents, { levels: maxLevel, silent: true });
      }
      tree.clearSearch();
    }
    if (data.hasOwnProperty("search")) {
      if (data.search.collapse) {
        tree.collapseAll();
      }
      if (data.search.pattern.length > 1) {
        data.search.pattern.map(function(pattern) {
          tree.search(pattern, data.search.options);
        });
      } else {
        tree.search(data.search.pattern, data.search.options);
      }
    }
    if (data.hasOwnProperty("clearSearch")) {
     tree.clearSearch(); 
    }
    if (data.hasOwnProperty("expand")) {
      if (data.expand.hasOwnProperty("nodeId")) {
        var expandedNode = tree.findNodes(
          "^" + data.expand.nodeId + "$",
          "nodeId"
        );
        var parentNodes = tree.getParents(expandedNode);
        tree.expandNode(parentNodes.concat(expandedNode), data.expand.options);
      } else {
        tree.expandAll(data.expand.options);
      }
    }
    if (data.hasOwnProperty("collapse")) {
      if (data.collapse.hasOwnProperty("nodeId")) {
        var collapsedNode = tree.findNodes(
          "^" + data.collapse.nodeId + "$",
          "nodeId"
        );
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
        var selected;
        for (let i = 0; i < options.selected.length; i++) {
          selected = options.selected[i];
          selected = selected.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
          selected = tree.search(selected, {
            ignoreCase: false,
            exactMatch: true,
            revealResults: false
          });
          if (selected.length < 1) {
            selected = tree.findNodes("^" + options.selected[i] + "$", "id");
          }
          tree.selectNode(selected);
          var parents = tree.getParents(selected);
          var maxLevel = Math.max.apply(
            Math,
            parents.map(function(o) {
              return o.level;
            })
          );
          tree.expandNode(parents, { levels: maxLevel, silent: true });
        }
        tree.clearSearch();
      }
      var nodes = tree.getNodes().map(function(o) {
        return { text: o.text, nodeId: o.nodeId, parentId: o.parentId };
      });
      if (options.nodes_input) {
        Shiny.onInputChange(el.id + "_nodes:treeview.nodes", nodes);
      }
    });
  }
});
Shiny.inputBindings.register(
  treeviewInputBinding,
  "shinytreeview.treeviewInput"
);

var treecheckInputBinding = new Shiny.InputBinding();
$.extend(treecheckInputBinding, {
  find: function(scope) {
    return $(scope).find(".treecheck-input");
  },
  getId: function(el) {
    return el.id;
  },
  getType: function(el) {
    if ($(el).attr("data-return") == "name") {
      return "treeview.name";
    } else if ($(el).attr("data-return") == "id") {
      return "treeview.id";
    } else {
      return "treeview.all";
    }
  },
  getValue: function(el) {
    var tree = $(el).data("treeview");
    try {
      return tree.getChecked();
    } catch (error) {
      return null;
    }
  },
  setValue: function(el, value) {},
  subscribe: function(el, callback) {
    $(el).on("nodeChecked", function(event, data) {
      callback();
    });
    $(el).on("nodeUnchecked", function(event, data) {
      callback();
    });
  },
  unsubscribe: function(el) {
    $(el).off(".treecheckInputBinding");
  },
  receiveMessage: function(el, data) {
    var tree = $(el).data("treeview");
    if (data.hasOwnProperty("label")) {
      var labelNode = document.getElementById(el.id + "-label");
      utils.updateLabel(data.label, $(labelNode));
    }
    if (data.hasOwnProperty("selected")) {
      tree.uncheckAll();
      var selected;
      for (let i = 0; i < data.selected.length; i++) {
        selected = data.selected[i];
        selected = selected.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
        selected = tree.search(selected, {
          ignoreCase: false,
          exactMatch: true,
          revealResults: false
        });
        if (selected.length < 1) {
          selected = tree.findNodes("^" + data.selected[i] + "$", "id");
        }
        for (let j = 0; j < selected.length; j++) {
          if (!selected[j].state.checked) {
            tree.toggleNodeChecked(selected[j]);
          }
        }
      }
      tree.search("", {
        ignoreCase: false,
        exactMatch: true,
        revealResults: false
      });
    }
    if (data.hasOwnProperty("search")) {
      if (data.search.collapse) {
        tree.collapseAll();
      }
      if (data.search.pattern.length > 1) {
        data.search.pattern.map(function(pattern) {
          tree.search(pattern, data.search.options);
        });
      } else {
        tree.search(data.search.pattern, data.search.options);
      }
    }
    if (data.hasOwnProperty("clearSearch")) {
     tree.clearSearch(); 
    }
    if (data.hasOwnProperty("expand")) {
      if (data.expand.hasOwnProperty("nodeId")) {
        var expandedNode = tree.findNodes(
          "^" + data.expand.nodeId + "$",
          "nodeId"
        );
        tree.expandNode(expandedNode, data.expand.options);
      } else {
        tree.expandAll(data.expand.options);
      }
    }
    if (data.hasOwnProperty("collapse")) {
      if (data.collapse.hasOwnProperty("nodeId")) {
        var collapsedNode = tree.findNodes(
          "^" + data.collapse.nodeId + "$",
          "nodeId"
        );
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
    //console.log(tree);
    $(el).on("rendered ", function(event, data) {
      if (options.hasOwnProperty("selected")) {
        var selected;
        for (let i = 0; i < options.selected.length; i++) {
          selected = options.selected[i];
          selected = selected.replace(/[-\/\\^$*+?.()|[\]{}]/g, "\\$&");
          selected = tree.search(selected, {
            ignoreCase: false,
            exactMatch: true,
            revealResults: false
          });
          if (selected.length < 1) {
            selected = tree.findNodes("^" + options.selected[i] + "$", "id");
          }
          for (let j = 0; j < selected.length; j++) {
            if (!selected[j].state.checked) {
              tree.toggleNodeChecked(selected[j]);
            }
          }
        }
        tree.search("", {
          ignoreCase: false,
          exactMatch: true,
          revealResults: false
        });
      }
      var nodes = tree.getNodes().map(function(o) {
        return { text: o.text, nodeId: o.nodeId, parentId: o.parentId };
      });
      if (options.nodes_input) {
        Shiny.onInputChange(el.id + "_nodes:treeview.nodes", nodes);
      }
    });
  }
});
Shiny.inputBindings.register(
  treecheckInputBinding,
  "shinytreeview.treecheckInput"
);

