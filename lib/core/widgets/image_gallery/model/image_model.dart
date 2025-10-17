class ImageModel {
  final String id;
  final String fileName;
  final String url;

  const ImageModel({
    required this.id,
    required this.fileName,
    required this.url,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      fileName: json['file_name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'file_name': fileName, 'url': url};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ImageModel &&
        other.id == id &&
        other.fileName == fileName &&
        other.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ fileName.hashCode ^ url.hashCode;

  @override
  String toString() {
    return 'ImageModel(id: $id, fileName: $fileName, url: $url)';
  }
}
