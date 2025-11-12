import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import '../models/search_models.dart';
import '../models/trending_models.dart';

class AudioService {
  static final AudioPlayer player = AudioPlayer();
  static dynamic currentSong; // can hold Result or AlbumElement
  static bool isRepeat = false;

  static Duration position = Duration.zero;
  static Duration duration = Duration.zero;

  static void init() {
    player.setReleaseMode(ReleaseMode.stop);

    player.onDurationChanged.listen((d) {
      duration = d;
    });

    player.onPositionChanged.listen((p) {
      position = p;
    });

    player.onPlayerComplete.listen((_) {
      if (isRepeat) {
        player.seek(Duration.zero);
        player.resume();
      }
    });
  }

  // ✅ Supports both Result (search) & AlbumElement (playlist)
  static Future<void> playSong(dynamic song) async {
    if (song == null) return;

    String? url;

    if (song is Result && song.downloadUrl.isNotEmpty) {
      url = song.downloadUrl[0].link;
    } else if (song is AlbumElement) {
      // Convert playlist link into real streamable URL
      url = await _getPlayableUrl(song.id);
    }

    if (url == null || url.isEmpty) {
      print("⚠️ No playable URL for ${song.name}");
      return;
    }

    currentSong = song;

    try {
      await player.stop();
      await player.setSource(UrlSource(url));
      await player.resume();
      print("🎧 Now playing: ${song.name}");
    } catch (e) {
      print("❌ Error playing song: $e");
    }
  }

  static Future<String?> _getPlayableUrl(String songId) async {
    try {
      final uri = Uri.parse("https://server-steel-eight.vercel.app/songs?id=$songId");
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        return jsonData['data']?[0]?['downloadUrl']?[0]?['link'];
      }
    } catch (e) {
      print("⚠️ Error fetching playable URL: $e");
    }
    return null;
  }


  static Future<void> pause() async => await player.pause();

  static Future<void> resume() async => await player.resume();

  static void toggleRepeat() {
    isRepeat = !isRepeat;
    player.setReleaseMode(isRepeat ? ReleaseMode.loop : ReleaseMode.stop);
  }

  static bool get isPlaying => player.state == PlayerState.playing;

}
