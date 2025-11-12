// ---------- Trending.dart ----------
class Trending {
  final String status;
  final dynamic message;
  final Data data;

  Trending({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Trending.fromJson(Map<String, dynamic> json) {
    return Trending(
      status: json['status'] ?? '',
      message: json['message'],
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final TrendingClass trending;

  Data({required this.trending});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      trending: TrendingClass.fromJson(json['trending']),
    );
  }
}

class TrendingClass {
  final List<AlbumElement> songs;

  TrendingClass({required this.songs});

  factory TrendingClass.fromJson(Map<String, dynamic> json) {
    return TrendingClass(
      songs: (json['songs'] as List)
          .map((e) => AlbumElement.fromJson(e))
          .toList(),
    );
  }
}

class AlbumElement {
  final String id;
  final String name;
  final String url;
  final List<Artist> primaryArtists;
  final List<ImageElement> image;
  final String language;

  AlbumElement({
    required this.id,
    required this.name,
    required this.url,
    required this.primaryArtists,
    required this.image,
    required this.language,
  });

  factory AlbumElement.fromJson(Map<String, dynamic> json) {
    return AlbumElement(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      language: json['language'] ?? '',
      primaryArtists: (json['primaryArtists'] as List? ?? [])
          .map((e) => Artist.fromJson(e))
          .toList(),
      image: (json['image'] as List? ?? [])
          .map((e) => ImageElement.fromJson(e))
          .toList(),
    );
  }
}

class Artist {
  final String id;
  final String name;

  Artist({required this.id, required this.name});

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ImageElement {
  final String link;

  ImageElement({required this.link});

  factory ImageElement.fromJson(Map<String, dynamic> json) {
    return ImageElement(
      link: json['link'] ?? '',
    );
  }
}
