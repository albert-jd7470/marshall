import 'dart:convert';
import 'package:http/http.dart' as http;

class ArtistService {
  static Future<List<Map<String, dynamic>>> fetchHomeArtists() async {
    final url = Uri.parse(
      "https://jio-saavn-api.vercel.app/api/search/artists?query=top",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) return [];

      final jsonData = json.decode(response.body);

      final results = jsonData["data"] ?? [];

      return results.map<Map<String, dynamic>>((artist) {
        final images = artist["image"] ?? [];

        return {
          "id": artist["id"] ?? "",
          "name": artist["title"] ?? "Unknown Artist",
          "image": images.isNotEmpty ? images.last["url"] : "",
        };
      }).toList();

    } catch (e) {
      print("Artist error: $e");
      return [];
    }
  }
}
