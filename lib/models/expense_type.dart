enum ExpenseType {
  bill,
  food,
  shopping,
  travel,
  entertainment,
  nightlife,
  health,
  subscriptions,
  other
}

const Map<ExpenseType, String> ExpenseTypeMap = {
  ExpenseType.bill: "Bill",
  ExpenseType.food: "Food",
  ExpenseType.shopping: "Shopping",
  ExpenseType.travel: "Travel",
  ExpenseType.entertainment: "Entertainment",
  ExpenseType.nightlife: "Nightlife",
  ExpenseType.health: "Health",
  ExpenseType.subscriptions: "Subscriptions",
  ExpenseType.other: "Other"
};


List<String> expenseTypeList(Map<ExpenseType, String> map) {
  final List<String> list = [];
  map.forEach((key, value) {
    list.add(value);
  });
  return list;
}