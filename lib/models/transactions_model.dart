class TransactionModel {
  final String parNchildUid;
  final List<Map<String, dynamic>> trans;       // [{'message': 'You got', 'amount': 53}]

  TransactionModel({ required this.parNchildUid, required this.trans });

  static TransactionModel fromJson(Map<String, dynamic> map) => TransactionModel(
      parNchildUid: map['parNchildUid'],
      trans: map['trans']
  );

}