import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class Card_2 extends StatefulWidget {
  final DocumentSnapshot videoname;

  const Card_2({super.key, required this.videoname});

  @override
  State<Card_2> createState() => _Card_2State();
}

class _Card_2State extends State<Card_2> {
  late VideoPlayerController _controller;

  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoname['video_url'])
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
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
              )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          }),
    );
  }

  Widget VideoPlayer_list() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.6,
        width: MediaQuery.of(context).size.width / 1.5,
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Container(),
      ),
    );
  }
}
