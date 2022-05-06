class Expense {
  final int id;
  final String type;
  final double? value;
  final String label;
  final String date;

  Expense(
    this.id,
    this.type,
    this.value,
    this.label,
    this.date,
  );

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        type = json['type'],
        value = json['value'],
        label = json['label'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
        'label': label,
        'date': date,
      };

  @override
  String toString() {
    return 'Contact{id: $id, type: $type, value: $value, label: $label, date: $date}';
  }
}
