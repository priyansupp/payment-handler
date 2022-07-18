class CustomerModel {
  final String parentUid;
  final List<Map<String, dynamic>> children;

  CustomerModel({ required this.parentUid, required this.children });

  static CustomerModel fromJson(Map<String, dynamic> map) => CustomerModel(
    parentUid: map['parentUid'],
    children: map['children']
  );

}