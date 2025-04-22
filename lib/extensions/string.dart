extension StringParsing on String {
  String telFormat() {
    return replaceAll(RegExp(r'^0+(?=.)'), '');
  }
}
