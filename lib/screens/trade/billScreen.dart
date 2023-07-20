import 'dart:convert';
import 'package:barterit/models/cart.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/trade/tradetabScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../myconfig.dart';

class BillScreen extends StatefulWidget {
  final User user;
  final List<Cart> cart;
  final Item item;
  final int totalprice;

  const BillScreen({
    Key? key,
    required this.user,
    required this.totalprice,
    required this.cart,
    required this.item,
  }) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  TextEditingController _amountController = TextEditingController();
  int _paymentAmount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/barter8.jpg', // Path to the image
              height: 200, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            Text(
              'Total Fee: RM${widget.totalprice}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              onChanged: (value) {
                setState(() {
                  _paymentAmount = int.tryParse(value) ?? 0;
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Payment Amount',
                prefixIcon: Icon(Icons.payment),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _paymentAmount >= widget.totalprice
                  ? generateReceiptAndDeleteItem
                  : null,
              child: const Text('Make Payment'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: paymentUnsuccessful,
              child: const Text('Unsuccessful Payment'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void generateReceiptAndDeleteItem() async {
    var deleteCartResponse = await http.post(
      Uri.parse("${MyConfig().SERVER}/barterit/php/delete_all.php"),
      body: {"user_id": widget.user.id},
    );
    var deleteCartJsonData = jsonDecode(deleteCartResponse.body);
    if (deleteCartJsonData['status'] == 'success') {
      for (var cartItem in widget.cart) {
        // Delete each item from the database
        var deleteItemResponse = await http.post(
          Uri.parse("${MyConfig().SERVER}/barterit/php/delete_item.php"),
          body: {"item_id": cartItem.itemId},
        );

        var deleteItemJsonData = jsonDecode(deleteItemResponse.body);
        if (deleteItemJsonData['status'] == 'success') {
          print('Item ${cartItem.itemId} deleted successfully.');

          // Add order to the database
          var addOrderResponse = await http.post(
            Uri.parse("${MyConfig().SERVER}/barterit/php/addorder.php"),
            body: {
              "user_id": widget.user.id,
              "seller_id": cartItem.sellerId,
              "item_id": cartItem.itemId,
              "item_name": cartItem.itemName,
            },
          );

          var addOrderJsonData = jsonDecode(addOrderResponse.body);
          if (addOrderJsonData['status'] == 'success') {
            print('Order for item ${cartItem.itemId} added successfully.');
          } else {
            print('Failed to add order for item ${cartItem.itemId}.');
          }
        } else {
          print('Failed to delete item ${cartItem.itemId}.');
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successful Payment'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => tradeTabScreen(user: widget.user),
        ),
      );
    }
  }

  void paymentUnsuccessful() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Unsuccessful'),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.pop(context); // Navigate back to the tradeCartScreen
  }
}
