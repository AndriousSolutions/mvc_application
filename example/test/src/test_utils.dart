String _errorMessage = '';

void collectError(Object error) {
  //
  _errorMessage = '$_errorMessage${error.toString()}';
}

/// Throw an Exception if there are a collection of errors.
void reportTestErrors() {
  //
  if (_errorMessage.isNotEmpty) {
    //
    throw Exception(_errorMessage);
  }
}
