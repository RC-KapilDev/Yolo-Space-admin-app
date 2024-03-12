import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:yolo_business/Screens/checkscreen.dart';
import 'package:yolo_business/Screens/deleteScreen.dart';
import 'package:yolo_business/widgets/carousel.dart';
import 'package:yolo_business/widgets/divideline.dart';
import 'package:yolo_business/widgets/sidenavigation.dart';
import 'package:yolo_business/widgets/successScreen.dart';
import 'package:yolo_business/widgets/unsuccessScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:yolo_business/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'model/dataModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  List<XFile?> _selectedImages = [];
  List<String> _imageUrls = [];
  bool visible = false;
  final TextEditingController _locationController = TextEditingController();
  final List<String> _selectedLocations = [];
  final List<String> _selectedAmenities = [];
  final TextEditingController _addressController = TextEditingController();
  String address = '';
  final GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  TextEditingController controller = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  String _rentValue = '';
  String selectedSexString = 'unisex';

  void _submitRoomDetails() {
    int? rent = int.tryParse(_rentValue) ?? 0;
    bool allConditionsMet = true;

    if (_selectedImages.isEmpty) {
      showError('Please Enter an Image');
      allConditionsMet = false;
    }
    if (address.length <= 20) {
      showError('Please Enter a Valid Address with 20 Character');
      allConditionsMet = false;
    }
    if (rent <= 1000 && rent >= 0) {
      showError('Please Enter a valid Rent Above 1000 ');
      allConditionsMet = false;
    }
    if (_selectedAmenities.isEmpty) {
      showError('Please Enter at least one Amenity');
      allConditionsMet = false;
    }
    if (_selectedLocations.isEmpty) {
      showError('Please Enter Area and City');
      allConditionsMet = false;
    }
    if (selectedSexString.isEmpty) {
      showError('Please Enter Valid Type');
      allConditionsMet = false;
    }

    if (allConditionsMet) {
      final value = _selectedAmenities.length;
      String roomtype = 'basic';
      if (value <= 4 && value >= 2) {
        roomtype = 'medium';
      }
      if (value <= 8 && value >= 4) {
        roomtype = 'premium';
      }
      if (value <= 12 && value >= 8) {
        roomtype = 'luxury';
      }

      Map<String, dynamic> mapRoomDetailsToJson() {
        return {
          "roomtype": roomtype,
          "location": _selectedLocations,
          "sex": selectedSexString,
          "amenities": _selectedAmenities,
          "rent": int.tryParse(_rentValue) ?? 0,
          "address": address,
          "image": _imageUrls,
        };
      }

      postRoomDetails(context, mapRoomDetailsToJson());
    }
  }

  void postRoomDetails(
      BuildContext context, Map<String, dynamic> roomDetails) async {
    String jsonData = jsonEncode(roomDetails);
    print(jsonData);

    // Set up the POST request
    var url = Uri.parse('https://sore-jade-jay-wig.cyclic.app/validate/room');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );
    print(response.body);
    // Check the response status
    if (response.statusCode == 200) {
      // Request successful
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );
    } else {
      // Request failed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UnsuccessfulScreen(),
        ),
      );
    }
  }

  void showError(String text) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Invalid Input'),
              content: Text(text),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  Future<void> _pickImages() async {
    final imagePicker = ImagePicker();
    final pickedFileList = await imagePicker.pickMultiImage();
    setState(() {
      _selectedImages = pickedFileList;
    });
    _uploadImages();
  }

  Future<List<String>> _uploadImages() async {
    if (_selectedImages.isEmpty) {
      return [];
    }

    final imageUrls = <String>[];

    for (final imageFile in _selectedImages) {
      final filePath = imageFile!.path;
      final fileName = path.basename(filePath);

      try {
        final path = 'files/${imageFile.name}';
        final file = File(imageFile.path);
        final reference = FirebaseStorage.instance.ref().child(path);
        final uploadTask =
            reference.putFile(file, SettableMetadata(contentType: 'image/jpg'));
        final snapshot = await uploadTask.whenComplete(() => null);
        final url = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrls.add(url);
        });
      } catch (error) {
        print('Error uploading image: $error');
      }
    }
    setState(() {
      _imageUrls = imageUrls;
      visible = true;
    });
    print(imageUrls);
    return imageUrls;
  }

  List<Amenities> convertToAmenitiesList(List<String> stringList) {
    return stringList.map((str) {
      return Amenities.values.firstWhere((amenity) {
        return amenity.toString().split('.').last == str;
      });
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    _rentController.clear();
    controller.clear();
    _addressController.clear();
    _locationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      home: SafeArea(
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text('Yolo Rooms'),
          ),
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                const Text(
                  'Enter Details',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Enter Area and City *',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                LocationInput(),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                ShowOptions(),
                const SizedBox(
                  height: 15,
                ),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Enter Rent Amount *',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RentWidget(),
                const SizedBox(
                  height: 15,
                ),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                AddressTextWidget(),
                const SizedBox(
                  height: 15,
                ),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Room Accomodation Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropDownSex(),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                ImagesWidgets(),
                const SizedBox(
                  height: 15,
                ),
                const DividerLine(),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: visible ? _submitRoomDetails : null,
                  child: const Text('Submit Details'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column ImagesWidgets() {
    return Column(
      children: [
        if (_selectedImages.isNotEmpty)
          Visibility(
            visible: visible,
            replacement: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text('Wait For a moment files needs to be uploaded'))
              ],
            ),
            child: Carousel(
              imageUrls: _imageUrls,
            ),
          ),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Pick Image'),
            ),
          ],
        ),
      ],
    );
  }

  DropdownButton<String> DropDownSex() {
    return DropdownButton<String>(
      value: selectedSexString,
      onChanged: (String? newValue) {
        setState(() {
          selectedSexString = (newValue ?? 'unisex').toLowerCase();
        });
      },
      items: Sex.values.map((sex) {
        return DropdownMenuItem<String>(
          value: sex.toString().split('.').last.toLowerCase(),
          child: Text(sex.toString().split('.').last.toUpperCase()),
        );
      }).toList(),
    );
  }

  Row TextWidgetRandom() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Enter text',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue, width: 2.0),
              ),
              prefixIcon: const Icon(Icons.text_fields),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Handle the submission of text here
          },
        ),
      ],
    );
  }

  Column AddressTextWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Enter Address *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null, // Allow unlimited number of lines
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Enter your address...',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Address: $address',
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              address = _addressController.text;
            });
            // Handle the submission of the address

            print('Address submitted: $address');
          },
          child: const Text('Confirm Address'),
        ),
      ],
    );
  }

  Column RentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _rentController,
                decoration: InputDecoration(
                  hintText: 'Enter rent amount',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  prefixIcon: const Icon(Icons.currency_exchange),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _rentController.clear();
                      setState(() {
                        _rentValue = '';
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  _rentValue = _rentController.text;
                  _rentController.clear();
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Rent: $_rentValue',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Column LocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Chennai',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  labelText: 'Enter Area and City',
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.location_on),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _locationController.clear();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedLocations.add(_locationController.text);
                  _locationController.clear();
                });
                print(_selectedLocations);
              },
              child: const Text('OK'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Locations:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: _selectedLocations.map((location) {
            return Chip(
              label: Text(location),
              onDeleted: () {
                setState(() {
                  _selectedLocations.remove(location);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Column ShowOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amenities avaliable in the Room *',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: Amenities.values.map((amenity) {
            return FilterChip(
              label: Text(amenity.toString().split('.').last),
              selected: _selectedAmenities
                  .contains(amenity.toString().split('.').last),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity.toString().split('.').last);
                  } else {
                    _selectedAmenities
                        .remove(amenity.toString().split('.').last);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selected Amenities:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          children: _selectedAmenities.map((amenity) {
            return Chip(
              label: Text(amenity),
              onDeleted: () {
                setState(() {
                  _selectedAmenities.remove(amenity);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
