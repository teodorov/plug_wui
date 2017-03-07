@HtmlImport('force_graph.html')
library plug_wui.lib.tree.force_graph;

import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:d3/d3.dart' as d3;

@PolymerRegister('force-graph')
class ForceGraph extends PolymerElement {
  ForceGraph.created() : super.created();

  static String styleScope = "force-graph";
  static int width = 960;
  static int height = 500;

  var color = new d3.OrdinalScale.category20();
  var force = new d3.Force()
    ..charge = -120
    ..linkDistance = 30
    ..size = [width, height];

  ready() {
    createGraph();
  }
  createGraph () {
    var svg = new d3.Selection($["svg"]);
    svg
      ..attr['width'] = "$width"
      ..attr['height'] = "$height";

    d3.json("../lib/tree/miserables.json").then((graph) {
      force
          ..nodes = graph['nodes']
          ..links = graph['links']
          ..start();
      var link =
        svg.selectAll(".link").data(graph['links']).enter().append("line")
          ..attr["class"] = "link style-scope $styleScope"
          ..styleFn["stroke-width"] = (d) => sqrt(d['value']);

      var node =
        svg.selectAll(".node").data(graph['nodes']).enter().append("circle")
          ..attr["class"] = "node style-scope $styleScope"
          ..attr["r"] = "5"
          ..styleFn["fill"] = ((d) => color(d['group']))
          ..call((_) => force.drag());

      node.append("title")..textFn = (d) => d['name'];

      force.onTick.listen((_) {
        link
          ..attrFn["x1"] = ((d) => d['source']['x'])
          ..attrFn["y1"] = ((d) => d['source']['y'])
          ..attrFn["x2"] = ((d) => d['target']['x'])
          ..attrFn["y2"] = ((d) => d['target']['y']);

        node
          ..attrFn["cx"] = ((d) => d['x'])
          ..attrFn["cy"] = ((d) => d['y']);
      });
    }, onError: (err) => throw err);
  }
}