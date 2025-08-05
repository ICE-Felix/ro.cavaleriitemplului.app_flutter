class ProductTagQueryParams {
  final String? context;
  final int? page;
  final int? perPage;
  final String? search;
  final List<int>? exclude;
  final List<int>? include;
  final int? offset;
  final String? order;
  final String? orderBy;
  final bool? hideEmpty;
  final int? product;
  final String? slug;

  const ProductTagQueryParams({
    this.context,
    this.page,
    this.perPage,
    this.search,
    this.exclude,
    this.include,
    this.offset,
    this.order,
    this.orderBy,
    this.hideEmpty,
    this.product,
    this.slug,
  });

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> params = {};

    if (context != null) params['context'] = context;
    if (page != null) params['page'] = page.toString();
    if (perPage != null) params['per_page'] = perPage.toString();
    if (search != null && search!.isNotEmpty) params['search'] = search;
    if (exclude != null && exclude!.isNotEmpty) {
      params['exclude'] = exclude!.map((id) => id.toString()).join(',');
    }
    if (include != null && include!.isNotEmpty) {
      params['include'] = include!.map((id) => id.toString()).join(',');
    }
    if (offset != null) params['offset'] = offset.toString();
    if (order != null) params['order'] = order;
    if (orderBy != null) params['orderby'] = orderBy;
    if (hideEmpty != null) params['hide_empty'] = hideEmpty.toString();
    if (product != null) params['product'] = product.toString();
    if (slug != null && slug!.isNotEmpty) params['slug'] = slug;

    return params;
  }

  ProductTagQueryParams copyWith({
    String? context,
    int? page,
    int? perPage,
    String? search,
    List<int>? exclude,
    List<int>? include,
    int? offset,
    String? order,
    String? orderBy,
    bool? hideEmpty,
    int? product,
    String? slug,
  }) {
    return ProductTagQueryParams(
      context: context ?? this.context,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search ?? this.search,
      exclude: exclude ?? this.exclude,
      include: include ?? this.include,
      offset: offset ?? this.offset,
      order: order ?? this.order,
      orderBy: orderBy ?? this.orderBy,
      hideEmpty: hideEmpty ?? this.hideEmpty,
      product: product ?? this.product,
      slug: slug ?? this.slug,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductTagQueryParams &&
        other.context == context &&
        other.page == page &&
        other.perPage == perPage &&
        other.search == search &&
        other.exclude == exclude &&
        other.include == include &&
        other.offset == offset &&
        other.order == order &&
        other.orderBy == orderBy &&
        other.hideEmpty == hideEmpty &&
        other.product == product &&
        other.slug == slug;
  }

  @override
  int get hashCode {
    return context.hashCode ^
        page.hashCode ^
        perPage.hashCode ^
        search.hashCode ^
        exclude.hashCode ^
        include.hashCode ^
        offset.hashCode ^
        order.hashCode ^
        orderBy.hashCode ^
        hideEmpty.hashCode ^
        product.hashCode ^
        slug.hashCode;
  }

  @override
  String toString() {
    return 'ProductTagQueryParams(context: $context, page: $page, perPage: $perPage, search: $search, exclude: $exclude, include: $include, offset: $offset, order: $order, orderBy: $orderBy, hideEmpty: $hideEmpty, product: $product, slug: $slug)';
  }
}

// Enum classes for better type safety
class ProductTagContext {
  static const String view = 'view';
  static const String edit = 'edit';
}

class ProductTagOrder {
  static const String asc = 'asc';
  static const String desc = 'desc';
}

class ProductTagOrderBy {
  static const String id = 'id';
  static const String include = 'include';
  static const String name = 'name';
  static const String slug = 'slug';
  static const String termGroup = 'term_group';
  static const String description = 'description';
  static const String count = 'count';
}
