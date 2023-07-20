import 'dart:convert';
import 'dart:io';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/trade/tradeScreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';

class addScreen extends StatefulWidget {
  final User user;
  final bool isGuest;

  const addScreen({Key? key, required this.user, required this.isGuest})
      : super(key: key);
  @override
  State<addScreen> createState() => _addScreenState();
}

class _addScreenState extends State<addScreen> {
  int _currentIndex = 3;
  List<File> selectedImages = [];
  List<XFile>? images = [];
  var pathAsset = "assets/images/camera.jpg";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _descEditingController = TextEditingController();
  final TextEditingController _interestEditingController =
      TextEditingController();
  final TextEditingController _stateEditingController = TextEditingController();
  final TextEditingController _localEditingController = TextEditingController();
  String selectedType = "Type of Items";
  List<String> itemlist = [
    "Type of Items",
    "Electrical Appliances",
    "Food",
    "Personal Care Supplies",
    "Medicines",
    "Clothing",
    "Other",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String lat = "";
  String long = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add"),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          if (widget.user.id != "0")
            IconButton(
              onPressed: () {
                _determinePosition();
              },
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: Visibility(
        visible: !widget.isGuest && widget.user.id != "0",
        replacement: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Guest Are Unable to Post Item",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Please Proceed to Login to Post Item",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        child: Column(children: [
          Flexible(
            flex: 4,
            child: GestureDetector(
              onTap: () {
                _selectFromCamera();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  child: Container(
                    width: screenWidth,
                    child: selectedImages.isEmpty
                        ? Image.asset(pathAsset, fit: BoxFit.contain)
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              return Image.file(selectedImages[index]);
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.type_specimen),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            height: 65,
                            child: DropdownButton<String>(
                              value:
                                  selectedType.isNotEmpty ? selectedType : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedType = newValue ?? "";
                                  print(selectedType);
                                });
                              },
                              items: itemlist.map((String selectedType) {
                                return DropdownMenuItem<String>(
                                  value: selectedType,
                                  child: Text(
                                    selectedType,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Item name must be longer than 3"
                                        : null,
                                onFieldSubmitted: (v) {},
                                controller: _nameEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Item Name',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.abc),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          )
                        ],
                      ),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty
                              ? "Item description must be longer than 3"
                              : null,
                          onFieldSubmitted: (v) {},
                          maxLines: 4,
                          controller: _descEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.description,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty
                              ? "Item Interest must be longer than 3"
                              : null,
                          onFieldSubmitted: (v) {},
                          maxLines: 4,
                          controller: _interestEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Item Interest',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.insert_emoticon,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      Row(children: [
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _stateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current State',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                        Flexible(
                          flex: 5,
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              enabled: false,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current Locality"
                                      : null,
                              controller: _localEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current Locality',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.map),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ]),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: screenWidth / 1.2,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              insertDialog();
                            },
                            child: const Text("Insert Item")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMultiImage(
      maxHeight: 1200,
      maxWidth: 800,
    );
    List<XFile> xfilePick = pickedFile;
    setState(() {
      if (xfilePick.isNotEmpty) {
        for (var i = 0; i < xfilePick.length; i++) {
          selectedImages.add(File(xfilePick[i].path));
        }
      } else {
        print('No image selected.');
      }
    });

    List<File>? croppedImages = await cropImages(selectedImages);
    if (croppedImages != null) {
      setState(() {
        selectedImages = croppedImages;
      });
    }
  }

  Future<List<File>?> cropImages(List<File> images) async {
    List<File> croppedImages = [];

    for (var image in images) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.ratio3x2,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        croppedImages.add(File(croppedFile.path));
      }
    }

    return croppedImages.isNotEmpty ? croppedImages : null;
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please take picture")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your Item?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertItem();
                //registerUser();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertItem() async {
    String itemname = _nameEditingController.text;
    String itemdesc = _descEditingController.text;
    String iteminterest = _interestEditingController.text;
    String state = _stateEditingController.text;
    String locality = _localEditingController.text;
    List<String> base64Images = [];
    for (var image in selectedImages) {
      List<int> imageBytes = await image.readAsBytes();
      print(base64Images.length);
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/add_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itemname": itemname,
          "itemdesc": itemdesc,
          "iteminterest": iteminterest,
          "itemtype": selectedType,
          "latitude": lat,
          "longitude": long,
          "state": state,
          "locality": locality,
          "image": jsonEncode(base64Images)
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => tradeScreen(user: widget.user),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => tradeScreen(user: widget.user),
          ),
        );
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _localEditingController.text = "Changlun";
      _stateEditingController.text = "Kedah";
      lat = "6.443455345";
      long = "100.05488449";
    } else {
      _localEditingController.text = placemarks[0].locality.toString();
      _stateEditingController.text =
          placemarks[0].administrativeArea.toString();
      lat = _currentPosition.latitude.toString();
      long = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
