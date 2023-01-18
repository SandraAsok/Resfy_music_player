import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/db/models/songmodel.dart';

createplaylist(String name) async {
  final box1 = PlaylistSongsbox.getInstance();
  List<Songs> songsplaylist = [];
  box1.add(Playlistsongs(playlistname: name, playlistsongs: songsplaylist));
}

addtoplaylist(Songs song, int index) {
  final box1 = PlaylistSongsbox.getInstance();
  List<Playlistsongs> playlistdb = box1.values.toList();
  print(playlistdb);
}

deleteplaylist(int index) {
  final box1 = PlaylistSongsbox.getInstance();
  box1.deleteAt(index);
}

deletefromplaylist(int index) {
  final box1 = PlaylistSongsbox.getInstance();
  box1.delete(index);
}
