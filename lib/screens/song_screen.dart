import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/search_models.dart';
import '../models/trending_models.dart'; // ✅ Added for AlbumElement
import '../screens/liked_songs.dart';
import '../services/audio_services.dart';

class SongScreen extends StatefulWidget {
  final dynamic song; // ✅ Works for Result or AlbumElement

  const SongScreen({super.key, required this.song});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  final AudioPlayer player = AudioService.player;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool get isPlaying => AudioService.isPlaying;
  bool get isRepeat => AudioService.isRepeat;

  @override
  void initState() {
    super.initState();

    player.onPositionChanged.listen((pos) {
      if (!mounted) return;
      setState(() => _position = pos);
    });

    player.onDurationChanged.listen((dur) {
      if (!mounted) return;
      setState(() => _duration = dur);
    });

    // ✅ Ensure correct song plays
    if (AudioService.currentSong?.id != widget.song.id) {
      AudioService.playSong(widget.song);
    }

    _primeState();
  }

  Future<void> _primeState() async {
    final d = await player.getDuration();
    final p = await player.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      _duration = d ?? Duration.zero;
      _position = p ?? Duration.zero;
    });
  }

  void playPause() {
    isPlaying ? AudioService.pause() : AudioService.resume();
    setState(() {});
  }

  void toggleRepeat() {
    AudioService.toggleRepeat();
    setState(() {});
  }

  void seekTo(double progress) {
    final newPos = progress * _duration.inMilliseconds;
    player.seek(Duration(milliseconds: newPos.toInt()));
  }

  String _formatDuration(Duration duration) {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void liked() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Added To Liked",
          style: TextStyle(fontFamily: "dot"),
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LikedSongs()),
    );
  }

  // ✅ Safe getters for both Result & AlbumElement
  String getSongName(dynamic song) {
    try {
      if (song is Result) return song.name;
      if (song is AlbumElement) return song.name;
    } catch (_) {}
    return "Unknown Song";
  }

  String getArtist(dynamic song) {
    try {
      if (song is Result) {
        if (song.primaryArtists.isNotEmpty) return song.primaryArtists;
      } else if (song is AlbumElement) {
        if (song.primaryArtists.isNotEmpty) {
          return song.primaryArtists.map((a) => a.name).join(', ');
        }
      }
    } catch (_) {}
    return "Unknown Artist";
  }

  String getImage(dynamic song) {
    try {
      if (song.image != null && song.image.isNotEmpty) {
        if (song.image.length > 2) return song.image[2].link;
        return song.image.first.link;
      }
    } catch (_) {}
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    final image = getImage(song);
    final name = getSongName(song);
    final artist = getArtist(song);

    double progress = (_duration.inMilliseconds == 0)
        ? 0
        : _position.inMilliseconds / _duration.inMilliseconds;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Image(
            image: AssetImage("assets/Hide.png"),
            color: Colors.white,
          ),
        ),
        title: Column(
          children: [
            const Text(
              "PLAYING FROM YOUR LIBRARY",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: "semi",
              ),
            ),
            name.length > 20
                ? SizedBox(
              height: 20,
              child: Marquee(
                text: name,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontFamily: "semi",
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 50,
                velocity: 20,
                startPadding: 10,
                pauseAfterRound: Duration(seconds: 1),
              ),
            )
                : Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: "semi",
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.more_vert_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundWhite.png", fit: BoxFit.fill),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ✅ Safe image
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.maxFinite,
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(25),
                          image: image.isNotEmpty
                              ? DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: image.isEmpty
                            ? const Icon(Icons.music_note,
                            color: Colors.white54, size: 80)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // ✅ Title + Artist
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          name.length > 20
                              ? SizedBox(
                            height: 25,
                            child: Marquee(
                              text: name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "semi",
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 50,
                              velocity: 20,
                              startPadding: 10,
                              pauseAfterRound: Duration(seconds: 1),
                            ),
                          )
                              : Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "semi",
                            ),
                          ),
                          const SizedBox(height: 5),
                          artist.length > 20
                              ? SizedBox(
                            height: 20,
                            child: Marquee(
                              text: artist,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                fontFamily: "semi",
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 50,
                              velocity: 15,
                              startPadding: 10,
                              pauseAfterRound: Duration(seconds: 1),
                            ),
                          )
                              : Text(
                            artist,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontFamily: "semi",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double barWidth = constraints.maxWidth;
                          return GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              double localDx = details.localPosition.dx;
                              double progressValue =
                              (localDx / barWidth).clamp(0.0, 1.0);
                              seekTo(progressValue);
                            },
                            onTapDown: (details) {
                              double localDx = details.localPosition.dx;
                              double progressValue =
                              (localDx / barWidth).clamp(0.0, 1.0);
                              seekTo(progressValue);
                            },
                            child: SizedBox(
                              height: 15,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  Container(
                                    width: barWidth * progress,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  Positioned(
                                    left: barWidth * progress - 7,
                                    top: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Time
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: toggleRepeat,
                            child: Image.asset(
                              "assets/Repeat.png",
                              color: isRepeat ? Colors.white : Colors.white60,
                            ),
                          ),
                          Row(
                            children: [
                              const Image(
                                image: AssetImage("assets/Previous.png"),
                                color: Colors.white,
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: playPause,
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Image(
                                image: AssetImage("assets/Next.png"),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: liked,
                            icon: const Icon(
                              Icons.favorite_outline_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
