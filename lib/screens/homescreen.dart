import 'package:flutter/material.dart';
import 'package:resfy_music/db/functions/colors.dart';
import 'package:resfy_music/navbar.dart';
import 'package:resfy_music/screens/libraryscreen.dart';
import 'package:resfy_music/screens/searchscreen.dart';
import 'package:resfy_music/widgets/allsongswidget.dart';
import 'package:resfy_music/widgets/nowplayingslider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgcolor,
        drawer: const NavBar(),
        appBar: AppBar(
          backgroundColor: appbarcolor,
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.music_note_outlined), text: 'All Songs'),
            Tab(icon: Icon(Icons.playlist_play), text: 'Playlist'),
          ]),
          title: const Text(
            'Resfy Music',
            style: TextStyle(fontStyle: FontStyle.italic, color: fontcolor),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const SearchScreen())));
                },
                icon: const Icon(
                  Icons.search,
                  size: 25,
                  color: iconcolor,
                ))
          ],
        ),
        body: const TabBarView(children: [AllSongsWidget(), LibraryScreen()]),
        bottomSheet: const NowPlayingSlider(),
      ),
    );
  }
}
