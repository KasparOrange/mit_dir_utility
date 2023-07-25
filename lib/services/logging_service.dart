import 'dart:developer' as dev;

/// !!! Best Logger EUW !!!
///
/// Outputs the [object] as a string to the console.
///
/// Includes file name, linenumber and function name.
void log(Object object) {
  var stackTrace = _getStackTrace();

  dev.log("$stackTrace :-> $object");
}

String _getStackTrace() {
  List<String> lines = StackTrace.current.toString().split('\n'); //.toList();

  var lineOfInteresst = lines[3];

  var splitAt = lineOfInteresst.lastIndexOf('/') + 1;

  // If for some reason there is no / in the line, just return the line.
  if (splitAt < 0) return lineOfInteresst;

  // Gets only the name of the function from the end of the line.
  var functionName = lineOfInteresst.substring(lineOfInteresst.lastIndexOf(' ') + 1);

  var fileNameAndLineNumber = lineOfInteresst.substring(splitAt);

  // The following is a bit of stringjuggeling that removes some spaces
  var stringExcludingFirstSpace = fileNameAndLineNumber.replaceFirst(' ', '');

  var indexOfSecondSpace = stringExcludingFirstSpace.indexOf(' ') + 1;

  fileNameAndLineNumber = fileNameAndLineNumber.substring(0, indexOfSecondSpace);

  return '$fileNameAndLineNumber fn:$functionName';
}
