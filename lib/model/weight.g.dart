// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weight _$WeightFromJson(Map<dynamic, dynamic> json) {
  return Weight(json['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['date']), (json['weight'] as num)?.toDouble());
}

Map<dynamic, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{'date': instance.date?.millisecondsSinceEpoch, 'weight': instance.weight};

ListWeight _$ListWeightFromJson(Map<dynamic, dynamic> json) {
  return ListWeight((json['weights'] as List)?.map((e) => e == null ? null : Weight.fromJson(e as Map<dynamic, dynamic>))?.toList());
}

Map<dynamic, dynamic> _$ListWeightToJson(ListWeight instance) => <String, dynamic>{'weights': instance.weights};
