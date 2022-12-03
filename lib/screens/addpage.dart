import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vgram/firebase_files/firestore_methods.dart';
import 'package:vgram/models/usermodel.dart';
import 'package:vgram/provider/user_provider.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/image.dart';

class Addpage extends StatefulWidget {
  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {
  TextEditingController _desController = TextEditingController();
  Uint8List? _file;
  bool isLoad = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _desController.dispose();
  }

  void postImage(String uid, String username, String profimage) async {
    setState(() {
      isLoad = true;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(username, _desController.text, _file!, uid, profimage);

      if (res == "Success") {
        setState(() {
          isLoad = false;
        });
        showSnackbar("Posted!", context);
        clearImage();
      } else {
        setState(() {
          isLoad = false;
        });
        showSnackbar(res, context);
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  selectImage(
    BuildContext context,
  ) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Creat Post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pikeImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Choose from gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pikeImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user _user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
            icon: Icon(
              Icons.upload,
            ),
            onPressed: () {
              selectImage(context);
            },
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobilebg,
              title: Text("Post to"),
              leading: IconButton(
                onPressed: clearImage,
                icon: Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(_user.uid, _user.username, _user.profile);
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Column(children: [
              isLoad
                  ? LinearProgressIndicator()
                  : Padding(padding: EdgeInsets.only(top: 0)),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_user.profile),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _desController,
                      decoration: InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter)),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              )
            ]),
          );
  }
}
