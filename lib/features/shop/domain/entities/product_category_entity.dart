import 'package:equatable/equatable.dart';

class ProductCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final int parent;
  final String description;
  final String display;
  final String? image;
  final int menuOrder;
  final int count;

  const ProductCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.description,
    required this.display,
    this.image,
    required this.menuOrder,
    required this.count,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    parent,
    description,
    display,
    image,
    menuOrder,
    count,
  ];
}
