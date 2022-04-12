class Expense {
  final int id;
  final String type;
  final double? value;

  Expense(
      this.id,
      this.type,
      this.value,
      );

  Expense.fromJson(Map<String, dynamic> json) :
        id = json['id'] ?? 0,
        type = json['type'],
        value = json['value']
  ;

  Map<String, dynamic> toJson() =>
      {
        'type' : type,
        'value' : value,
      }
  ;

  @override
  String toString() {
    return 'Contact{id: $id, type: $type, value: $value}';
  }

}
