class ApiEndpoints {
  static const String baseurl = 'https://server-steel-eight.vercel.app';

  // ✅ Trending, Albums, Songs
  static const String GetTrendinglanguages = '$baseurl/modules?language=';
  static const String GetAlbumSongs = '$baseurl/albums?link=';
  static const String SearchEndpoint = '$baseurl/search/songs?query=';
  static const String GetNewRelease = 'https://www.jiosaavn.com/api.php?';
  static const String Getlyrics = '$baseurl/lyrics?id=';
  static const String GetSong = "$baseurl/songs?link=";

  static const String playlistbase = '$baseurl/playlists';

  static const String redirecturl = 'app://space/auth';
  static const String clientid = '08de4eaf71904d1b95254fab3015d711';
  static const String clientSecret = '622b4fbad33947c59b95a6ae607de11d';
  static const String ytdislike = 'https://returnyoutubedislikeapi.com/votes?videoId=';
  static const String Suggestionurl = "https://getit-three.vercel.app/";

  final String jiosaavnSearchSong = '&n=10&__call=search.getResults';
  final String GetTopSeraches = 'content.getTopSearches';
}
