class Result {
  int? id;
  double? weight;
  double? height;
  double? result;

  Result(
      {this.id,
      required this.weight,
      required this.height,
      required this.result});

  Result.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        weight = res["weight"],
        height = res["height"],
        result = res["result"];

  Map<String, dynamic> toMap() {
    return {'id': id, 'weight': weight, 'height': height, 'result': result};
  }
}
