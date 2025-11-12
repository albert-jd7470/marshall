import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../screens/song_screen.dart';
import '../services/audio_services.dart';

class BottomMusicBar extends StatefulWidget {
  const BottomMusicBar({super.key});

  @override
  State<BottomMusicBar> createState() => _BottomMusicBarState();
}

class _BottomMusicBarState extends State<BottomMusicBar> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioService.player;
    _primeState();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });

    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });
  }

  Future<void> _primeState() async {
    final d = await _audioPlayer.getDuration();
    final p = await _audioPlayer.getCurrentPosition();
    final state = _audioPlayer.state;

    if (!mounted) return;
    setState(() {
      _duration = d ?? Duration.zero;
      _position = p ?? Duration.zero;
      isPlaying = state == PlayerState.playing;
    });
  }

  void playPause() async {
    if (AudioService.currentSong == null) return;
    isPlaying ? await _audioPlayer.pause() : await _audioPlayer.resume();
  }

  void stop() async {
    await _audioPlayer.stop();
    setState(() => isPlaying = false);
    AudioService.currentSong = null;
  }

  // ✅ Helper to get image safely for Result or AlbumElement
  String _getImage(dynamic song) {
    try {
      if (song.image != null && song.image.isNotEmpty) {
        if (song.image.length > 2) return song.image[2].link;
        return song.image[0].link;
      }
    } catch (_) {}
    return "";
  }

  String _getName(dynamic song) {
    try {
      return song.name ?? "Unknown Song";
    } catch (_) {
      return "Unknown Song";
    }
  }

  @override
  Widget build(BuildContext context) {
    final song = AudioService.currentSong;
    if (song == null) return const SizedBox.shrink();

    final songImage = _getImage(song);
    final songName = _getName(song);

    return GestureDetector(
      onTap: () {
        try {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 350),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SongScreen(song: song),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
            ),
          );
        } catch (e) {
          print("⚠️ Navigation Error: $e");
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: Colors.white.withOpacity(0.08),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: songImage.isNotEmpty
                      ? Image.network(
                    songImage,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.music_note, color: Colors.white, size: 45),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songName,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: (_duration.inMilliseconds == 0)
                            ? 0
                            : _position.inMilliseconds / _duration.inMilliseconds,
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        minHeight: 3,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: playPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: stop,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
