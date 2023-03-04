class StepModel {
  int? id;
  String? english;
  String? korean;
  double? first;

  StepModel({
    this.id,
    this.english,
    this.korean,
    this.first,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'english': english,
      'korean': korean,
      'first': first,
    };
  }

  factory StepModel.fromMap(Map<String, dynamic> map) {
    return StepModel(
      id: map['id'] != null ? map['id'] as int : null,
      english: map['english'] != null ? map['english'] as String : null,
      korean: map['korean'] != null ? map['korean'] as String : null,
      first: map['first'] != null ? map['first'] as double : null,
    );
  }
}
