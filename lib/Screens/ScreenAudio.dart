import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import '../Logic/AudioController.dart';

class ScreenAudio extends StatefulWidget {
  const ScreenAudio({
    Key? key,required this.reciterName,required this.audioUrl,required this.suratName
  }) : super(key: key);

  final String reciterName,audioUrl,suratName;

  @override
  State<ScreenAudio> createState() => _ScreenAudioState();
}

class _ScreenAudioState extends State<ScreenAudio> {

  late final AudioController _pageManager;
  @override
  void initState() {
    super.initState();
    _pageManager = AudioController(url: widget.audioUrl);
  }

  @override
  void dispose() {
    _pageManager.dispose();
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
            Text(widget.suratName,style: const TextStyle(
                color: Colors.white,fontSize: 20
            ),textDirection: TextDirection.rtl),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Image border
                child: Image.network("https://www.fekera.com/wp-content/uploads/2019/11/%D8%AA%D9%81%D8%B3%D9%8A%D8%B1-%D8%AD%D9%84%D9%85-%D8%B1%D8%A4%D9%8A%D8%A9-%D8%A7%D9%84%D9%85%D8%B5%D8%AD%D9%81.jpg", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 50,),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  barHeight: 2,
                  bufferedBarColor: Colors.white,
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  thumbColor: Colors.white,
                  progressBarColor: Colors.red,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white
                  ),
                  onSeek: _pageManager.seek,
                );
              },
            ),

            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: const Center(child: CircularProgressIndicator(color: Colors.white,)),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: const Icon(Icons.play_arrow,color: Colors.white),
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: const Icon(Icons.pause,color: Colors.white),
                      iconSize: 32.0,
                      onPressed: () {
                        _pageManager.pause();
                      },
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}