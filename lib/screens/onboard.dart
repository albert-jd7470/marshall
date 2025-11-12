import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marshall/screens/artist_playlist.dart';
import 'package:marshall/screens/liked_songs.dart';
import 'package:marshall/screens/playlist_SongScreen.dart';
import 'package:marshall/screens/see_all.dart';
import 'package:marshall/screens/song_screen.dart';

import '../models/trending_models.dart';
import '../services/playlist_services.dart';
import '../services/trending_services.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});
  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  String? username;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  String? cachedUsername;
  Future<List<AlbumElement>> fetchTrendingForUser() async {
    final fixedLanguages = ['Malayalam', 'English', 'Tamil'];
    print("Fetching trending for languages: $fixedLanguages");

    List<AlbumElement> allTrending = [];

    for (String lang in fixedLanguages) {
      final trending = await TrendingService.fetchTrendingForLanguage(lang);
      allTrending.addAll(trending);
    }

    print("Total trending songs fetched: ${allTrending.length}");
    return allTrending;
  }

  Future<void> fetchUsername() async {
    if (cachedUsername != null) {
      setState(() => username = cachedUsername);
      return;
    }
    final user = auth.currentUser;
    if (user != null) {
      final doc = await firestore
          .collection('HankTunes')
          .doc('7FNdKVtY42ArPwW71Omy')
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        cachedUsername = doc.data()?['username'] ?? 'User';
        setState(() {
          username = cachedUsername;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          username == null ? "Have A Nice Day" : "Hello $username",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: "dot",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(Icons.notifications, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundWhite.png", fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 125, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LikedSongs(),
                              ),
                            );
                          },
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Liked Songs",
                                  style: TextStyle(
                                    fontFamily: "semi",
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.favorite, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Playlist",
                                style: TextStyle(
                                  fontFamily: "semi",
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.playlist_play_outlined,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Recently Played",
                            style: TextStyle(
                              fontFamily: "semi",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Image(
                            image: AssetImage("assets/Recents.png"),
                            color: Colors.white,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SeeAll()),
                          );
                          ;
                        },
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontFamily: "semi",
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  //----------------recentlyHead----------------
                  const SizedBox(height: 25),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SongScreen(),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "SongName(From Movie)",
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Singer,Singer2",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //----------------recentlyEnd----------------
                  //----------Trending------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Trending Songs",
                            style: TextStyle(
                              fontFamily: "semi",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.fiber_new_outlined, color: Colors.white),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SeeAll()),
                          );
                          ;
                        },
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontFamily: "semi",
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<AlbumElement>>(
                      future: fetchTrendingForUser(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.greenAccent,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No trending songs found.',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "dot",
                              ),
                            ),
                          );
                        }
                        final trending = snapshot.data!;
                        return Row(
                          children: trending.map((song) {
                            final imageUrl = song.image.isNotEmpty
                                ? song.image[0].link
                                : '';
                            final artistNames = song.primaryArtists.isNotEmpty
                                ? song.primaryArtists
                                      .map((e) => e.name)
                                      .join(', ')
                                : 'Unknown';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final songs = await PlaylistService.fetchPlaylistSongs(song.url);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistSongsScreen(
                                            playlist: song,
                                            songs: songs,
                                          ),
                                        ),
                                      );
                                    },


                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: imageUrl.isNotEmpty
                                            ? DecorationImage(
                                                image: NetworkImage(imageUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                        color: Colors.white10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    song.name,
                                    style: const TextStyle(
                                      fontFamily: "bold",
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    artistNames,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  //----------TrendingEnd------------
                  //----------ArtistHead------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Artists",
                            style: TextStyle(
                              fontFamily: "semi",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(Icons.mic, color: Colors.white),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SeeAll()),
                          );
                          ;
                        },
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontFamily: "semi",
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArtistPlaylist(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "ArtistName",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //----------ArtistEnd------------
                  //----------TopTrackHead------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "TopTrack",
                            style: TextStyle(
                              fontFamily: "semi",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.auto_fix_high_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SeeAll()),
                          );
                          ;
                        },
                        child: Text(
                          "Show All",
                          style: TextStyle(
                            fontFamily: "semi",
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 1; i <= 5; i++)
                          GestureDetector(
                            onTap: () {
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SongScreen(),));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "SongName(From Movie)",
                                    style: TextStyle(
                                      fontFamily: "bold",
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Singer,Singer2",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white60,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  //----------TopTrackEnd------------
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
