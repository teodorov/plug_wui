@HtmlImport('transition_list.html')
library plug_wui.lib.transition_list;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:plug_wui/transition_list_item.dart';

/// Uses [IronList]
@PolymerRegister('transition-list')
class TransitionList extends PolymerElement {
  TransitionList.created() : super.created();
  @property var fireables;

  @reflectable
  fireTransition(e, det) {
    this.add('fireables', det);
  }
}