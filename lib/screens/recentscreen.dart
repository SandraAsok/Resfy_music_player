import 'package:flutter/material.dart';

import 'package:resfy_music/widgets/appbarwidget.dart';

class Recent extends StatelessWidget {
  const Recent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        createAppBar('Recently Played'),
      ],
    );
  }
}
