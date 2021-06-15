import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import 'package:video_player/video_player.dart';
import '../components.dart';

class EditNote extends StatefulWidget {
  String? title;
  String? des;
  String? id;
  final bool isTrash;
  final bool hasVideo;
  final String? videoLink;
  // final bool hasVideo;
  EditNote({required this.title, required this.des, required this.id, required this.isTrash, required this.hasVideo, this.videoLink});

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

 late VideoPlayerController _controller;
 late Future<void> _initializeVideoPlayerFuture;

  void initState() {
    _controller = VideoPlayerController.network(
        widget.hasVideo? widget.videoLink! : '');
    //_controller = VideoPlayerController.asset("videos/sample_video.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
   


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FirebaseBloc>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Visibility(
                visible: widget.hasVideo,
                              child: Column(
                  children: [
                    
                FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(),
            );
          }
        },
      ),
      SizedBox(
        height: 10,
      ),
      ElevatedButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
                _controller.pause();
            } else {
                _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
      SizedBox(
        height: 50,
      ),
                  ],
                ),
              ),


              Column(
                children: [
                TextFormField(
                readOnly: widget.isTrash,
                onTap: ()
                {
                  if(widget.isTrash)
                    ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Cannot edit trash note'));
                },
                initialValue: widget.title,
                onChanged: (value) {
                  widget.title = value;
                },
                maxLength: 30,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                readOnly: widget.isTrash,
                onTap: ()
                {
                  if(widget.isTrash)
                    ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Cannot edit trash note'));
                },
                initialValue: widget.des,
                onChanged: (value) {
                  widget.des = value;
                },
                minLines: 1,
                maxLines: 2,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print(widget.title);
                      if (widget.title != '' && widget.title != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Saved!'));
                        bloc.add(
                            UpdateNoteEvent(id: widget.id!, title: widget.title!, des: widget.des!));
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar('Title cannot be null'));
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            

              ],),
              ],
          ),
        ),
      ),
    );
  }
}
