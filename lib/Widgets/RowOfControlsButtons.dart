import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../Logic/AppProvider.dart';

class RowOfControlsButtons extends StatelessWidget {
  const RowOfControlsButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(onPressed: () {
          audioPlayer.seekToPrevious();
        }, icon: const Icon(Icons.skip_previous_outlined,color: Colors.white,size: 32,)),

        IconButton(
          icon: Icon(Icons.repeat,color: context.watch<AppProvider>().wantRepeat?Colors.red:Colors.white),
          iconSize: 32.0,
          onPressed: () {
            context.read<AppProvider>().setWantRepeat();
          },
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final playerState =audioPlayer.playerState;
              final progressingState =playerState.processingState;
              final playing =playerState.playing;
              if(!(playing)){
                return IconButton(onPressed: () {
                  audioPlayer.play();
                }, icon: const Icon(Icons.play_arrow,color: Colors.white,size: 32,));
              }
              else if(progressingState!=ProcessingState.completed){
                return IconButton(onPressed: () {
                  audioPlayer.pause();
                }, icon: const Icon(Icons.pause,color: Colors.white,size: 32,));
              }
                return IconButton(onPressed: () {
                audioPlayer.play();
              }, icon: const Icon(Icons.play_arrow,color: Colors.white,size: 32,)
              );
            }
            else{
              return const Center(child: CircularProgressIndicator(color: Colors.white),);
            }

          },),
        IconButton(
          icon: Icon(Icons.shuffle,color: context.watch<AppProvider>().wantShuffle?Colors.red:Colors.white,size: 32,),
          iconSize: 32.0,
          onPressed: () {
            context.read<AppProvider>().setWantShuffle();
            audioPlayer.setShuffleModeEnabled(context.read<AppProvider>().wantShuffle);
          },
        ),
        IconButton(
          icon: const Icon(Icons.skip_next_outlined,color: Colors.white),
          iconSize: 32.0,
          onPressed: () {
            audioPlayer.seekToNext();
          },
        ),
      ],
    );
  }
}