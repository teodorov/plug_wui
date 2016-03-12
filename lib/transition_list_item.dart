@HtmlImport('transition_list_item.html')
library  plug_wui.lib.transitions_list_item;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/iron_icons.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

/// Uses [PaperItem], [PaperIconButton]
@PolymerRegister('transition-list-item')
class TransitionListItem extends PolymerElement {
  TransitionListItem.created() : super.created();
  @property var transition;
  @reflectable
  fireTransition(e, __) {
    transition.fire();
  }
}