import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marshall/models/search_models.dart';
import 'package:marshall/screens/artist_playlist.dart';
import 'package:marshall/screens/liked_songs.dart';
import 'package:marshall/screens/playlist_SongScreen.dart';
import 'package:marshall/screens/see_all.dart';
import 'package:marshall/screens/song_screen.dart';

import '../models/artist_service.dart';
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

  String selectedLanguage = "Malayalam";

  final List<String> languages = [
    "Malayalam",
    "English",
    "Tamil",
    "Hindi",
  ];

  @override
  void initState() {
    super.initState();
    fetchUsername();
    loadArtists();
  }

  String? cachedUsername;
  Future<List<AlbumElement>> fetchTrendingForUser() async {
    print("Fetching trending for $selectedLanguage");
    return await TrendingService.fetchTrendingForLanguage(selectedLanguage);
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

  List<Map<String, dynamic>> homeArtists = [];

  @override

  void loadArtists() async {
    homeArtists = await ArtistService.fetchHomeArtists();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          username == null ? "Hello Guest" : "Hello $username",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "dot",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  elevation: 12,
                  color: Colors.black.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  offset: const Offset(0, 45),
                  onSelected: (value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                  itemBuilder: (context) {
                    return languages.map((lang) {
                      final isSelected = lang == selectedLanguage;

                      return PopupMenuItem<String>(
                        value: lang,
                        child: Row(
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 16,
                              color: isSelected ? Color(0xFF5628F8) : Colors.white70,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              lang,
                              style: TextStyle(
                                color: isSelected ? Color(0xFF5628F8) : Colors.white,
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.deepPurple,
                          Color(0xFF191414),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF5628F8).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          selectedLanguage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "dot",
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("assets/backgroundpurple.png", fit: BoxFit.cover
            ),
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
                            Navigator.push(
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
                              strokeWidth: 2,
                            )
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
                                : '';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final songs =
                                          await PlaylistService.fetchPlaylistSongs(
                                            song.url,
                                          );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PlaylistSongsScreen(
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
      // ---------- Artist Section ----------
      SizedBox(
        height: 230, // ← FIXED HEIGHT (IMPORTANT)
        child: homeArtists.isEmpty
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeArtists.length,
          itemBuilder: (context, index) {
            final artist = homeArtists[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ArtistPlaylist(
                      artistId: artist["id"],
                      artistName: artist["name"],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(artist["image"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: Text(
                        artist["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
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
