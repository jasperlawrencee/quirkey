class Entries {
  String title;
  String type;
  Map<String, dynamic> entry;

  Entries({
    required this.title,
    required this.type,
    required this.entry,
  });

  factory Entries.fromMap(Map<String, dynamic> map) => Entries(
        title: map['title'] as String,
        type: map['type'] as String,
        entry: map['value'] as Map<String, dynamic>,
      );
}

enum PasswordStrength { weak, medium, strong, veryStrong }
