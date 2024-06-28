class Entries {
  List<Notes>? notes;
}

class Notes {
  String title;
  String value;
  String type;

  Notes({
    required this.title,
    required this.type,
    required this.value,
  });
}
