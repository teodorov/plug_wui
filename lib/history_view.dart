@HtmlImport('history_view.html')
library  plug_wui.lib.history_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:polymer_elements/paper_item.dart';
import 'package:polymer_elements/iron_flex_layout.dart';

/// Uses [PaperItem], [PaperIconButton]
@PolymerRegister('history-view')
class HistoryView extends PolymerElement {
  HistoryView.created() : super.created();

  @property var data = [
    {"name": "Bob"},
    {"name": "Tim"},
    {"name": "Mike"}
  ];
}