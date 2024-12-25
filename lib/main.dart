import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MaterialApp(home: MusicPlayerScreen()));
}

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  // Create an AudioPlayer instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variable to track the current playing state
  bool isPlaying = false;

  // Variables to store current and total song duration
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen to the audio state changes
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  // Function to play the audio
  Future<void> playAudio() async {
    await _audioPlayer.setSource(AssetSource('assets/RojaPonthottam.mp3'));
    await _audioPlayer.resume();
  }

  // Function to pause the audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  // Function to stop the audio
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Now Playing'),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Replacing image with an Icon
          Container(
            margin: const EdgeInsets.all(16),
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[800],  // Background color for the container
            ),
            child: const Icon(
              Icons.music_note,  // Icon for album art
              size: 100,
              color: Colors.white,
            ),
          ),
          // Song Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Roja Ponthottam',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'A. R. Rahman',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Music Progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Slider(
                  // Update the slider value based on currentPosition
                  value: currentPosition.inSeconds.toDouble(),
                  // Set the maximum value of the slider to the totalDuration
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(currentPosition),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      _formatDuration(totalDuration),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                iconSize: 40,
                onPressed: () {
                  // Logic for previous track
                },
              ),
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                  color: Colors.white,
                ),
                iconSize: 60,
                onPressed: () {
                  if (isPlaying) {
                    pauseAudio();
                  } else {
                    playAudio();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                iconSize: 40,
                onPressed: () {
                  // Logic for next track
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Up Next Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Up Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(
                          leading: Icon(Icons.music_note, color: Colors.white),
                          title: Text(
                            "I'm Fine",
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Ashe',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            '2:16',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.music_note, color: Colors.white),
                          title: Text(
                            'Drown',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Dabin',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            '4:19',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to format duration in minutes:seconds
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
