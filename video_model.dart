// lib/data/models/video_model.dart

class VideoModel {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String url;
  final String type; // m3u8, mp4, youtube
  final String categoryId;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.url,
    required this.type,
    required this.categoryId,
  });

  factory VideoModel.fromMap(
      String id, String categoryId, Map<dynamic, dynamic> map) {
    return VideoModel(
      id: id,
      categoryId: categoryId,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      thumbnail: map['thumbnail']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      type: map['type']?.toString() ?? 'mp4',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'thumbnail': thumbnail,
      'url': url,
      'type': type,
    };
  }

  bool get isYoutube => type == 'youtube';
  bool get isM3u8 => type == 'm3u8';
  bool get isMp4 => type == 'mp4';
  bool get isLive => isM3u8;
}
