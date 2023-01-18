import 'package:hive/hive.dart';
import 'package:resfy_music/db/models/songmodel.dart';
part 'playlistmodel.g.dart';

@HiveType(typeId: 4)
class Playlistsongs {
  @HiveField(0)
  String? playlistname;

  @HiveField(1)
  List<Songs>? playlistsongs;

  Playlistsongs({required this.playlistname, required this.playlistsongs});
}

class PlaylistSongsbox {
  static Box<Playlistsongs>? _box;
  static Box<Playlistsongs> getInstance() {
    return _box ??= Hive.box('playlist');
  }
}
