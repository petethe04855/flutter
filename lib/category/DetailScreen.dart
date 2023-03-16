import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:video_player/video_player.dart';

class DetailScreen extends StatefulWidget {
  final DocumentSnapshot videoname;
  const DetailScreen({super.key, required this.videoname});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late VideoPlayerController _controllerVide;

  void initState() {
    super.initState();
    _controllerVide =
        VideoPlayerController.network(widget.videoname['video_url'])
          ..initialize().then((_) {
            setState(() {});
          });
  }

  void dispose() {
    super.dispose();
    _controllerVide.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoname['NameVideo']),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(widget.videoname['NameVideo'],
                  style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: VideoPlayer_list(),
              ),
              Card(
                child: Container(
                  child: ListTile(
                    subtitle: Text(
                      widget.videoname['description'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
              _controllerVide.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              _controllerVide.value.isPlaying
                  ? _controllerVide.pause()
                  : _controllerVide.play();
            });
          }),
    );
  }

  Widget VideoPlayer_list() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width / 1.5,
        child: _controllerVide.value.isInitialized
            ? VideoPlayer(_controllerVide)
            : Container(
                child: Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
