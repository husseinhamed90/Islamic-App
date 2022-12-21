import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:islamiapp/Models/Sura.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:volume_controller/volume_controller.dart';
import '../Helpers/HelperClasses/PositionData.dart';
import '../Widgets/RowOfControlsButtons.dart';

class ScreenAudio extends StatefulWidget {
  const ScreenAudio({
    Key? key,required this.id,required this.reciterName,required this.audioUrl,required this.suratName,required this.baseUrl
  }) : super(key: key);

  final String reciterName,audioUrl,suratName,baseUrl;
  final int id;

  @override
  State<ScreenAudio> createState() => _ScreenAudioState();
}


class _ScreenAudioState extends State<ScreenAudio> {
  late AppProvider appProvider;
  double _setVolumeValue = 0;
  @override
  void initState() {
    VolumeController().listener((currentVolume) {
      setState(() {
        _setVolumeValue = currentVolume;
      });
    });
    appProvider = Provider.of<AppProvider>(context, listen: false)..makePlaylist(widget.baseUrl);
    if(!appProvider.isAudioChanged&&!appProvider.isReciterChanged){
      if(appProvider.audioPlayer.playing){
        appProvider.audioPlayer.setAudioSource(appProvider.playlist!,initialIndex: widget.id-1,initialPosition: appProvider.currentAudioSeek);
      }
      else{
        appProvider.audioPlayer.setAudioSource(appProvider.playlist!,initialIndex: widget.id-1,initialPosition: appProvider.currentAudioSeek);
        appProvider.audioPlayer.setShuffleModeEnabled(context.read<AppProvider>().wantShuffle);
      }
    }
    else{
      appProvider.resetSeek();
      appProvider.audioPlayer.setAudioSource(appProvider.playlist!,initialIndex: widget.id-1,initialPosition: appProvider.currentAudioSeek);
      appProvider.audioPlayer.setShuffleModeEnabled(context.read<AppProvider>().wantShuffle);
    }
    getCurrentDuration();
    appProvider.audioPlayer.play();
    super.initState();

  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 25,),
            const Text("Volume",style: TextStyle(
                color: Colors.white,fontSize: 20
            ),textDirection: TextDirection.rtl,textAlign: TextAlign.center),
            buildVolumeSlider(),
            Text(widget.reciterName,style: const TextStyle(
                color: Colors.white,fontSize: 25
            ),textDirection: TextDirection.rtl),
            buildStreamOfCurrentSuraName(),
            buildStreamOfPlaylistTags(),
            const SizedBox(height: 25,),
            buildStreamOfSeekPosition(),
            RowOfControlsButtons(audioPlayer: appProvider.audioPlayer),
            const SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }

  StreamSubscription<Duration> getCurrentDuration(){
    return appProvider.audioPlayer.positionStream.listen((event) {
      appProvider.currentAudioSeek=event;
    });
  }

  Stream<PositionData> _positionDataStream(){
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        appProvider.audioPlayer.positionStream,
        appProvider.audioPlayer.bufferedPositionStream,
        appProvider.audioPlayer.durationStream,(position, bufferedPosition, duration) => PositionData(current: position, buffered: bufferedPosition,total: duration ?? Duration.zero));
  }

  StreamBuilder<int?> buildStreamOfCurrentSuraName() {
    return StreamBuilder(
           stream: context.read<AppProvider>().getCurrentPosition() ,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                // print("ccccccccccccccccccccccccccccccc");
                // print(snapshot.data!);
                // context.read<AppProvider>().setCurrentSuraIndex(snapshot.data!);
                if(appProvider.wantRepeat){
                  appProvider.audioPlayer.seekToPrevious();
                }
                Sura currentSura = appProvider.suwar!.where((element) => element.id==snapshot.data!+1).toList()[0];
                return Text(currentSura.name!,style: const TextStyle(
                    color: Colors.white,fontSize: 20
                ),textDirection: TextDirection.rtl);
              }
              else{
                return const Center(child: CircularProgressIndicator(color: Colors.white),);
              }
          },
    );
  }

  StreamBuilder<SequenceState?> buildStreamOfPlaylistTags() {
    return StreamBuilder<SequenceState?>(
            stream: appProvider.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                final state =snapshot.data;
                if(state?.sequence.isEmpty??true){
                  return const SizedBox();
                }
                return SizedBox(
                  width: double.infinity-50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Image border
                    child: Image.network("https://images.akhbarelyom.com//images/images/medium/20201031140317535.jpg", fit: BoxFit.cover),
                  ),
                );
              }
              else{
                return const Center(child: CircularProgressIndicator(color: Colors.white),);
              }
          },
    );
  }

  SliderTheme buildVolumeSlider() {
    return SliderTheme(
            data: const SliderThemeData(
              activeTrackColor: Colors.red,
              inactiveTrackColor: Colors.white,
              disabledActiveTrackColor: Colors.white,
              trackHeight: 2,
              thumbColor: Colors.white,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
            ),
            child: Slider(
              min: 0,
              max: 1,
              value: _setVolumeValue,
              onChanged: (value) {
                _setVolumeValue = value;
                VolumeController().setVolume(_setVolumeValue);
                setState(() {});
              },
            ),
          );
  }

  OrientationBuilder buildStreamOfSeekPosition() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return StreamBuilder<PositionData>(
          stream: _positionDataStream().asBroadcastStream(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              final positionData =snapshot.data;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ProgressBar(
                  thumbColor: Colors.white,
                  timeLabelTextStyle: const TextStyle(
                      color: Colors.white
                  ),
                  barHeight: 2,
                  baseBarColor: Colors.white,
                  bufferedBarColor: Colors.white,
                  progressBarColor: Colors.red,
                  progress: positionData?.current??Duration.zero,
                  buffered: positionData?.buffered??Duration.zero,
                  total: positionData?.total??Duration.zero,
                  onSeek: appProvider.audioPlayer.seek
                ),
              );
            }
            else{
              return const Center(child: CircularProgressIndicator(color: Colors.white),);
            }
          },
        );
      },
    );
  }
}

