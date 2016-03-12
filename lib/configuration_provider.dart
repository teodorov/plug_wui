@HtmlImport('configuration_provider.html')
library plug_wui.lib.configuration_provider;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('configuration-provider')
class ConfigurationProvider extends PolymerElement {
  ConfigurationProvider.created() : super.created();

  @Property(notify: true)
  Configuration conf;

  @property var runtime;

  @Listen("configuration-changed")
  runtimeReset(e, detail) {
    this.set('conf', new Configuration(detail));
  }
}

class Configuration extends JsProxy {
  @reflectable int id;
  Configuration(this.id);
}