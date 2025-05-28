// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      questionCount: (json['questionCount'] as num).toInt(),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'questionCount': instance.questionCount,
    };

_$CategoryStateImpl _$$CategoryStateImplFromJson(Map<String, dynamic> json) =>
    _$CategoryStateImpl(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCategoryId: json['selectedCategoryId'] as String? ?? '',
    );

Map<String, dynamic> _$$CategoryStateImplToJson(_$CategoryStateImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'selectedCategoryId': instance.selectedCategoryId,
    };
