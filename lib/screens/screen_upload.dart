import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialnetwork_flutter/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import '../pages/home_page.dart';
import 'package:flutter/services.dart';

class ScreenUpload extends StatefulWidget {

  ScreenUpload({Key key}) : super(key: key);


  @override
  _ScreenUploadState createState() => _ScreenUploadState();
}

class _ScreenUploadState<User> extends State<ScreenUpload> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  PickedFile file;
  File compressedFile;
  bool isUploading = false;
  String postId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }

  buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage,
          ),
        title: Text("Caption Post", style: TextStyle(color: Colors.black)),
        actions:[
          TextButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text("Post", style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
          )
        ]
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(file.path)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(currentUser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.pin_drop, color: Colors.orange, size: 35.0,),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: "Where was the photo taken?",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 200.0,
            height: 100.0,
            alignment: Alignment.center,
            child: ElevatedButton.icon(
                onPressed: getUserLocation,
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
                label: Text("Use Current Location",
                  style: TextStyle(color: Colors.white),
                )
            )
          )
        ],
      ),
    );
  }

  Future<Position> getUserLocation() async{
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //TODO: current location
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset("assets/images/upload.svg", height: 260.0,),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child:  ElevatedButton(
            child: Text('Upload Image'),
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.grey,
            ),
            onPressed: () => selectImage(context),
          )
        )
      ],)

    );
  }

  selectImage(parentContext){
    return showDialog(
        context: parentContext,
        builder: (context){
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Photo with Camera"),
                onPressed: handleTakePhoto,
              ),
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: handleChooseFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        }
    );
  }

  handleTakePhoto() async{
    Navigator.pop(context);

    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 675,
      maxHeight: 960,
    );
    setState(() {
      this.file = pickedFile;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);

    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      this.file = pickedFile;
    });
  }


  void clearImage() {
    setState(() {
      file = null;
    });
  }

  compressImage() async{
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(File(file.path).readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(
        Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      compressedFile = compressedImageFile;
    });
  }

  handleSubmit() async{
    print(isUploading);
    print(file.toString());
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(compressedFile);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      location: locationController.text,
      description: captionController.text
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      compressedFile = null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Future<String> uploadImage(File compressedFile) async{
    Reference ref = storageRef.child("post_$postId.jpg");
    await ref.putFile(compressedFile);
    String url = await ref.getDownloadURL();
    return url;
  }

  void createPostInFirestore({String mediaUrl, String location, String description}) {
    postsRef
        .doc(current_uid)
        .collection("userPosts")
        .doc(postId)
        .set({
          "postId": postId,
          "ownerId": current_uid,
          "username": currentUser.username,
          "description": description,
          "mediaUrl": mediaUrl,
          "location": location,
          "timestamp": timestamp,
          "likes": {},
        });
  }
}