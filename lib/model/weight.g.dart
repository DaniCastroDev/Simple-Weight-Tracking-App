// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weight _$WeightFromJson(Map<String, dynamic> json) {
  return Weight(json['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['date']), (json['weight'] as num)?.toDouble());
}

Map<String, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{'date': instance.date?.millisecondsSinceEpoch, 'weight': instance.weight};

ListWeight _$ListWeightFromJson(Map<String, dynamic> json) {
  return ListWeight((json['weights'] as List)?.map((e) => e == null ? null : Weight.fromJson(e as Map<String, dynamic>))?.toList());
}

Map<String, dynamic> _$ListWeightToJson(ListWeight instance) {
  List<Map> maps = [];
  instance.weights.forEach((w) {
    maps.add(w.toJson());
  });
  return <String, dynamic>{'weights': maps};
}
