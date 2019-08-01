import 'package:json_annotation/json_annotation.dart';
part 'weight.g.dart';

@JsonSerializable()
class Weight {
  DateTime date;
  double weight;

  Weight(this.date, this.weight);

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);
  Map<String, dynamic> toJson() => _$WeightToJson(this);
}

@JsonSerializable()
class ListWeight {
  List<Weight> weights;

  ListWeight(this.weights);

  factory ListWeight.fromJson(Map<String, dynamic> json) => _$ListWeightFromJson(json);
  Map<String, dynamic> toJson() => _$ListWeightToJson(this);
}
