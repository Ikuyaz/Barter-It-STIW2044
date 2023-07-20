import 'dart:convert';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/User/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  final User user;

  const OrderScreen({Key? key, required this.user}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<List<dynamic>>? _futurePurchases;
  Future<List<dynamic>>? _futureSales;

  @override
  void initState() {
    super.initState();
    _futurePurchases = fetchPurchases();
    _futureSales = fetchSales();
  }

  Future<List<dynamic>> fetchPurchases() async {
    final response = await http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/load_order.php"),
      body: {
        'buyer_id': widget.user.id,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        return jsonData['data'];
      } else {
        throw Exception('Failed to load purchases: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load purchases');
    }
  }

  Future<List<dynamic>> fetchSales() async {
    final response = await http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/load_order.php"),
      body: {
        'seller_id': widget.user.id,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'success') {
        return jsonData['data'];
      } else {
        throw Exception('Failed to load sales: ${jsonData['message']}');
      }
    } else {
      throw Exception('Failed to load sales');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => profilePage(user: widget.user),
                ),
              );
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Purchases'),
              Tab(text: 'Sales'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Purchases tab
            FutureBuilder<List<dynamic>>(
              future: _futurePurchases,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No purchases found.'));
                }

                // Data is available, build the list view for purchases.
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final orderData = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${orderData['item_name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${orderData['item_id']}'),
                            Text('Seller ID: ${orderData['seller_id']}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            // Sales tab
            FutureBuilder<List<dynamic>>(
              future: _futureSales,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No sales found.'));
                }

                // Data is available, build the list view for sales.
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final orderData = snapshot.data![index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('${orderData['item_name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order ID: ${orderData['item_id']}'),
                            Text('Buyer ID: ${orderData['buyer_id']}'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
