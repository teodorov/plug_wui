@HtmlImport('transition_list.html')
library plug_wui.lib.transition_list;

import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:plug_wui/transition_list_item.dart';
import 'package:polymer_elements/av_icons.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:plug_wui/transitions_provider.dart';

/// Uses [IronList], [TransitionListItem], [PaperCard], [PaperIconButton]
@PolymerRegister('transition-list')
class TransitionList extends PolymerElement {
  TransitionList.created() : super.created();
  @property List<FireableTransition> fireables;

  @reflectable isEnabled() => fireables != null;

  Random rnd = new Random();
  @reflectable
  stepRandomly(e, _) {
    if (fireables == null) return;
    var index = rnd.nextInt(fireables.length);
    fireables[index].fire();
  }
}