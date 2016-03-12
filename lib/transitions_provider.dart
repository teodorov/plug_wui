@HtmlImport('transitions_provider.html')
library plug_wui.lib.transitions_provider;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('transitions-provider')
class TransitionsProvider extends PolymerElement {
  TransitionsProvider.created() : super.created();

  @Property(notify: true)
  var fireables;

  @property var runtime;

  List<FireableTransition> getFireableTransitions(targets) {
    return new List.from(targets.map((target) => new FireableTransition(runtime.currentState, target, this)));
  }

  @Listen("runtime-reset")
  @Listen("configuration-changed")
  runtimeReset(e, _) {
      this.set("fireables", getFireableTransitions(runtime.getFireables()) );
  }
}

class FireableTransition extends JsProxy {
  @reflectable int from;
  @reflectable int to;
  TransitionsProvider provider;
  FireableTransition(this.from, this.to, this.provider);
  fire () {
    provider.runtime.fire(this);
  }
  String toString() {
    return "[" + from.toString() +"-"+ to.toString() + "]";
  }
}
