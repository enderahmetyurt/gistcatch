(function() {
  CodeMirror.modeURL = "../assets/codemirror/mode/%N/%N.js";

  // Based in this example: https://codemirror.net/demo/loadmode.html
  function changeMode(filenameElement, editor) {
    var filename = filenameElement.value, extension, mode, spec;

    if (extension = /.+\.([^.]+)$/.exec(filename)) {
      var info = CodeMirror.findModeByExtension(extension[1]);

      if (info) {
        mode = info.mode;
        spec = info.mime;
      }
    } else if (/\//.test(filename)) {
      var info = CodeMirror.findModeByMIME(filename);

      if (info) {
        mode = info.mode;
        spec = filename;
      }
    } else {
      return editor.setOption("mode", null);
    }

    if (mode) {
      editor.setOption("mode", spec);
      CodeMirror.autoLoadMode(editor, mode);
    } else {
      console.warning("Could not find a mode corresponding to " + filename);
    }
  }

  $(document).on("turbolinks:load", function() {
    var $codeMirrors = $("[data-toggle='codemirror']");

    $codeMirrors.each(function() {
      var editor = CodeMirror.fromTextArea(this, {
        lineNumbers: true,
      });

      var $wrapper = $(this).closest("[data-codemirror='wrapper']");
      var $updateButton = $wrapper.find("[data-codemirror='update-button']");

      $updateButton.click(function() {
        var $filename = $wrapper.find("[data-codemirror='filename']");

        changeMode($filename.get(0), editor);
      });
    });
  });
})();
