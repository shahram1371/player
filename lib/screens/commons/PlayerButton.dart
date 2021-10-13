// ignore_for_file: file_names, sized_box_for_whitespace, unrelated_type_equality_checks
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class PlayerButton extends StatelessWidget {
  final AudioPlayer _audioPlayer;
  const PlayerButton(this._audioPlayer, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: ProgressBar(
            progress: Duration.zero,
            total: Duration.zero,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<bool>(
              stream: _audioPlayer.shuffleModeEnabledStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return _shuffleButton(context, snapshot.data ?? false);
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _previousButton();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data;
                return _playPauseButton(playerState);
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _nextButton();
              },
            ),
            StreamBuilder<LoopMode>(
                stream: _audioPlayer.loopModeStream,
                builder: (context, snapshot) {
                  return _repeatButton(context, snapshot.data ?? LoopMode.off);
                }),
          ],
        ),
      ],
    );
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
        onPressed: () async {
          final enable = !isEnabled;
          if (enable) {
            await _audioPlayer.shuffle();
          }
          await _audioPlayer.setShuffleModeEnabled(enable);
        },
        icon: isEnabled
            ? Icon(Icons.shuffle,
                color: Theme.of(context).colorScheme.secondary)
            : const Icon(Icons.shuffle));
  }

  Widget _previousButton() {
    return IconButton(
      icon: const Icon(Icons.skip_previous),
      onPressed: _audioPlayer.hasPrevious ? _audioPlayer.seekToPrevious : null,
    );
  }

  Widget _playPauseButton(PlayerState? playerState) {
    final processingState = playerState?.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        width: 30,
        height: 30,
        child: const CircularProgressIndicator(),
      );
    } else if (_audioPlayer.playing != true) {
      return IconButton(
        onPressed: _audioPlayer.play,
        icon: const Icon(
          Icons.play_arrow,
        ),
        // iconSize: 64.0,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        onPressed: _audioPlayer.pause,
        icon: const Icon(Icons.pause),
        // iconSize: 64.0,
      );
    } else {
      return IconButton(
        onPressed: () {
          _audioPlayer.seek(Duration.zero,
              index: _audioPlayer.effectiveIndices?.first);
        },
        icon: const Icon(Icons.reply),
        // iconSize: 64.0,
      );
    }
  }

  Widget _nextButton() {
    return IconButton(
      icon: const Icon(Icons.skip_next),
      onPressed: _audioPlayer.hasNext ? _audioPlayer.seekToNext : null,
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      const Icon(Icons.repeat),
      Icon(Icons.repeat, color: Theme.of(context).colorScheme.secondary),
      Icon(Icons.repeat_one, color: Theme.of(context).colorScheme.secondary),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        _audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }
}
