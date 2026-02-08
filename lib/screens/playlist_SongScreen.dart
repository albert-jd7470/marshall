import 'package:flutter/material.dart';
import '../models/trending_models.dart';
import '../services/playlist_services.dart';
import '../services/audio_services.dart';
import '../widgets/bottom_music.dart';
import '../widgets/bottomnavigations.dart';
import 'package:html_unescape/html_unescape.dart';


class PlaylistSongsScreen extends StatefulWidget {
  final AlbumElement playlist;
  final List<AlbumElement>? songs;

  const PlaylistSongsScreen({
    super.key,
    required this.playlist,
    required this.songs,
  });

  @override
  State<PlaylistSongsScreen> createState() => _PlaylistSongsScreenState();
}

class _PlaylistSongsScreenState extends State<PlaylistSongsScreen> {

  late Future<List<AlbumElement>> songsFuture;
  final HtmlUnescape _htmlUnescape = HtmlUnescape();

  String cleanText(String text) {
    return _htmlUnescape
        .convert(text)
        .replaceAll('"', '')
        .trim();
  }

  @override
  void initState() {
    super.initState();
    songsFuture = PlaylistService.fetchPlaylistSongs(widget.playlist.id);
  }

  void playSong(AlbumElement song) async {
    await AudioService.playSong(song);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => Bottomnavigations()),
            );
          },
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.playlist.name.length > 20
              ? widget.playlist.name.substring(0, 20)
              : widget.playlist.name,
          style: const TextStyle(color: Colors.white, fontFamily: "dot"),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // 🎨 Background
          SizedBox.expand(
            child: Image.asset(
              "assets/backgroundpurple.png",
              fit: BoxFit.cover,
            ),
          ),

          // 🎵 CONTENT
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: FutureBuilder<List<AlbumElement>>(
              future: songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final songs = snapshot.data!;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {

                          AudioService.playAllSongs(songs);
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(height: 65,child: Image(image: AssetImage("assets/ShuffelAll.png",),)),
                          ],
                        )
                      ),
                    ),

                    // 🎶 SONG LIST
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: songs.length,

                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => playSong(song),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.deepPurple.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                      Colors.white.withOpacity(0.2),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        offset: Offset(2, 3),
                                      )
                                    ],
                                  ),
                                  child: ListTile(
                                    leading: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: song.image.isNotEmpty
                                          ? Image.network(
                                        song.image[1].link,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                          : const Icon(Icons.music_note,
                                          color: Colors.grey,
                                          size: 50),
                                    ),
                                    title: Text(
                                      song.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color:
                                        Colors.deepPurpleAccent,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      song.primaryArtists.isNotEmpty
                                          ? song.primaryArtists
                                          .map((a) => a.name)
                                          .join(', ')
                                          : '',
                                      style: const TextStyle(
                                          color: Colors.white),
                                    ),
                                    trailing: const Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.deepPurple,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 🎧 BOTTOM PLAYER
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
              EdgeInsets.only(bottom: 50, left: 20, right: 20),
              child: BottomMusicBar(),
            ),
          ),
        ],
      ),
    );
  }
}
