
//---------------
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:marshall/screens/bottomnavigations.dart';
import '../models/search_models.dart';
import 'package:audioplayers/audioplayers.dart';


class SongScreen extends StatefulWidget {
  final Result song;

  const SongScreen({super.key, required this.song});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  bool isPlaying = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Optional: stop after song ends
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // Load the first available song URL
    if (widget.song.downloadUrl.isNotEmpty) {
      _audioPlayer.setSource(UrlSource(widget.song.downloadUrl[0].link));
    }
  }

  void playpause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Bottomnavigations()),
            );
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
                color: Colors.white54,
                fontSize: 10,
                fontFamily: "semi",
              ),
            ),
            Text(
              widget.song.name, // Dynamic song name
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundGreen.png", fit: BoxFit.fill),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.maxFinite,
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(25),
                        image: widget.song.image.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(widget.song.image[0].link),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        left: 30,
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.song.name.length > 20
                                    ? SizedBox(
                                  height: 25,
                                  child: Marquee(
                                    text: widget.song.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: "semi",
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    blankSpace: 50,
                                    velocity: 20,
                                    startPadding: 10,
                                    pauseAfterRound: const Duration(seconds: 1),
                                  ),
                                )
                                    : Text(
                                  widget.song.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: "semi",
                                  ),
                                ),
                                widget.song.primaryArtists.length > 20
                                    ? SizedBox(
                                  height: 20,
                                  child: Marquee(
                                    text: widget.song.primaryArtists,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                      fontFamily: "semi",
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    blankSpace: 50,
                                    velocity: 15,
                                    startPadding: 10,
                                    pauseAfterRound: const Duration(seconds: 1),
                                  ),
                                )
                                    : Text(
                                  widget.song.primaryArtists,
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontFamily: "semi",
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      )

                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Container(
                      width: double.maxFinite,
                      height: 5,
                      color: Colors.white54,
                      child: Container(width: 50, height: 5, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("00:00", style: TextStyle(color: Colors.white)),
                        Text("00:00", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Image(
                          image: AssetImage("assets/Repeat.png"),
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            const Image(
                              image: AssetImage("assets/Previous.png"),
                              color: Colors.white,
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: playpause,
                              child: Icon(
                                isPlaying ? Icons.pause_circle : Icons.play_circle,
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
                        const Icon(
                          Icons.favorite_outline_sharp,
                          color: Colors.green,
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

