import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:marshall/screens/song_screen.dart';

import '../models/search_models.dart';
import '../services/api_endpoints.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Result> _results = [];
  bool _isLoading = false;

  Future<void> performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('${ApiEndpoints.SearchEndpoint}${Uri.encodeComponent(query)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final resultsJson = jsonData['data']?['results'] as List<dynamic>? ?? [];

        setState(() {
          _results = resultsJson.map((e) => Result.fromJson(e)).toList();
        });

        if (_results.isEmpty) {
          print("No results found for '$query'");
        }
      } else {
        print('Failed to fetch search results: ${response.statusCode}');
        setState(() => _results = []);
      }
    } catch (e) {
      print('Error searching: $e');
      setState(() => _results = []);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: "dot",
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/backgroundWhite.png",
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("|", style: TextStyle(color: Colors.green, fontSize: 25)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextFormField(
                              controller: searchController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "semi",
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Artist or Song",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              onFieldSubmitted: (query) {
                                performSearch(query);
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.green),
                          onPressed: () {
                            performSearch(searchController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                      : _results.isEmpty
                      ? const Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final song = _results[index];
                      return ListTile(
                        leading: song.image.isNotEmpty
                            ? Image.network(
                          song.image[0].link,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                            : const Icon(
                          CupertinoIcons.music_note,
                          color: Colors.white,
                        ),
                        title: Text(
                          song.name,
                          style: const TextStyle(fontFamily: "semi",color: Colors.white),
                        ),
                        subtitle: Text(
                          song.primaryArtists.length > 20
                              ? '${song.primaryArtists.substring(0, 20)}...'
                              : song.primaryArtists,
                          style: const TextStyle(color: Colors.white70, fontFamily: "regular"),
                        ),

                        // Inside onTap of ListTile
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SongScreen(song: song),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
