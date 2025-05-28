import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String description,
    required int questionCount,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState({
    required List<Category> categories,
    @Default('') String selectedCategoryId,
  }) = _CategoryState;

  factory CategoryState.fromJson(Map<String, dynamic> json) =>
      _$CategoryStateFromJson(json);
}
