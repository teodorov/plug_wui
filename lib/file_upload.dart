@HtmlImport('file_upload.html')
library plug_wui.lib.file_upload;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_progress.dart';
import 'package:polymer_elements/iron_icons.dart';

/// Uses [PaperButton], [PaperProgress]
@PolymerRegister('file-upload')
class FileUpload extends PolymerElement {
  FileUpload.created() : super.created();

  /**
   * `target` is the target url to upload the files to.
   * Additionally by adding '<name>' in your url, it will be replaced by
   * the file name.
   */
  String target = 'http://httpbin.org/put';

  /**
   * `method` is the http method to be used during upload
   */
  String method = 'PUT';

  /**
   * `manualUpload` indiciates that when a file is selected it will
   * <b>NOT</b> be automatically uploaded. `uploadFile` will have to be
   * called programmatically on the files to upload.
   */
  @property bool manualUpload = false;

  /**
   * `acceptedFileTypes` is the set of comma separated file extensions or mime types
   * to filter as accepted.
   */
  @property
  String acceptedFileTypes = 'txt,zip';

  /**
   * `progressHidden` indicates whether or not the progress bar should be hidden.
   */
  @property
  bool progressHidden = false;

  /**
   * `droppable` indicates whether or not to allow file drop.
   */
  @property
  bool droppable = false;

  /**
   * `dropText` is the  text to display in the file drop area.
   */
  @property
  String dropText = 'Drop Files Here';

  /**
   * `multipleFiles` indicates whether or not to allow multiple files to be uploaded.
   */
  @property
  bool multipleFiles = true;

  /**
   * `files` is the list of files to be uploaded
   */
  @Property(notify: true)
  List<FileStatus> files = new List();

  /**
   * `retryText` is the text for the tooltip to retry an upload
   */
  @property
  String retryText = 'Retry Upload';

  /**
   * `removeText` is the text for the tooltip to remove an upload
   */
  @property
  String removeText = 'Remove';

  /**
   * `successText` is the text for the tooltip of a successful upload
   */
  @property
  String successText = 'Success';

  /**
   * `errorText` is the text to display for a failed upload
   */
  @property
  String errorText = 'Error uploading file...';

  /**
   * `hiddenDropText(_)` indicates whether or not the drop text should be shown
   */
  @reflectable
  bool hiddenDropText(_) => (files.length != 0 || !droppable);

  /**
   * `paperButtonAlt` allows changing the alt property on the paper button
   */
  @property
  String paperButtonAlt = 'ptpt';

  /**
   * `paperButtonTitle` allows changing the title property on the paper button
   */
  @property
  String paperButtonTitle = 'ptpt';

  @property bool raised = false;
  @property bool noink = false;

  Element dropZone;

  void ready() {
    if (raised) {
      $['button'].set('raised', true);
    }

    if (noink) {
      $['button'].set('noink', true);
    }
    if (droppable) setupDrop();
  }

  void setupDrop() {
    dropZone = $['UploadBorder'];

    dropZone.classes.toggle('enabled');
    dropZone.onDragOver.listen((MouseEvent event) {
      event.stopPropagation();
      event.preventDefault();
      event.dataTransfer.dropEffect = 'copy';
    });
    dropZone.onDragEnter.listen((e) => dropZone.classes.add('hover'));
    dropZone.onDragLeave.listen((e) => dropZone.classes.remove('hover'));

    dropZone.onDrop.listen((MouseEvent event) {
      event.stopPropagation();
      event.preventDefault();
      dropZone.classes.remove('hover');

      //check if multiple files accepted
      if (event.dataTransfer.files.length > 1 && !multipleFiles) {
        return;
      }

      addFiles(event.dataTransfer.files);
    });
  }

  void addFiles(List<File> inFiles) {
    inFiles.forEach((file) {
      if (isFileTypeAccepted(file)) {
        FileStatus item = new FileStatus(file);
        add('files', item);
        if (!manualUpload) {
          uploadFile(item);
        }
      }
    });
  }

  bool isFileTypeAccepted(File file) {
    var extension = file.name.split(".").last;
    var mimeType = file.type;

    if (acceptedFileTypes.isEmpty) return true;
    if (acceptedFileTypes.indexOf(extension) != -1) return true;
    if (mimeType.isNotEmpty && acceptedFileTypes.indexOf(mimeType) != -1) return true;
    return false;
  }

  @reflectable
  fileClick([_, __]) {
    $['fileInput'].dispatchEvent(
        new MouseEvent('click', canBubble: true, cancelable: false));
  }

  @reflectable
  fileChange([_, __]) {
    addFiles($['fileInput'].files);
  }

  @reflectable
  retryUpload([Event evt, __]) {
    DomRepeatModel model = new DomRepeatModel.fromEvent(evt);
    model.set('item.error', false);
    model.set('item.progress', 0);
    model.set('item.complete', false);
    async(() => uploadFile(model.get('item')));
  }

  uploadFile(FileStatus item) {
    if (item == null) return;
    int index = files.indexOf(item);
    fire('before-upload');
    final reader = new FileReader();
    reader.onLoad.listen((e) {
      final request = new HttpRequest();
      request.onReadyStateChange.listen((Event e) {
        if (request.readyState == HttpRequest.DONE && (request.status == 200 || request.status == 0)) {
          set('files.$index.complete', true);
          set('files.$index.error', false);
        }
      });
      request.onError.listen((Event e) {
        set('files.$index.error', true);
      });
      request.upload.onProgress.listen((e) {
        var done = e.loaded;
        var total = e.total;
        if (total == 0) return;
        set('files.$index.progress', ((done/total)*1000).floor()/10);
      });
      request.open(method, target);
      request.send(reader.result);
    });
    reader.readAsDataUrl(item.file);
  }

  @reflectable
  cancelUpload([Event evt, var detail, var target]) {
    removeItem('files', $['filelist'].itemForElement(evt.target));
  }

  clearFiles() {
    set('files', new List());
    $['fileInput'].value = '';
  }
}

class FileStatus extends JsProxy {
  @reflectable File file;
  @reflectable int progress = 0;
  @reflectable bool error = false;
  @reflectable bool complete = false;

  FileStatus(this.file);

  toString() {
    return "aFileStatus[$progress  $error  $complete]";
  }
}