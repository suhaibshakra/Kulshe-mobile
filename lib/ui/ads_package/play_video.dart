import 'package:flutter/material.dart';
import 'package:kulshe/app_helpers/app_colors.dart';
import 'package:kulshe/app_helpers/app_widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayVideoScreen extends StatefulWidget {
  final String videoUrl;

  const PlayVideoScreen({Key key, this.videoUrl}) : super(key: key);

  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  YoutubePlayerController _videoController;

  void _runYoutubePlayer() {
    _videoController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl),
        flags: YoutubePlayerFlags(
          enableCaption: false,
          isLive: false,
          autoPlay: true,
        ));
  }

  @override
  void initState() {
    _runYoutubePlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _videoController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _videoController,
      ),
      builder: (context, player) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              color: AppColors.blackColor,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        player,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: buildIconButton(
                          color: AppColors.whiteColor,
                          icon: Icons.close,
                          onPressed: (){Navigator.of(context).pop();
                          },
                          size: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
