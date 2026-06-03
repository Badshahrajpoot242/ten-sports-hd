// lib/models/category_model.dart
import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String iconEmoji;
  final String? thumbnailUrl;
  final List<SubCategoryModel> subCategories;
  final bool isLive;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconEmoji,
    this.thumbnailUrl,
    required this.subCategories,
    this.isLive = false,
    this.sortOrder = 0,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      iconEmoji: map['iconEmoji'] ?? '📺',
      thumbnailUrl: map['thumbnailUrl'],
      subCategories: (map['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      isLive: map['isLive'] ?? false,
      sortOrder: map['sortOrder'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconEmoji': iconEmoji,
      'thumbnailUrl': thumbnailUrl,
      'subCategories': subCategories.map((e) => e.toMap()).toList(),
      'isLive': isLive,
      'sortOrder': sortOrder,
    };
  }
}

class SubCategoryModel {
  final String id;
  final String title;
  final String subtitle;
  final String? thumbnailUrl;
  final String? iconEmoji;
  final List<SubCategoryModel> subCategories;
  final List<VideoLinkModel> videoLinks;
  final bool isLive;

  const SubCategoryModel({
    required this.id,
    required this.title,
    required this.subtitle,
    this.thumbnailUrl,
    this.iconEmoji,
    this.subCategories = const [],
    this.videoLinks = const [],
    this.isLive = false,
  });

  bool get hasSubCategories => subCategories.isNotEmpty;
  bool get hasVideoLinks => videoLinks.isNotEmpty;

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      thumbnailUrl: map['thumbnailUrl'],
      iconEmoji: map['iconEmoji'],
      subCategories: (map['subCategories'] as List<dynamic>? ?? [])
          .map((e) => SubCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      videoLinks: (map['videoLinks'] as List<dynamic>? ?? [])
          .map((e) => VideoLinkModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      isLive: map['isLive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'thumbnailUrl': thumbnailUrl,
      'iconEmoji': iconEmoji,
      'subCategories': subCategories.map((e) => e.toMap()).toList(),
      'videoLinks': videoLinks.map((e) => e.toMap()).toList(),
      'isLive': isLive,
    };
  }
}

class VideoLinkModel {
  final String id;
  final String title;
  final String url;
  final VideoType type;
  final String quality;
  final String? thumbnailUrl;
  final bool isWorking;

  const VideoLinkModel({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    this.quality = 'HD',
    this.thumbnailUrl,
    this.isWorking = true,
  });

  factory VideoLinkModel.fromMap(Map<String, dynamic> map) {
    return VideoLinkModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      url: map['url'] ?? '',
      type: VideoType.values.firstWhere(
        (e) => e.name == (map['type'] ?? 'hls'),
        orElse: () => VideoType.hls,
      ),
      quality: map['quality'] ?? 'HD',
      thumbnailUrl: map['thumbnailUrl'],
      isWorking: map['isWorking'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'type': type.name,
      'quality': quality,
      'thumbnailUrl': thumbnailUrl,
      'isWorking': isWorking,
    };
  }
}

enum VideoType { hls, mp4, youtube, dash }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final String? deepLink;
  final DateTime timestamp;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.deepLink,
    required this.timestamp,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      imageUrl: map['imageUrl'],
      deepLink: map['deepLink'],
      timestamp: map['timestamp'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'deepLink': deepLink,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }
}
