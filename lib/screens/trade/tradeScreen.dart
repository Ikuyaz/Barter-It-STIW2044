import 'dart:convert';
import 'dart:developer';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/trade/tradeCartScreen.dart';
import 'package:barterit/screens/trade/tradeDetailsScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../myconfig.dart';

class tradeScreen extends StatefulWidget {
  final User user;

  const tradeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<tradeScreen> createState() => _tradeScreenState();
}

class _tradeScreenState extends State<tradeScreen> {
  String maintitle = "Trade";
  List<Item> itemlist = <Item>[];
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  int numofpage = 1, curpage = 1;
  int numberofresult = 0;
  int cartqty = 0;
  var color;
  final _scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadTrade(curpage + 1);
      }
    });
    loadTrade(1);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: [
          IconButton(
            onPressed: () {
              showSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
          TextButton.icon(
            icon: const Icon(Icons.shopping_cart),
            label: Text(cartqty.toString()),
            onPressed: () {
              if (cartqty > 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (content) => tradeCartScreen(
                      user: widget.user,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No item in cart")),
                );
              }
            },
          ),
        ],
      ),
      body: widget.user.id == "0"
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Guest Have No Items",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Please Login to Proceed the Item List",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  height: 24,
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.center,
                  child: Text(
                    "$numberofresult Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemlist.length,
                      (index) {
                        return Card(
                          child: InkWell(
                            onTap: () async {
                              Item item =
                                  Item.fromJson(itemlist[index].toJson());
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (content) => tradeDetailScreen(
                                    user: widget.user,
                                    item: item,
                                  ),
                                ),
                              );
                              loadTrade(1);
                            },
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().SERVER}/barterit/assets/images/${itemlist[index].itemId}-1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemlist[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  itemlist[index].itemType.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  itemlist[index].itemLocality.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadTrade(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> loadTrade(int pg) async {
    if (widget.user.id == "0") {
      setState(() {
        itemlist.clear();
        numberofresult = 0;
        numofpage = 1;
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_item.php"),
        body: {
          "user_id": widget.user.id,
          "pageNo": pg.toString(),
          "search": searchController.text,
        },
      );

      if (response.statusCode == 200) {
        final jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          setState(() {
            itemlist.clear();
            numofpage = jsondata['numofpage'];
            numberofresult = jsondata['numberofresult'];
            final extractdata = jsondata['data'];
            extractdata['items'].forEach((v) {
              itemlist.add(Item.fromJson(v));
            });
          });
        } else {
          // Handle API error response
        }
      } else {
        // Handle non-200 HTTP response
      }
    } catch (error) {
      // Handle network or other error
      print("Error: $error");
    }
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Search for Trade",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: () {
                  String search = searchController.text;
                  searchItem(search);
                  Navigator.of(context).pop();
                },
                child: const Text("Search"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
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

  void searchItem(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_item.php"),
        body: {"search": search, "user_id": widget.user.id}).then((response) {
      log(response.body);
      itemlist.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemlist.add(Item.fromJson(v));
          });
          numofpage = jsondata['numofpage'];
          numberofresult = jsondata['numberofresult'];
        }
        setState(() {});
      }
    });
  }
}
