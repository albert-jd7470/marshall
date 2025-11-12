import 'package:flutter/material.dart';
import '../models/trending_models.dart';
import '../services/playlist_services.dart';
import '../services/audio_services.dart';
import 'bottom_music.dart';
import 'bottomnavigations.dart';

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

  @override
  void initState() {
    super.initState();
    songsFuture = PlaylistService.fetchPlaylistSongs(widget.playlist.id);
  }

  void playSong(AlbumElement song) async {
    await AudioService.playSong(song); // ✅ plays via global AudioService
    setState(() {}); // rebuild to update BottomMusicBar
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
          widget.playlist.name,
          style: const TextStyle(color: Colors.white, fontFamily: "dot"),
        ),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true, // ✅ Ensures BottomMusicBar overlays correctly
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset("assets/backgroundWhite.png", fit: BoxFit.fill),
          ),

          // Songs list
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: FutureBuilder<List<AlbumElement>>(
              future: songsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs found.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final songs = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => playSong(song),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(2, 3),
                              )
                            ],
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: song.image.isNotEmpty
                                  ? Image.network(
                                song.image[0].link,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(Icons.music_note,
                                  color: Colors.grey, size: 50),
                            ),
                            title: Text(
                              song.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              song.primaryArtists.isNotEmpty
                                  ? song.primaryArtists
                                  .map((a) => a.name)
                                  .join(', ')
                                  : 'Unknown Artist',
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                            trailing: Icon(
                              Icons.play_circle_fill,
                              color: Colors.black,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🎶 Bottom Music Player (Global)
          const Align(
            alignment: Alignment.bottomCenter,
            child: BottomMusicBar(), // ✅ displays your global player
          ),

        ],
      ),
    );
  }
}
