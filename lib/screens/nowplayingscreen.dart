import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:resfy_music/db/models/songmodel.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

// ignore: must_be_immutable
class NowPlayingScreen extends StatefulWidget {
  NowPlayingScreen({super.key});

  List<Songs>? songs;
  static int? indexvalue = 0;
  static ValueNotifier<int> nowplayingindex = ValueNotifier<int>(indexvalue!);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

final player = AssetsAudioPlayer.withId('0');

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final box = SongBox.getInstance();

  @override
  Widget build(BuildContext context) {
    double vertwidth = MediaQuery.of(context).size.width;
    double vertheight = MediaQuery.of(context).size.height;
    Duration duration = Duration.zero;
    Duration position = Duration.zero;

    return SafeArea(
        child: Scaffold(
      backgroundColor: bgcolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.expand_more,
                          color: iconcolor,
                          size: 35,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: vertwidth * 0.17),
                  child: const Text(
                    'Now Playing',
                    style: TextStyle(fontSize: 18, color: fontcolor),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder(
                valueListenable: NowPlayingScreen.nowplayingindex,
                builder: (BuildContext context, int value1, child) {
                  return ValueListenableBuilder<Box<Songs>>(
                      valueListenable: box.listenable(),
                      builder: ((context, Box<Songs> allsongbox, child) {
                        List<Songs> allDbdongs = allsongbox.values.toList();
                        if (allDbdongs.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return player.builderCurrent(
                            builder: ((context, playing) {
                          return Column(
                            children: [
                              QueryArtworkWidget(
                                artworkQuality: FilterQuality.high,
                                artworkHeight: vertheight * 0.34,
                                artworkWidth: vertheight * 0.34,
                                artworkBorder: BorderRadius.circular(10),
                                artworkFit: BoxFit.cover,
                                id: allDbdongs[value1].id!,
                                type: ArtworkType.AUDIO,
                              ),
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 12.0),
                                        // ignore: sized_box_for_whitespace
                                        child: Container(
                                          width: 300,
                                          child: Text(
                                            allDbdongs[value1].songname!,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18, color: fontcolor),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  PlayerBuilder.realtimePlayingInfos(
                                    player: player,
                                    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                                    builder: (context, RealtimePlayingInfos) {
                                      duration = RealtimePlayingInfos
                                          .current!.audio.duration;
                                      position =
                                          RealtimePlayingInfos.currentPosition;

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: ProgressBar(
                                          baseBarColor:
                                              Colors.white.withOpacity(0.5),
                                          progressBarColor:
                                              const Color.fromARGB(
                                                  255, 89, 4, 173),
                                          thumbColor: const Color.fromARGB(
                                              255, 24, 14, 14),
                                          thumbRadius: 5,
                                          timeLabelPadding: 5,
                                          progress: position,
                                          timeLabelTextStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          total: duration,
                                          onSeek: (duration) async {
                                            await player.seek(duration);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  PlayerBuilder.isPlaying(
                                    player: player,
                                    builder: ((context, isPlaying) {
                                      return Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.shuffle,
                                                  color: iconcolor,
                                                )),
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: IconButton(
                                                onPressed: () {
                                                  previousMusic(player, value1,
                                                      allDbdongs);
                                                },
                                                icon: const Icon(
                                                  Icons.skip_previous,
                                                  color: iconcolor,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: appbarcolor,
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  if (isPlaying) {
                                                    player.pause();
                                                  } else {
                                                    player.play();
                                                  }
                                                  setState(
                                                    () {
                                                      isPlaying = !isPlaying;
                                                    },
                                                  );
                                                },
                                                icon: (isPlaying)
                                                    ? const Icon(Icons.pause)
                                                    : const Icon(
                                                        Icons.play_arrow,
                                                        color: iconcolor,
                                                        size: 35,
                                                      ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: IconButton(
                                                onPressed: () {
                                                  skipMusic(player, value1,
                                                      allDbdongs);
                                                  setState(() {});
                                                },
                                                icon: const Icon(
                                                  Icons.skip_next,
                                                  color: iconcolor,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.repeat,
                                                color: iconcolor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              )
                            ],
                          );
                        }));
                      }));
                })
          ],
        ),
      ),
    ));
  }

  void skipMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.open(
      Audio.file(dbsongs[index + 1].songurl!),
      showNotification: true,
    );
    // await _audioPlayer.next();
    setState(() {
      NowPlayingScreen.nowplayingindex.value++;
      NowPlayingSlider.enteredvalue.value++;
    });
    await player.stop();
  }

  void previousMusic(AssetsAudioPlayer assetsAudioPlayer, int index,
      List<Songs> dbsongs) async {
    player.open(
      Audio.file(dbsongs[index - 1].songurl!),
      showNotification: true,
    );
    // await _audioPlayer.next();
    setState(() {
      NowPlayingScreen.nowplayingindex.value--;
      NowPlayingSlider.enteredvalue.value--;
    });
    await player.stop();
  }
}
