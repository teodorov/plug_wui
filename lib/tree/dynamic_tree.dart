@HtmlImport('dynamic_tree.html')
library plug_wui.lib.tree.dynamic_tree;

import 'dart:html';
import 'dart:js';
import 'dart:convert';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:d3/d3.dart' as d3;

/// Uses [PaperButton]
@PolymerRegister('dynamic-tree')
class DynamicTree extends PolymerElement {
  DynamicTree.created() : super.created();

  static String styleScope = "dynamic-tree";
  static int width = 960;
  static int height = 500;

  var tree = new d3.Tree()..size = [height, width];

  var rootNode = new TreeNode("root");
  var nodes;
  Random rnd = new Random();

  var color = new d3.OrdinalScale.category20();
  var force = new d3.Force()
    ..charge = -120
    ..linkDistance = 30
    ..size = [width, height];

  ready() {
    createGraph();
  }
  createGraph () {

    var i = 0, duration = 750;
    var diagonal = new d3.Diagonal()
      ..projectionFn = (d) {
        return [d['y'], d['x']]; };

    var svg = new d3.Selection($["svg"]);
    svg
      ..attr['width'] = "$width"
      ..attr['height'] = "$height";

    update(var root, var source) {
      // Compute the new tree layout.
      JsObject nodes = tree.nodes(root).callMethod('reverse');
      var links = tree.links(nodes);

      // Normalize for fixed-depth.
      (nodes as List).forEach((each) => each.y = each.depth * 180);

      // Update the nodes...
      var node = svg.selectAll("g.node").data(nodes as List, (TreeNode each) => each.id = i++);

      // Enter any new nodes at the parent's previous position.
      var nodeEnter = node.enter().append("g")
        ..attr["class"] = "node style-scope $styleScope"
        ..attrFn["transform"] = ((TreeNode each) => "translate(${source.y0},${source.x0})")
        ..on("click").listen((s) {
          TreeNode node = s.data;
          // Toggle children on click.
//          node._children = node.children;
//          node.children = new List();

          update(root, node);
        });

      nodeEnter.append("circle")
        ..attr["r"] = "2"
        ..styleFn["fill"] = (TreeNode node) => "lightsteelblue";

      nodeEnter.append("text")
        ..attrFn["x"] = ((TreeNode node) => 10)
        ..attr["dy"] = ".35em"
        ..attrFn["text-anchor"] = ((TreeNode node) => "end")
        ..textFn = ((d) => d.name)
        ..style["fill-opacity"] = "1e-6";

      // Transition nodes to their new position.
      var nodeUpdate = node.transition()
        ..duration = duration
        ..attrFn["transform"] = (d) => "translate(${d.y},${d.x})";

      nodeUpdate.select("circle")
        ..attr["r"] = "4.5"
        ..styleFn["fill"] = (TreeNode node) => "lightsteelblue";

      nodeUpdate.select("text")..style["fill-opacity"] = "1";

      // Transition exiting nodes to the parent's new position.
      var nodeExit = node.exit().transition()
        ..duration = duration
        ..attrFn["transform"] = ((d) =>
        "translate(${source.y},${source.x})")
        ..remove();

      nodeExit.select("circle")..attr["r"] = "1e-6";

      nodeExit.select("text")..style["fill-opacity"] = "1e-6";

      // Update the links...
      var link = svg
          .selectAll("path.link")
          .data(links, (TreeNode node) => node.children);

      // Enter any new links at the parent's previous position.
      link.enter().insert("path", "g")
        ..attr["class"] = "link style-scope $styleScope"
        ..attrFn["d"] = (_) {
          var o = {'x': source.x0, 'y': source.y0};
          return diagonal({'source': o, 'target': o});
        };

      // Transition links to their new position.
      link.transition()
        ..duration = duration
        ..attr["d"] = diagonal;

      // Transition exiting nodes to the parent's new position.
      link.exit().transition()
        ..duration = duration
        ..attrFn["d"] = ((d) {
          var o = {'x': source.x, 'y': source.y};
          return diagonal({'source': o, 'target': o});
        })
        ..remove();

      // Stash the old positions for transition.
      (nodes as List).forEach((TreeNode d) {
        d.x0 = d.x;
        d.y0 = d.y;
      });
    }

//    d3.json("../lib/tree/flare.json").then((flare) {
//      var root = flare;
//      root['x0'] = height / 2;
//      root['y0'] = 0;
//
//      collapse(d) {
//        if (d['children'] != null) {
//          d['_children'] = d['children'];
//          d['_children'].forEach(collapse);
//          d['children'] = null;
//        }
//      }
//
//      root['children'].forEach(collapse);
//      update(root, root);
//    }, onError: (err) => throw err);

    var root = new TreeNode("root");
    var node1 = new TreeNode("n1");
    var node2 = new TreeNode("n2");
    root.children.add(node1);
    root.children.add(node2);
    update(root, root);
  }

  int idx = 0;
  @reflectable
  addNode([Event evt, __]) {
    var newNode = new TreeNode("node_${idx++}");
    var parent = nodes[rnd.nextInt(nodes.length)];
    parent.children.add(newNode);

    nodes.add(newNode);
    window.alert("added");
  }
}

class TreeNode extends JsProxy {
  @property int id = 0;
  @property String name;
  @property List<TreeNode> children = new List();
  @property List<TreeNode> _children = new List();
  @property var x = 10;
  @property var y = 0;
  @property var x0 = 0;
  @property var y0 = 0;
  @property var depth = 1;
  TreeNode(this.name);

  toString() => "a TreeNode[$name]";
}