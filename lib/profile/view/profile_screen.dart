import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:file_upload_web/api/centre_api.dart';
import 'package:file_upload_web/api/term_data.dart';
import 'package:file_upload_web/profile/network/network.dart';
import 'package:file_upload_web/api/user_api.dart';
import 'package:file_upload_web/api/subject_data.dart';
import 'package:file_upload_web/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:async';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  final formKey = GlobalKey<FormState>();
  final controllerCentre = TextEditingController();
  final controllerStudent = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerTerm = TextEditingController();
  final controllerBook = TextEditingController();
  final dateinput = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final timeinput =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  final timeinpute =
      TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
  final textAreaController = TextEditingController();
  final hourinput = TextEditingController();
  final _timeFormat = DateFormat('HH:mm:ss');

  List<String> _images = [];

  String? selectedCentre;
  String? selectedCentreth;
  String? selectedStudent;
  String? selectedStudenth;
  String? selectedSubject;
  String? selectedSubjecth;
  String? selectedTerm;
  String? selectedTermh;
  String? selectedBook;
  String? selectedBookh;
  String? signed;
  String? datep;
  String? timep;
  String? timepe;
  String? comments;
  String? selectedValue;
  bool isPostingData = false;
  bool _isFileSelecting = false;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("1")),
      const DropdownMenuItem(value: "2", child: Text("2")),
      const DropdownMenuItem(value: "3", child: Text("3")),
      const DropdownMenuItem(value: "4", child: Text("4")),
    ];
    return menuItems;
  }

  List<PlatformFile>? _paths;

  @override
  void initState() {
    dateinput.text = datep = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); //set the initial value of text field
    timeinput.text = timep = DateFormat('HH:mm:ss').format(DateTime.now());
    timeinpute.text = timepe = DateFormat('HH:mm:ss').format(DateTime.now());
    selectedValue = '1';
    signed = '0';
    comments = '';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void removeImage(String imagePath) {
    setState(() {
      _images.remove(imagePath);
    });
  }

  void pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['png', 'jpg', 'jpeg'],
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
          //ApiClient.uploadFile(_paths!.first.bytes!, _paths!.first.name);
        }
      }
    });
  }

  Future<void> presentAlert(BuildContext context,
      {String title = '', String message = '', Function()? ok}) {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('$title'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text('$message'),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  // style: greenText,
                ),
                onPressed: ok != null ? ok : Navigator.of(context).pop,
              ),
            ],
          );
        });
  }

  void presentLoader(BuildContext context,
      {String text = 'Aguarde...',
      bool barrierDismissible = false,
      bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Container(
                child: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(fontSize: 18.0),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  //alert box
  void alertBox(String title, String content, bool reloadp) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          /* TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ), */
          TextButton(
            onPressed: () {
              //Navigator.pop(context, 'ปิด');
              if (reloadp == true) {
                reloadPage(context);
              } else {
                Navigator.pop(context, 'Close');
              }
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  //clear data
  void clearData() {
    setState(() {
      selectedValue = '1';
    });
    signatureGlobalKey.currentState!.clear();
    controllerStudent.text = '';
    controllerSubject.text = '';
    controllerCentre.text = '';
    controllerTerm.text = '';
    controllerBook.text = '';
    textAreaController.text = '';
    dateinput.text = datep = DateFormat('yyyy-MM-dd').format(DateTime.now());
    timeinput.text = timep = DateFormat('HH:mm:ss').format(DateTime.now());
    timeinpute.text = timepe = DateFormat('HH:mm:ss').format(DateTime.now());
    signed = '0';
  }

  void clearSign() {
    signatureGlobalKey.currentState!.clear();
    signed = '0';
  }

  void reloadPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => ProfileScreen()),
    );
  }

  //signature
  //upload to api
  void postData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        isPostingData = true; // Track the posting state
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            if (!isPostingData) {
              // Hide the dialog if posting is complete
              Navigator.pop(context);
            }
            return const Dialog(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20.0),
                    Text('Saving Data..'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    const apiKey = 'infinite@2022';
    var postUri = Uri.parse("https://app.eimaths-th.com/api/savehistories");
    var request = http.MultipartRequest("POST", postUri);
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    request.headers['x-auth-key'] = apiKey;
    request.fields['centre'] = selectedCentreth!;
    request.fields['student'] = selectedStudenth!;
    request.fields['subject'] = selectedSubjecth!;
    request.fields['term'] = selectedTermh!;
    request.fields['book'] = selectedBookh!;
    request.fields['date'] = datep!;
    request.fields['stime'] = timep!;
    request.fields['etime'] = timepe!;
    request.fields['comments'] = comments!;
    //request.fields['hour'] = selectedValue!;
    request.files.add(http.MultipartFile.fromBytes(
        'file', bytes!.buffer.asUint8List(),
        filename: 'signature.png', contentType: MediaType('image', 'png')));

    /* // Add image files
    for (String path in _images) {
      request.files.add(await http.MultipartFile.fromPath('files', path));
    } */
    /*  for (String path in _images) {
      request.files.add(await http.MultipartFile.fromPath('files[]', path));
    } */

    await request.send().then((response) async {
      //print(response.statusCode);
      //console.log(response.statusCode);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: //Text(
                //'Your Favourite City is $selectedStudenth\nYour Favourite Food is $selectedSubjecth $selectedValue'),
                Text('Save Data Success'),
          ));

        alertBox('Notice', 'Save Data Success', true);
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please check your input.'),
            ),
          );

        String errorMessage = await response.stream.bytesToString();

        alertBox('แจ้งเตือน', errorMessage, true);
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Unexpected error occurred. Please try again.'),
            ),
          );

        alertBox('แจ้งเตือน', 'ไม่สามารถบันทึกข้อมูลได้', true);
      }

      clearData();
      //reloadPage(context);
      //Navigator.of(context).pop(false);

      setState(() {
        isPostingData = false; // Update the state to hide the dialog
      });
    }).catchError((error) {
      //print(error);
      setState(() {
        isPostingData = false; // Update the state to hide the dialog
      });
    });
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Container(
                color: Colors.grey[300],
                child: Image.memory(bytes!.buffer.asUint8List()),
              ),
            ),
          );
        },
      ),
    );
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
                    buildCentre(),
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
                    buildPhoto(context),
                    const SizedBox(height: 16),
                    buildsignpad(),
                    const SizedBox(height: 16),
                    buildClear(context),
                    const SizedBox(height: 12),
                    buildSubmit(context)
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildCentre() => TypeAheadFormField<Centre?>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controllerCentre,
          decoration: InputDecoration(
            labelText: 'Branch',
            prefixIcon: Icon(Icons.apartment),
            suffixIcon: GestureDetector(
              onTap: () {
                controllerCentre.clear();
                selectedCentre = null; // Reset the selectedCentre
              },
              child: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: CentreApi.getUserSuggestions,
        itemBuilder: (context, Centre? suggestion) {
          final centre = suggestion!;
          return ListTile(
            title: Text(centre.name),
          );
        },
        noItemsFoundBuilder: (context) => const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'Branch Not Found.',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        onSuggestionSelected: (Centre? suggestion) {
          controllerCentre.text = suggestion!.name;
          //hidden var
          selectedCentreth = suggestion.centreid;
          //print('selectedCentreth: $selectedCentreth');
        },
        validator: (value) =>
            value != null && value.isEmpty ? 'Please Select Branch' : null,
        onSaved: (value) => selectedCentre = value,
      );
  Widget buildStudent() => TypeAheadFormField<User?>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controllerStudent,
          decoration: InputDecoration(
            labelText: 'Student',
            prefixIcon: Icon(Icons.child_care),
            suffixIcon: GestureDetector(
              onTap: () {
                controllerStudent.clear();
                selectedCentre = null; // Reset the selectedCentre
              },
              child: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: (String query) =>
            UserApi.getUserSuggestions(query, selectedCentreth ?? ''),
        itemBuilder: (context, User? suggestion) {
          final user = suggestion!;
          return ListTile(
            title: Text(user.name),
          );
        },
        noItemsFoundBuilder: (context) => const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              'Sudent Not Found.',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        onSuggestionSelected: (User? suggestion) {
          controllerStudent.text = suggestion!.name;
          //hidden var
          selectedStudenth = suggestion.stuid;
        },
        validator: (value) =>
            value != null && value.isEmpty ? 'Please Select Student' : null,
        onSaved: (value) => selectedStudent = value,
      );

  Widget buildSubject() => TypeAheadFormField<Subject?>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controllerSubject,
          decoration: InputDecoration(
            labelText: 'Level',
            prefixIcon: Icon(Icons.text_rotation_angleup),
            suffixIcon: GestureDetector(
              onTap: () {
                controllerSubject.clear();
                selectedCentre = null; // Reset the selectedCentre
              },
              child: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: (String query) =>
            SubjectApi.getSubjectSuggestions(query, selectedStudenth ?? ''),
        itemBuilder: (context, Subject? suggestion) {
          final subject = suggestion!;
          return ListTile(
            title: Text(subject.name),
          );
        },
        onSuggestionSelected: (Subject? suggestion) {
          controllerSubject.text = suggestion!.name;
          selectedSubjecth = suggestion.subid;
        },
        validator: (value) =>
            value != null && value.isEmpty ? 'Please Select Level' : null,
        onSaved: (value) => selectedSubject = value,
      );

  Widget buildTerm() => TypeAheadFormField<Term?>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controllerTerm,
          decoration: InputDecoration(
            labelText: 'Term',
            prefixIcon: Icon(Icons.lightbulb_circle),
            suffixIcon: GestureDetector(
              onTap: () {
                controllerTerm.clear();
                selectedCentre = null; // Reset the selectedCentre
              },
              child: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: (String query) =>
            TermApi.getTermSuggestions(query, selectedSubjecth ?? ''),
        itemBuilder: (context, Term? suggestion) {
          final term = suggestion!;
          return ListTile(
            title: Text(term.name),
          );
        },
        onSuggestionSelected: (Term? suggestion) {
          controllerTerm.text = suggestion!.name;
          selectedTermh = suggestion.termid;
        },
        validator: (value) =>
            value != null && value.isEmpty ? 'Please Select Term' : null,
        onSaved: (value) => selectedTerm = value,
      );

  /* Widget buildBook() => TypeAheadFormField<Book?>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: controllerBook,
          decoration: InputDecoration(
            labelText: 'หนังสือ',
            prefixIcon: Icon(Icons.library_books),
            suffixIcon: GestureDetector(
              onTap: () {
                controllerBook.clear();
                selectedCentre = null; // Reset the selectedCentre
              },
              child: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: (String query) => BookApi.getBookSuggestions(
            query, selectedSubjecth ?? '', selectedTermh ?? ''),
        itemBuilder: (context, Book? suggestion) {
          final book = suggestion!;
          return ListTile(
            title: Text(book.name),
          );
        },
        onSuggestionSelected: (Book? suggestion) {
          controllerBook.text = suggestion!.name;
          selectedBookh = suggestion.bookid;
        },
        validator: (value) =>
            value != null && value.isEmpty ? 'กรุณาระบุหนังสือ' : null,
        onSaved: (value) => selectedBook = value,
      ); */

  Widget buildBook() {
    return TextFormField(
      controller: controllerBook,
      decoration: InputDecoration(
        labelText: "Book",
        prefixIcon: Icon(Icons.library_books),
        suffixIcon: GestureDetector(
          onTap: () {
            controllerBook.clear();
            //selectedCentre = null; // Reset the selectedCentre
          },
          child: Icon(Icons.clear),
        ),
        border: OutlineInputBorder(),
      ),
      maxLines: 1,
      onChanged: (text) {
        controllerBook.text = text;
        selectedBookh = text;
      },
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please input book';
        }
        return null;
      },
    );
  }

  Widget buildDate() => TextFormField(
        controller: dateinput, //editing controller of this TextField
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.calendar_today),
          //icon: Icon(Icons.calendar_today), //icon of text field
          labelText: "Study Date", //label text of field
          border: OutlineInputBorder(),
          //hintText: 'Enter a search term',
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            setState(() {
              dateinput.text =
                  formattedDate; //set output date to TextField value.
              datep = formattedDate;
            });
          } else {
            //print("Date is not selected");
          }
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            /* return 'Can\'t be empty'; */
            return 'Please Select Study Date';
          }
          /*  if (text.length < 4) {
                return 'Too short';
              } */
          return null;
        },
      );

  Widget buildTime() => TextFormField(
        controller: timeinput, //editing controller of this TextField
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.timer), //icon of text field
          labelText: "Start Time", //label text of field
          border: OutlineInputBorder(),
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((pickedTime) {
            if (pickedTime != null) {
              setState(() {
                final formattedTime = _timeFormat.format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );
                timeinput.text = formattedTime;
                timep = formattedTime;
              });
            }
          });
          /*  TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(),
            context: context,
          );

          if (pickedTime != null) {
            //print('1' + pickedTime.format(context)); //output 10:51 PM
            DateTime parsedTime =
                DateFormat('hh:mm a').parse(pickedTime.format(context));
            String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
            //print(formattedTime); //output 14:59:00
            setState(() {
              timeinput.text = formattedTime; //set the value of text field.
              timep = formattedTime;
            });
          } else {
            //print("Time is not selected");
          } */
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            /* return 'Can\'t be empty'; */
            return 'Please input start time';
          }
          /*  if (text.length < 4) {
                return 'Too short';
              } */
          return null;
        },
      );

  Widget buildeTime() => TextFormField(
        controller: timeinpute, //editing controller of this TextField
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.timer), //icon of text field
          labelText: "End Time", //label text of field
          border: OutlineInputBorder(),
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((pickedTime) {
            if (pickedTime != null) {
              setState(() {
                final formattedTime = _timeFormat.format(
                  DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    pickedTime.hour,
                    pickedTime.minute,
                  ),
                );
                timeinpute.text = formattedTime;
                timepe = formattedTime;
              });
            }
          });
        },
        validator: (text) {
          if (text == null || text.isEmpty) {
            /* return 'Can\'t be empty'; */
            return 'Please input end time';
          }
          /*  if (text.length < 4) {
                return 'Too short';
              } */
          return null;
        },
      );

  Widget buildTextArea() {
    return TextFormField(
      controller: textAreaController,
      decoration: const InputDecoration(
        labelText: "Comments",
        border: OutlineInputBorder(),
      ),
      maxLines: 4,
      onChanged: (text) {
        comments = text;
      },
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please input Comments';
        }
        return null;
      },
    );
  }

  Widget buildHour() => DropdownButtonFormField(
      decoration: const InputDecoration(
        /*  enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1),
          //borderRadius: BorderRadius.circular(20),
        ), */
        prefixIcon: Icon(Icons.browse_gallery),
        labelText: "ชั่วโมงที่เรียน", //label text of field
        border: OutlineInputBorder(
            //borderSide: BorderSide(color: Colors.blue, width: 1),
            //borderRadius: BorderRadius.circular(20),
            ),
        //filled: true,
        //fillColor: Colors.blueAccent,
      ),
      //dropdownColor: Colors.blueAccent,
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
      },
      items: dropdownItems);

  Widget buildSubmit(BuildContext context) => Column(children: <Widget>[
        ButtonWidget(
          text: 'Save',
          onClicked: () {
            final form = formKey.currentState!;

            if (signed == '0') {
              alertBox('Alert', 'Parents, please sign', false);
            } else if (_images.isEmpty) {
              //alertBox('Alert', 'Please upload at least 1 photo', false);
              form.save();

              ///upload sig
              postData();
            } else {
              if (form.validate() && signed == '1') {
                form.save();

                ///upload sig
                postData();
              }
            }
          },
        ),
      ]);

  Widget buildClear(BuildContext context) => Column(children: <Widget>[
        ButtonWidget(
          text: 'Clear Signature',
          onClicked: () {
            clearSign();
          },
        ),
        const SizedBox(height: 10),
        ButtonWidget(
          text: 'Reset Data',
          onClicked: () {
            //_handleSaveButtonPressed();
            clearData();
          },
        ),
        //const SizedBox(height: 10),
      ]);

  Widget buildsignpad() => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: SfSignaturePad(
            key: signatureGlobalKey,
            backgroundColor: Colors.grey[200],
            strokeColor: Colors.black,
            minimumStrokeWidth: 1.0,
            maximumStrokeWidth: 4.0,
            onDrawEnd: () {
              signed = '1';
            }),
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
