int getIdFromMessageTitle(String title) {
  int start = title.indexOf('(');
  int end = title.indexOf(')');
  String id = title.substring(start + 1, end);
  return int.parse(id);
}
