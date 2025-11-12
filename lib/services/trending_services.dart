import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trending_models.dart';
import 'api_endpoints.dart';

class TrendingService {
  static Future<List<AlbumElement>> fetchTrendingForLanguage(String language) async {
    try {
      final url = Uri.parse('${ApiEndpoints.GetTrendinglanguages}$language');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];

        final List<dynamic> chartList = data['charts'] ?? [];

        List<AlbumElement> trendingSongs = chartList.map((e) {
          // 👇 print one item for debugging
          print("Raw trending item: ${json.encode(e)}");

          // ✅ use perma_url if available
          final link = e['perma_url'] ??
              e['more_info']?['perma_url'] ??
              e['url'] ??
              e['link'] ??
              '';

          return AlbumElement(
            id: e['id'].toString(),
            name: e['title'] ?? '',
            url: link, // <<-- store the full perma_url here
            language: e['language'] ?? language,
            primaryArtists: [],
            image: (e['image'] as List<dynamic>? ?? [])
                .map((img) => ImageElement(link: img['link'] ?? ''))
                .toList(),
          );
        }).toList();

        print('Fetched ${trendingSongs.length} songs for $language');
        return trendingSongs;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching trending for $language: $e");
      return [];
    }
  }
  static Future<List<AlbumElement>> fetchAlbumSongs(String albumUrl) async {
    try {
      final url = Uri.parse('${ApiEndpoints.GetAlbumSongs}$albumUrl');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'] ?? [];

        return (data as List).map((e) {
          return AlbumElement(
            id: e['id'].toString(),
            name: e['title'] ?? '',
            url: e['url'] ?? '',
            language: e['language'] ?? '',
            primaryArtists: [],
            image: (e['image'] as List<dynamic>? ?? [])
                .map((img) => ImageElement(link: img['link'] ?? ''))
                .toList(),
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching album songs: $e');
      return [];
    }
  }
}




