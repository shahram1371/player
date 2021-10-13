// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'commons/PlayerButton.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  // ignore: unused_field
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
//http://eslamdl.parsaspace.com/%D8%B5%D9%88%D8%AA%DB%8C/%D8%AA%D9%88%D8%A7%D8%B4%DB%8C%D8%AD/%D9%85%D8%B4%D8%A7%D8%B1%DB%8C%20%D8%A7%D9%84%D8%B9%D9%81%D8%A7%D8%B3%DB%8C/%D8%A3%D8%B1%DB%8C%20%D8%A7%D9%84%D8%AF%D9%86%DB%8C%D8%A7.mp3
    // _audioPlayer.pause();
    _audioPlayer
        .setAudioSource(ConcatenatingAudioSource(children: [
      AudioSource.uri(Uri.parse(
          "https://dlw.webahang.ir/music/Track/Sedaye.Baran(3).mp3?_=3")),
      AudioSource.uri(Uri.parse(
          "https://dlw.webahang.ir/music/Track/Sedaye.Baran(10).mp3?_=10")),
      AudioSource.uri(Uri.parse(
          "https://dlw.webahang.ir/music/Track/Sedaye.Baran(12).mp3?_=12")),
    ]))
        .catchError((error) {
      print("An error occured $error");
    });
    @override
    void dispose() {
      _audioPlayer.dispose();
      super.dispose();
    }
  }

  // Widget _playerButton(PlayerState? playerState) {
  //   final processingState = playerState?.processingState;
  //   if (processingState == ProcessingState.loading ||
  //       processingState == ProcessingState.buffering) {
  //     return Container(
  //       margin: const EdgeInsets.all(8.0),
  //       width: 64.0,
  //       height: 64.0,
  //       child: const CircularProgressIndicator(),
  //     );
  //   } else if (_audioPlayer.playing != true) {
  //     return IconButton(
  //       icon: const Icon(Icons.play_arrow),
  //       iconSize: 64,
  //       onPressed: _audioPlayer.play,
  //     );
  //   } else if (processingState != ProcessingState.completed) {
  //     return IconButton(
  //       icon: const Icon(Icons.pause),
  //       iconSize: 64,
  //       onPressed: _audioPlayer.pause,
  //     );
  //   } else {
  //     // 5
  //     return IconButton(
  //       icon: const Icon(Icons.replay),
  //       iconSize: 64.0,
  //       onPressed: () => _audioPlayer.seek(Duration.zero,
  //           index: _audioPlayer.effectiveIndices?.first),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: PlayerButton(_audioPlayer),
      ),
    );
  }
}
