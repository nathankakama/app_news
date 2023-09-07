import 'package:webfeed/domain/rss_item.dart';

class Article {
  String? _title;
  String? _description;
  DateTime? _pubDate;
  String? _imageUrl;
  String? _urlLink;

  String get title => _title ?? "";
  String get description => _description ?? "";
  DateTime get date => _pubDate ?? DateTime.now();
  String get imageUrl => _imageUrl ?? "";
  String get link => _urlLink ?? "";

  Article({required RssItem item}) {
    _title = item.title;
    _description = item.description;
    _pubDate = item.pubDate;
    _imageUrl = item.enclosure?.url;
    _urlLink = item.link;
  }
}