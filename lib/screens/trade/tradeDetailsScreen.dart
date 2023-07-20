import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:barterit/screens/User/loginScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../models/item.dart';
import '../../models/user.dart';
import '../../myconfig.dart';

class tradeDetailScreen extends StatefulWidget {
  final User user;
  final Item item;

  const tradeDetailScreen({Key? key, required this.user, required this.item})
      : super(key: key);

  @override
  State<tradeDetailScreen> createState() => _tradeDetailScreenState();
}

class _tradeDetailScreenState extends State<tradeDetailScreen> {
  final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
  final List<File?> _images = List.generate(3, (index) => null);
  late double screenHeight, screenWidth, cardWidth;

  @override
  Widget build(BuildContext context) {
    if (widget.user.id == "0") {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Item Details"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Add app logo
                Image.asset(
                  "assets/images/barter5.jpg",
                  height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Please Login To View This Page",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const loginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    print(widget.item.userId);
    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: Column(
        children: [
          Flexible(
            flex: 4,
            child: Container(
              height: 270,
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Card(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    _images.length,
                    (index) {
                      return Column(
                        children: [
                          SizedBox(
                            width: screenWidth / 1.1,
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  height: 230,
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit/assets/images/${widget.item.itemId}-${index + 1}.png",
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.item.itemName.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Owner ID",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.item.userId.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Description:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            widget.item.itemDesc.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Item Category:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            // Add the item category here
                            widget.item.itemType.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Upload Date:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            dateFormat.format(
                              DateTime.parse(widget.item.itemDate.toString()),
                            ),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Upload Location:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '${widget.item.itemLocality}, ${widget.item.itemState}',
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Item Interest:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            // Add the item category here
                            widget.item.itemInterest.toString(),
                            style: const TextStyle(
                              fontSize: 16, // Adjust the font size here
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            addtocart();
          },
          child: const Text(
            "TRADE",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  void addtocart() {
    if (widget.user.id == widget.item.userId) {
      Fluttertoast.showToast(
        msg: "You can't barter your own item",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
      return;
    }
    http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/addtocart.php"),
      body: {
        "itemid": widget.item.itemId,
        "userid": widget.user.id,
        "sellerid": widget.item.userId,
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        //log(response.body);

        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        }
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
    });
  }
}
