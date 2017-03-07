@HtmlImport('configuration_view.html')
library plug_wui.lib.configuration_view;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_card.dart';

/// Uses [PaperCard]
@PolymerRegister('configuration-view')
class ConfigurationView extends PolymerElement {
  ConfigurationView.created() : super.created();

  @property var conf;// = 2;
}