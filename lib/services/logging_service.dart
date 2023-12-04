import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:mit_dir_utility/globals.dart';

/// !!! Best Logger EUW !!!
///
/// Outputs the [object] as a string to the console.
///
/// Includes file name, linenumber and function name.
///
/// If [onlyDebug] is true (de)
void log(Object object,
    {bool onlyDebug = true, bool long = false, String name = '', Error? error}) {
  var stackTrace = _getStackTrace();

  const int maxChunkSize = 100; // Define a suitable chunk size

  if (!long) {
    if (!onlyDebug) {
      dev.log("$stackTrace :-> $object", name: name, error: error);
      return;
    } else if (debugMode) {
      dev.log("$stackTrace :-> $object", name: name, error: error);
      return;
    }
  }

  final formattedMessage = "$stackTrace :-> $object";

  if (!onlyDebug) {
    for (int i = 0; i < formattedMessage.length; i += maxChunkSize) {
      dev.log(
          formattedMessage.substring(
              i,
              i + maxChunkSize > formattedMessage.length
                  ? formattedMessage.length
                  : i + maxChunkSize),
          name: name,
          error: error);
    }
    return;
  } else if (debugMode) {
    for (int i = 0; i < formattedMessage.length; i += maxChunkSize) {
      dev.log(
          formattedMessage.substring(
              i,
              i + maxChunkSize > formattedMessage.length
                  ? formattedMessage.length
                  : i + maxChunkSize),
          name: name,
          error: error);
    }
    return;
  }
  // dev.log("$stackTrace :-> $object");
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
