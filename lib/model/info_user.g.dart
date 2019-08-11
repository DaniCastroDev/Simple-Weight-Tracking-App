// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoUser _$InfoUserFromJson(Map<dynamic, dynamic> json) {
  return InfoUser(
      gender: json['gender'] as String,
      dateOfBirth: json['dateOfBirth'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['dateOfBirth']),
      height: (json['height'] as num)?.toDouble(),
      initialWeight: (json['initialWeight'] as num)?.toDouble(),
      dateInitialWeight: json['dateInitialWeight'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['dateInitialWeight']),
      dateObjectiveWeight: json['dateObjectiveWeight'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['dateObjectiveWeight']),
      objectiveWeight: (json['objectiveWeight'] as num)?.toDouble(),
      activeObjectives: (json['activeObjectives'] as bool));
}

Map<dynamic, dynamic> _$InfoUserToJson(InfoUser instance) => <String, dynamic>{
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth?.millisecondsSinceEpoch,
      'dateInitialWeight': instance.dateInitialWeight?.millisecondsSinceEpoch,
      'initialWeight': instance.initialWeight,
      'dateObjectiveWeight': instance.dateObjectiveWeight?.millisecondsSinceEpoch,
      'objectiveWeight': instance.objectiveWeight,
      'height': instance.height,
      'activeObjectives': instance.activeObjectives
    };
