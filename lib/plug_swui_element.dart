// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
@HtmlImport('plug_swui_element.html')
library plug_wui.lib.plug_swui_element;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:plug_wui/transitions_provider.dart';
import 'package:plug_wui/transition_list.dart';
import 'package:plug_wui/configuration_provider.dart';
import 'package:plug_wui/configuration_view.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

@PolymerRegister('plug-swui-element')
class PlugSimulationWUI extends PolymerElement {
  /// Constructor used to create instance of MainApp.
  PlugSimulationWUI.created() : super.created();

  @Property(notify: true)
  MockExplicitRuntime runtime;

  @reflectable
  reset(e, _) {
    if (runtime == null) {
      this.set('runtime', new MockExplicitRuntime(this));
    }
    runtime.initialize();
  }
}

class MockExplicitRuntime extends JsProxy {
  ExplicitGraph program = new ExplicitGraph();
  PlugSimulationWUI view;
  MockExplicitRuntime(this.view);

  @reflectable
  int currentState;
  @reflectable
  initialize() {
    currentState = program.initial;
    fireConfigurationChanged();
  }

  @reflectable
  getFireables() {
    return program.fanout[currentState];
  }

  @reflectable
  fire(transition) {
    currentState = transition.to;
    fireConfigurationChanged();
  }

  fireConfigurationChanged() {
    CustomEvent evt =
        new CustomEvent('configuration-changed', detail: currentState);

    view.dispatchEvent(evt);
    view.childNodes.forEach((c) => c.dispatchEvent(evt));
  }

  @reflectable
  getConfigurationContent(index) => program.states[index];
}

class ExplicitGraph {
  var initial = 0;
  var states = [
    [0, 0, 0, 0], //0
    [1, 1, 0, 0], //1
    [0, 0, 1, 1], //2

    [2, 1, 0, 0], //3
    [1, 1, 1, 1], //4
    [0, 0, 3, 1], //5

    [2, 1, 1, 1], //6
    [1, 1, 2, 0], //7
    [1, 1, 3, 1], //8

    [2, 1, 2, 0], //9
    [0, 0, 2, 0]  //10
  ];
  var fanout = [
    [1, 2],
    [3, 4],
    [4, 5, 2, 3, 1],
    [6],
    [7],
    [0, 8],
    [2, 9],
    [9],
    [1],
    [10],
    [5, 7]
  ];
}
