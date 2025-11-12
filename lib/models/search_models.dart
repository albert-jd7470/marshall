class Search {
  String status;
  dynamic message;
  Data data;

  Search({
    required this.status,
    required this.message,
    required this.data,
  });

  static fromJson(jsonData) {}

}

class Data {
  int total;
  int start;
  List<Result> results;

  Data({
    required this.total,
    required this.start,
    required this.results,
  });

}

class Result {
  final String id;
  final String name;
  final String type;
  final Album album;
  final String year;
  final String releaseDate;
  final String duration;
  final String label;
  final String primaryArtists;
  final String primaryArtistsId;
  final String featuredArtists;
  final String featuredArtistsId;
  final int explicitContent;
  final String playCount;
  final String language;
  final String hasLyrics;
  final String url;
  final String copyright;
  final List<DownloadUrl> image;
  final List<DownloadUrl> downloadUrl;

  Result({
    required this.id,
    required this.name,
    required this.type,
    required this.album,
    this.year = '',
    this.releaseDate = '',
    this.duration = '',
    this.label = '',
    this.primaryArtists = '',
    this.primaryArtistsId = '',
    this.featuredArtists = '',
    this.featuredArtistsId = '',
    this.explicitContent = 0,
    this.playCount = '',
    this.language = '',
    this.hasLyrics = 'false',
    this.url = '',
    this.copyright = '',
    this.image = const [],
    this.downloadUrl = const [],
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      year: json['year'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      duration: json['duration'] ?? '',
      label: json['label'] ?? '',
      primaryArtists: json['primaryArtists'] ?? '',
      primaryArtistsId: json['primaryArtistsId'] ?? '',
      featuredArtists: json['featuredArtists'] ?? '',
      featuredArtistsId: json['featuredArtistsId'] ?? '',
      explicitContent: json['explicitContent'] ?? 0,
      playCount: json['playCount'] ?? '',
      language: json['language'] ?? '',
      hasLyrics: json['hasLyrics'] ?? 'false',
      url: json['url'] ?? '',
      copyright: json['copyright'] ?? '',
      album: Album.fromJson(json['album'] ?? {}),
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => DownloadUrl.fromJson(e))
          .toList() ?? [],
      downloadUrl: (json['downloadUrl'] as List<dynamic>?)
          ?.map((e) => DownloadUrl.fromJson(e))
          .toList() ?? [],
    );
  }
}

class Album {
  final String id;
  final String name;
  final String url;

  Album({
    this.id = '',
    this.name = '',
    this.url = '',
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class DownloadUrl {
  final String link;
  final String quality;

  DownloadUrl({this.link = '', this.quality = ''});

  factory DownloadUrl.fromJson(Map<String, dynamic> json) {
    return DownloadUrl(
      link: json['link'] ?? '',
      quality: json['quality'] ?? '',
    );
  }
}


enum Quality {
  THE_12_KBPS,
  THE_150_X150,
  THE_160_KBPS,
  THE_320_KBPS,
  THE_48_KBPS,
  THE_500_X500,
  THE_50_X50,
  THE_96_KBPS
}

enum Language {
  HINDI,
  PUNJABI
}
