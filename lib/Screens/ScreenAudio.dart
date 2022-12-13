import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:islamiapp/Models/Sura.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:volume_controller/volume_controller.dart';

class ScreenAudio extends StatefulWidget {
  ScreenAudio({
    Key? key,required this.id,required this.reciterName,required this.audioUrl,required this.suratName,required this.baseUrl
  }) : super(key: key);

  final String reciterName,audioUrl,suratName,baseUrl;
  int id;

  @override
  State<ScreenAudio> createState() => _ScreenAudioState();
}
class PositionData {
  PositionData({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

class _ScreenAudioState extends State<ScreenAudio> {
  AppProvider ?appProvider;
  AudioPlayer audioPlayer = AudioPlayer();

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,(position, bufferedPosition, duration) => PositionData(current: position, buffered: bufferedPosition,total: duration ?? Duration.zero));

  double _setVolumeValue = 0;
  @override
  void initState() {
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
    appProvider = Provider.of<AppProvider>(context, listen: false)..makePlaylist(widget.baseUrl);
    super.initState();
    audioPlayer.setAudioSource(appProvider!.playlist!);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    audioPlayer.dispose();
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
            const SizedBox(height: 50,),
            Text(widget.reciterName,style: const TextStyle(
                color: Colors.white,fontSize: 25
            ),textDirection: TextDirection.rtl),
            StreamBuilder(
              stream: audioPlayer.currentIndexStream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  if(appProvider!.wantRepeat){
                    audioPlayer.seekToPrevious();
                  }
                  Sura currentSura = appProvider!.suwar!.where((element) => element.id==snapshot.data!+1).toList()[0];
                  return Text(currentSura.name!,style: const TextStyle(
                      color: Colors.white,fontSize: 20
                  ),textDirection: TextDirection.rtl);
                }
                else{
                  return const Center(child: CircularProgressIndicator(color: Colors.white),);
                }

            },),
            const SizedBox(height: 20,),
            StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state =snapshot.data;
                if(state?.sequence.isEmpty??true){
                  return const SizedBox();
                }
                return SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Image border
                    child: Image.network("https://www.fekera.com/wp-content/uploads/2019/11/%D8%AA%D9%81%D8%B3%D9%8A%D8%B1-%D8%AD%D9%84%D9%85-%D8%B1%D8%A4%D9%8A%D8%A9-%D8%A7%D9%84%D9%85%D8%B5%D8%AD%D9%81.jpg", fit: BoxFit.cover),
                  ),
                );
            },),
            const SizedBox(height: 10,),
            SliderTheme(
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
            ),
            const SizedBox(height: 10,),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  final positionData =snapshot.data;
                  return ProgressBar(
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
                    onSeek: audioPlayer.seek,
                  );
                }
                else{
                  return const Center(child: CircularProgressIndicator(color: Colors.white),);
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: () {
                  audioPlayer.seekToPrevious();
                }, icon: const Icon(Icons.skip_previous_outlined,color: Colors.white,)),
                StreamBuilder<PlayerState>(
                  stream: audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState =audioPlayer.playerState;
                    final progressingState =playerState.processingState;
                    final playing =playerState.playing;
                    if(!(playing)){
                      return IconButton(onPressed: () {
                        audioPlayer.play();
                      }, icon: const Icon(Icons.play_arrow,color: Colors.white,));
                    }
                    else if(progressingState!=ProcessingState.completed){
                      return IconButton(onPressed: () {
                        audioPlayer.pause();
                      }, icon: const Icon(Icons.pause,color: Colors.white,));
                    }
                    return IconButton(onPressed: () {
                      audioPlayer.play();
                    }, icon: const Icon(Icons.play_arrow,color: Colors.white,)
                    );
                },),
                IconButton(
                  icon: Icon(Icons.repeat,color: context.watch<AppProvider>().wantRepeat?Colors.red:Colors.white),
                  iconSize: 32.0,
                  onPressed: () {
                    context.read<AppProvider>().setWantRepeat();
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
            )
          ],
        ),
      ),
    );
  }
}