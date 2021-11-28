// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String? ?? ''
    ..isdone = json['isdone'] as int;
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'isdone': instance.isdone,
    };
