import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import '../models/search_models.dart';
import '../models/trending_models.dart';

class AudioService {
  static final AudioPlayer player = AudioPlayer();
  static dynamic currentSong;
  static bool isRepeat = false;
  static bool _isPlayAllMode = false;
  static bool isShuffle = false;




  static Duration position = Duration.zero;
  static Duration duration = Duration.zero;

  static List<AlbumElement> _queue = [];
  static int _currentIndex = 0;
  static bool isRepeatAll = false;



  static void init() {
    player.setReleaseMode(ReleaseMode.release);

    player.onDurationChanged.listen((d) {
      duration = d;
    });

    player.onPositionChanged.listen((p) {
      position = p;
    });

    player.onPlayerComplete.listen((_) async {
        await player.seek(Duration.zero);

      if (isRepeat) {
        await player.play(player.source!);
        return;
      }

      if (_isPlayAllMode) {
        await playNext();
      } else {
        position = Duration.zero;
      }
    });


  }
  static Future<void> playAllSongs(List<AlbumElement> songs) async {
    if (songs.isEmpty) return;

    _queue = List.from(songs); // keep playlist order
    _currentIndex = 0;

    await playSong(_queue[_currentIndex]);
  }



  static Future<void> playNext() async {
    if (_currentIndex + 1 < _queue.length) {
      _currentIndex++;
      await playSong(_queue[_currentIndex]);
    } else {
      print("⏹ End of playlist");
    }
  }
  static void toggleShuffle() {
    isShuffle = !isShuffle;

    if (isShuffle) {
      _queue.shuffle();
      _currentIndex = 0;
    }
  }


  static Future<void> playPrevious() async {
    if (_currentIndex - 1 >= 0) {
      _currentIndex--;
      await playSong(_queue[_currentIndex]);
    }
  }
  static Future<void> playSong(dynamic song) async {
    if (song == null) return;

    String? url;

    if (song is Result && song.downloadUrl.isNotEmpty) {
      url = song.downloadUrl[0].link;
    } else if (song is AlbumElement) {
      url = await _getPlayableUrl(song.id);
    }

    if (url == null || url.isEmpty) {
      print("No playable URL for ${song.name}");
      return;
    }

    currentSong = song;

    if (song is AlbumElement) {
      final index = _queue.indexWhere((s) => s.id == song.id);
      if (index != -1) {
        _currentIndex = index;
      }
    }

    try {
      await player.stop();
      await player.setSource(UrlSource(url));
      await player.resume();
      print("Now playing: ${song.name}");
    } catch (e) {
      print("Error playing song: $e");
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
      print("Error fetching playable URL: $e");
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
