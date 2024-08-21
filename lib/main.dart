import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simple_waveform_progressbar/simple_waveform_progressbar.dart';
import 'dart:math' as math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeatzPro Music Player',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Roboto',
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  Duration? _duration;
  Duration? _position;
  double _sliderValue = 0;
  PlayMode playMode = AudioManager.instance.playMode;

  AnimationController? _controller;

  final list = [
    {
      "title": "Believer",
      "desc": "Jessy - Astron",
      "url": "assets/songs/believer.mp3",
      "coverUrl": "assets/images/be.jpg"
    },
    {
      "title": "Cherry Baby",
      "desc": "Cristian Tarcea - Erin Danet, Cristian Tarcea",
      "url": "assets/songs/cherry.mp3",
      "coverUrl": "assets/images/ch.jpg"
    },
    {
      "title": "Our Streets",
      "desc": "Dj Kantik",
      "url": "assets/songs/stress.mp3",
      "coverUrl": "assets/images/our.jpg"
    },
    {
      "title": "Dessert",
      "desc": "Dawin",
      "url": "assets/songs/dessert.mp3",
      "coverUrl": "assets/images/des.jpg"
    },
    {
      "title": "Lost in Love",
      "desc": "Akcent Music - Adrian Sina, Ackym, Tamy ",
      "url": "assets/songs/love.mp3",
      "coverUrl": "assets/images/lost.jpg"
    },
  ];

  @override
  void initState() {
    super.initState();
    setupAudio();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BeatzPro Music Player",
            style: TextStyle(
                fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff485563),
                Color(0xff29323c),
              ]),
        )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff485563),
                Color(0xff29323c),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(     
              height: 260.0,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
              ),
              child: playerHeader(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Playlist (${list.length})",
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.tealAccent)),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(10.0),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    list[index]['coverUrl']!,
                                    fit: BoxFit.cover,
                                    width: 50.0,
                                    height: 50.0,
                                  ),
                                ),
                                title: Text(
                                  list[index]['title']!,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  list[index]['desc']!,
                                  style: const TextStyle(
                                      fontSize: 14.0, color: Colors.grey),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.play_arrow),
                                  onPressed: () {
                                    AudioManager.instance.play(index: index);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double getAngle() {
    var value = _controller?.value ?? 0;
    return value * 2 * math.pi;
  }

  Widget playerHeader() => Column(
        children: [
          Row(
            children: [
              CircularPercentIndicator(
                  radius: 130.0,
                  percent: _sliderValue,
                  progressColor: const Color(0xff4b6584),
                  backgroundColor: Colors.grey,
                  center: AnimatedBuilder(
                    animation: _controller!,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: getAngle(),
                        child: child,
                      );
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(
                          AudioManager.instance.info?.coverUrl ??
                              "assets/images/disc.png",
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        )),
                  )),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AudioManager.instance.info?.title ?? "Song Name",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      AudioManager.instance.info?.desc ?? "Artist Name",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16.0, color: Colors.white70),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.3),
                          child: IconButton(
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                AudioManager.instance.previous();
                              }),
                        ),
                        Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xffA56169),
                                    Color(0xff83565A),
                                  ]),
                              borderRadius: BorderRadius.circular(25.0)),
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                AudioManager.instance.playOrPause();
                              },
                              padding: const EdgeInsets.all(0.0),
                              icon: Icon(
                                AudioManager.instance.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.teal.withOpacity(0.3),
                          child: IconButton(
                              icon: const Icon(
                                Icons.skip_next,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                AudioManager.instance.next();
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    _duration != null
                        ? Text(
                            _formatDuration(_duration!, _position!),
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.white70),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Center(
              child: WaveformProgressbar(
                color: Colors.grey,
                progressColor: Colors.tealAccent,
                progress: _sliderValue,
                onTap: (progress) {
                  setState(() {
                    final newPosition =
                        Duration(seconds: (_duration!.inSeconds * progress).round());
                    AudioManager.instance.seekTo(newPosition);
                    _sliderValue = progress;
                  });
                },
              ),
            ),
          ),
        ],
      );

  String _formatDuration(Duration ds, Duration p) {
    if (ds == null || p == null) return "--:--";
    var d = ds - p;
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    _sliderValue = (p.inSeconds / ds.inSeconds);
    return "Time Left: $format";
  }

  void setupAudio() {
    List<AudioInfo> _list = [];
    list.forEach((item) => _list.add(AudioInfo(item["url"]!,
        title: item["title"]!,
        desc: item["desc"]!,
        coverUrl: item["coverUrl"]!)));

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: true);

    AudioManager.instance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          break;
        case AudioManagerEvents.ready:
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          setState(() {});
          break;
        case AudioManagerEvents.buffering:
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          setState(() {});
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          setState(() {});
          break;
        default:
          break;
      }
    });
  }
}
