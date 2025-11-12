import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_models.dart';
import 'api_endpoints.dart';

class PlaylistService {
  /// 🔹 Fetch songs from a JioSaavn playlist
  static Future<List<AlbumElement>> fetchPlaylistSongs(String playlistId) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.playlistbase}?id=$playlistId');
      print("🎧 Fetching playlist songs from: $uri");


      final response = await http.get(uri);
      print("🔹 Status code: ${response.statusCode}");

      if (response.statusCode != 200) {
        print("❌ Non-200 status code");
        print("Response body: ${response.body}");
        return [];
      }

      final jsonData = json.decode(response.body);
      final songsData = jsonData['data']?['songs'] ?? jsonData['data'] ?? [];

      print("🎶 Found ${songsData.length} songs in playlist");

      return songsData.map<AlbumElement>((e) {
        return AlbumElement(
          id: e['id']?.toString() ?? '',
          name: e['title'] ?? '',
          url: e['url'] ?? '',
          language: e['language'] ?? '',
          primaryArtists: _parseArtists(e['primaryArtists']),
          image: (e['image'] as List? ?? [])
              .map((img) => ImageElement(link: img['link'] ?? ''))
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('💥 Error fetching playlist songs: $e');
      return [];
    }
  }


  static Future<List<AlbumElement>> fetchAlbumSongs(String albumUrl) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.GetAlbumSongs}?link=$albumUrl');
      print("🎧 Fetching album songs from: $uri");

      final response = await http.get(uri);
      print("🔹 Status code: ${response.statusCode}");

      if (response.statusCode != 200) {
        print("❌ Non-200 status code");
        print("Response body: ${response.body}");
        return [];
      }

      final jsonData = json.decode(response.body);
      final songsData = jsonData['data']?['songs'] ?? [];

      print("🎶 Found ${songsData.length} songs in album");

      return songsData.map<AlbumElement>((e) {
        return AlbumElement(
          id: e['id']?.toString() ?? '',
          name: e['name'] ?? e['title'] ?? '',
          url: e['downloadUrl']?[0]?['link'] ?? e['url'] ?? '',
          language: e['language'] ?? '',
          primaryArtists: _parseArtists(e['primaryArtists']),
          image: (e['image'] as List? ?? [])
              .map((img) => ImageElement(link: img['link'] ?? ''))
              .toList(),
        );
      }).toList();
    } catch (e) {
      print('💥 Error fetching album songs: $e');
      return [];
    }
  }

  /// 🔹 Auto-detects and fetches based on link type
  static Future<List<AlbumElement>> fetchSongsAuto(String link) async {
    if (link.contains('/album/')) {
      print("🎶 Detected Album Link");
      return await fetchAlbumSongs(link);
    } else {
      print("🎶 Detected Playlist Link");
      return await fetchPlaylistSongs(link);
    }
  }

  /// 🧩 Helper to parse artist data
  static List<Artist> _parseArtists(dynamic artistsData) {
    if (artistsData is List) {
      return artistsData
          .map((a) => Artist(id: a['id'] ?? '', name: a['name'] ?? ''))
          .toList();
    } else if (artistsData is String) {
      return artistsData
          .split(',')
          .map((name) => Artist(id: '', name: name.trim()))
          .toList();
    }
    return [];
  }
}
