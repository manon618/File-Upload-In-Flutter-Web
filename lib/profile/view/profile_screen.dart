import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:file_upload_web/profile/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<PlatformFile>? _paths;
  final formKey = GlobalKey<FormState>();

  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      log('Unsupported operation' + e.toString());
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      if (_paths != null) {
        if (_paths != null) {
          //passing file bytes and file name for API call
          ApiClient.uploadFile(_paths!.first.bytes!, _paths!.first.name);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'eiMaths',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              Text(
                'Study Time Tracking',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              )
            ],
          ),
          leading: const Padding(
            padding: EdgeInsets.all(7.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
          actions: const <Widget>[Icon(Icons.more_vert)],
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /* buildCentre(),
                    const SizedBox(height: 16),
                    buildStudent(),
                    const SizedBox(height: 16),
                    buildSubject(),
                    const SizedBox(height: 16),
                    buildTerm(),
                    const SizedBox(height: 16),
                    buildBook(),
                    const SizedBox(height: 16),
                    buildDate(),
                    const SizedBox(height: 16),
                    buildTime(),
                    const SizedBox(height: 16),
                    /* buildHour(),
                    const SizedBox(height: 16), */
                    buildeTime(),
                    const SizedBox(height: 16),
                    buildTextArea(),
                    const SizedBox(height: 16),
                    buildCamera(context),
                    const SizedBox(height: 16),
                    buildsignpad(),
                    const SizedBox(height: 16),
                    buildClear(context),
                    const SizedBox(height: 12),
                    buildSubmit(context) */
                    buildPhoto(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildPhoto(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade200,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(
                  20.00,
                ),
                bottomRight: Radius.circular(
                  20.00,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 132.00,
                  width: 327.00,
                  margin: const EdgeInsets.only(
                    left: 10.00,
                    top: 24.00,
                    right: 10.00,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _paths != null
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100.00,
                                width: 100.00,
                                margin: const EdgeInsets.only(
                                  left: 113.00,
                                  top: 10.00,
                                  right: 113.00,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      50.00,
                                    ),
                                    image: DecorationImage(
                                        image:
                                            MemoryImage(_paths!.first.bytes!))),
                              ),
                            )
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 100.00,
                                width: 100.00,
                                margin: const EdgeInsets.only(
                                  left: 113.00,
                                  top: 10.00,
                                  right: 113.00,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(
                                      50.00,
                                    ),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/image_not_found.png'))),
                              ),
                            ),
                      InkWell(
                        onTap: pickFiles,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 30.00,
                            width: 30.00,
                            margin: const EdgeInsets.only(
                              left: 183.00,
                              top: 10.00,
                              right: 113.00,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(
                                5.00,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.00,
                    top: 16.00,
                    right: 10.00,
                  ),
                  child: Text(
                    "Noah Arielken",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 20,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.00,
                    top: 8.00,
                    right: 10.00,
                    bottom: 48.00,
                  ),
                  child: Text(
                    "Visual Communication Design",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade50,
                      fontSize: 14,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
