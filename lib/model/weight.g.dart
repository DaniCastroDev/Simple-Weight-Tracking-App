// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weight _$WeightFromJson(Map<String, dynamic> json) {
  return Weight((json['weight'] as num)?.toDouble(), json['dateTime'] == null ? null : DateTime.parse(json['dateTime'] as String),
      difference: (json['difference'] as num)?.toDouble());
}

Map<String, dynamic> _$WeightToJson(Weight instance) =>
    <String, dynamic>{'weight': instance.weight, 'dateTime': instance.dateTime?.toIso8601String(), 'difference': instance.difference};
