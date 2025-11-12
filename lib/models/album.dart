import 'package:marshall/models/trending_models.dart';

class AlbumElement {
  final String id;
  final String name;
  final String url;
  final String language;
  final List<Artist> primaryArtists;
  final List<ImageElement> image;

  AlbumElement({
    required this.id,
    required this.name,
    required this.url,
    required this.language,
    required this.primaryArtists,
    required this.image,
  });
}
