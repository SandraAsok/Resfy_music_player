import 'package:hive/hive.dart';
part 'recentlyplayed.g.dart';

@HiveType(typeId: 3)
class Recentlyplayed {
  @HiveField(0)
  String? songname;

  @HiveField(1)
  int? duration;

  @HiveField(2)
  String? songurl;

  @HiveField(3)
  int? id;

  @HiveField(4)
  int? index;

  Recentlyplayed({
    this.songname,
    this.duration,
    required this.id,
    required this.index,
    this.songurl,
  });
}

String boxname3 = 'Recently played';

class RecentlyplayedBox {
  static Box<Recentlyplayed>? _box;
  static Box<Recentlyplayed> getInstance() {
    return _box ??= Hive.box(boxname3);
  }
}
