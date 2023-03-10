import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/db/models/playlistmodel.dart';
import 'package:resfy_music/widgets/createplaylist.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:resfy_music/widgets/playlistfull_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen({super.key});

  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  final playlistbox = PlaylistSongsbox.getInstance();
  late List<Playlistsongs> playlistsong = playlistbox.values.toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgcolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: tilecolor,
                          borderRadius: BorderRadius.circular(30)),
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                          ),
                        ),
                        color: iconcolor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text(
                  'Your Playlists',
                  style: TextStyle(fontSize: 20, color: fontcolor),
                ),
                trailing: Wrap(
                  spacing: 10,
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: tilecolor),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        color: iconcolor,
                        iconSize: 30,
                        onPressed: () {
                          showplaylistaddoptions(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ValueListenableBuilder<Box<Playlistsongs>>(
                valueListenable: playlistbox.listenable(),
                builder: (context, Box<Playlistsongs> playlistsongs, child) {
                  List<Playlistsongs> playlistsong =
                      playlistsongs.values.toList();
                  return playlistsong.isNotEmpty
                      ? (ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlistsong.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => PlaylistFullList(
                                            playindex: index,
                                            playlistname: playlistsong[index]
                                                .playlistname))));
                              },
                              leading: playlistsong[index]
                                      .playlistsongs!
                                      .isNotEmpty
                                  ? QueryArtworkWidget(
                                      keepOldArtwork: true,
                                      artworkBorder: BorderRadius.circular(10),
                                      id: playlistsong[index]
                                          .playlistsongs![0]
                                          .id!,
                                      type: ArtworkType.AUDIO)
                                  : SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              title: Text(
                                playlistsong[index].playlistname!,
                                style: const TextStyle(color: fontcolor),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  deleteplaylist(index);
                                },
                                icon: const Icon(Icons.delete),
                                color: iconcolor,
                              ),
                            );
                          }),
                        ))
                      : const Center(
                          child: Text(
                            "You haven't created any playlist!",
                            style: TextStyle(color: fontcolor),
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

showplaylistaddoptions(BuildContext context) {
  final myController = TextEditingController();
  double vwidth = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: tilecolor,
      alignment: Alignment.bottomCenter,
      content: SizedBox(
        height: 250,
        width: vwidth,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Create Playlist',
                    style: TextStyle(fontSize: 25, color: fontcolor),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: vwidth * 0.90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: bgcolor,
                      ),
                      child: TextFormField(
                        controller: myController,
                        decoration: const InputDecoration(
                          fillColor: tilecolor,
                          border: InputBorder.none,
                          label: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              'Enter Playlist Name:',
                              style: TextStyle(fontSize: 20, color: fontcolor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: bgcolor,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.close,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 20,
                            color: fontcolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: vwidth * 0.43,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: bgcolor,
                      ),
                      child: TextButton.icon(
                        icon: const Icon(
                          Icons.done,
                          color: iconcolor,
                        ),
                        onPressed: () {
                          createplaylist(myController.text);
                          Navigator.pop(context);
                        },
                        label: const Text(
                          'Done',
                          style: TextStyle(fontSize: 20, color: fontcolor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
