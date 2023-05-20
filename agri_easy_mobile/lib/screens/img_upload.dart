import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

Future<http.Response> getPrediction(File imageFile) async {
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://asia-south1-plant-disease-ml.cloudfunctions.net/predict'));
  request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
  var res = await request.send();
  return await http.Response.fromStream(res);
}

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  String _result = '';
  String _label = '';
  String _solve = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        _getImageResult(File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ERROR'),
        ),
      );
    }
  }

  Future<void> _getImageResult(File imageFile) async {
    setState(() {
      _image = imageFile;
      _result = '';
      _label = 'Predicting...';
      _solve = '...';
    });

    final res = await getPrediction(imageFile);
    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body);
      setState(() {
        _result = responseJson['class'] ?? 'Failed to predict';
        _label = responseJson['confidence'] != null
            ? 'Confidence: ${responseJson['confidence'].toStringAsFixed(2)}%'
            : 'Failed to predict';
        _solve = responseJson['solve'] ?? 'Failed to predict';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ERROR'),
        ),
      );
      setState(() {
        _image = null;
        _result = '';
        _label = 'Failed to predict';
        _solve = '';
      });
    }
  }

  void _clearOutput() {
    setState(() {
      _image = null;
      _result = '';
      _label = '';
      _solve = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TITTLE',
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Color.fromARGB(255, 0, 100, 3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            'Detector',
            style: GoogleFonts.acme(
              textStyle: const TextStyle(
                  fontFamily: 'roboto',
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 40,
                  letterSpacing: 2),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _image == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: const Color.fromARGB(255, 1, 79, 14)
                                  .withOpacity(0.7),
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: const Color.fromARGB(255, 214, 244, 218),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 7, 84, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'No image selected',
                              style: GoogleFonts.dosis(
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 244, 218),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 7, 84, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: const Color.fromARGB(255, 15, 97, 2),
                              width: 4,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              height: 250,
                              width: 250,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8,
                    left: 95,
                    right: 95,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 1, 64, 3)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _getImage(ImageSource.camera),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      color: Color.fromARGB(255, 0, 128, 4),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Take a Photo',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 7, 84, 1)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () => _getImage(ImageSource.gallery),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.photo_library,
                                      color: Color.fromARGB(255, 0, 128, 4),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Gallery',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.1),
                          child: SizedBox(
                            height: 50,
                            child: Material(
                              borderRadius: BorderRadius.circular(25),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: _clearOutput,
                                child: Container(
                                  color: const Color.fromARGB(255, 4, 154, 9),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.refresh,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Refresh',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  _result,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dosis(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 40,
                        letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _label,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    _solve,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.dosis(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          letterSpacing: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
