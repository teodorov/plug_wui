@HtmlImport('configuration_view.html')
library plug_wui.lib.configuration_view;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('configuration-view')
class ConfigurationView extends PolymerElement {
  ConfigurationView.created() : super.created();

  @property var conf;// = 2;

  @reflectable
  exe(e, _) {
    window.alert(conf.toString());
  }
}