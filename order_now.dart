import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'order_data.dart';

import 'database.dart';
import 'order_model.dart';
import 'orders.dart';

class AddOrder extends StatefulWidget {
  final MyDatabase myDatabase;
  final Function()? onOrderAdded;
  const AddOrder(
      {super.key, required this.myDatabase, String? userId, this.onOrderAdded});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  bool isFemale = false;
  String? _selectedPayment;
  String? _selectedProductType;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  double totalAmount = 0.0;

  void calculateTotalAmount() {
    double amount = 0.0;
    double quantity = double.tryParse(qtyController.text) ?? 0.0;

    if (_selectedProductType == 'alkaline') {
      amount = 30.0;
    } else if (_selectedProductType == 'mineral') {
      amount = 25.0;
    }

    totalAmount = amount * quantity;
    amountController.text = totalAmount.toStringAsFixed(2);
  }

  Future<void> connectWithGCashAPI() async {
    // Obtain the required API credentials from GCash
    final String clientId = 'YOUR_CLIENT_ID';
    final String clientSecret = 'YOUR_CLIENT_SECRET';
    final String accessToken = 'YOUR_ACCESS_TOKEN';

    // Set the endpoint URL for the desired GCash API endpoint
    const String apiUrl = 'https://api.gcash.com/v1/your-api-endpoint';

    // Set the required headers and authentication parameters
    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      // Add any other required headers
    };

    // Make an HTTP request to the GCash API endpoint
    final http.Response response =
        await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      // Request successful, process the response
      final String responseBody = response.body;
      // Parse and use the response data as needed
      print(responseBody);
    } else {
      // Request failed, handle the error
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place your order'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Emp Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              // Emp Designation
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  hintText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Product Type',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'alkaline',
                    child: Text('Alkaline'),
                  ),
                  DropdownMenuItem(
                    value: 'mineral',
                    child: Text('Mineral'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedProductType = value;
                  });
                },
                value: _selectedProductType,
                onSaved: (String? value) {
                  productTypeController.text = value ?? '';
                },
              ),

              TextFormField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                ),
                onChanged: (value) {
                  setState(() {
                    calculateTotalAmount();
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Order Amount',
                ),
                enabled: false,
              ),

              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Type',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'gcash',
                    child: Text('GCash'),
                  ),
                  DropdownMenuItem(
                    value: 'cash',
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: 'paymaya',
                    child: Text('Paymaya'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedPayment = value;
                  });

                  if (value == 'gcash') {
                    connectWithGCashAPI();
                  }
                },
                value: _selectedPayment,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: contactController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
              ),

              TextFormField(
                controller: noteController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Note',
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final order = Order(
                  //       cusName: nameController.text,
                  //       cusAddress: addressController.text,
                  //       contact: contactController.text,
                  //       amount: amountController.text,
                  //       producttype: _selectedProductType ?? '',
                  //       payment: _selectedPayment ?? '',
                  //       status: 'Pending',
                  //       quantity: qtyController.text,
                  //       orderDate: DateTime.now(),
                  //     );

                  //     await widget.myDatabase.insertOrder(order);
                  //     final orders = await widget.myDatabase.getOrders();
                  //     orders.forEach((order) => print(order.orderDate));

                  //     if (mounted) {
                  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //         backgroundColor: Colors.green,
                  //         content: Text('${order.cusName} confirm order.'),
                  //       ));
                  //       Navigator.pushAndRemoveUntil(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => const myOrders()),
                  //         (route) => false,
                  //       );
                  //     }
                  //   },
                  //   child: const Text('Add'),
                  // ),

                  ElevatedButton(
                    onPressed: () async {
                      final currentUser = FirebaseAuth.instance.currentUser!;
                      final orderId = await widget.myDatabase.countEmp() + 1;

                      //Data to display...
                      final order = Order(
                        cusName: nameController.text,
                        cusAddress: addressController.text,
                        contact: contactController.text,
                        amount: amountController.text,
                        producttype: _selectedProductType ?? '',
                        payment: _selectedPayment ?? '',
                        status: 'Pending',
                        quantity: qtyController.text,
                        orderDate: DateTime.now(),
                      );

                      await widget.myDatabase
                          .insertOrder(order, currentUser.uid);

                      //     await widget.myDatabase.insertOrder(order);
                      // final orders = await widget.myDatabase.getOrders();
                      final orders = await widget.myDatabase
                          .getOrdersByUserId(currentUser.uid);
                      orders.forEach((order) => print(order.orderDate));

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('${order.cusName} confirm order.'),
                        ));
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const myOrders()),
                        //   (route) => false,
                        // );
                        Navigator.pop(context);
                        if (widget.onOrderAdded != null) {
                          widget.onOrderAdded!();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => myOrders(),
                          ),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey),
                      onPressed: () {
                        //
                        // idController.text = '';
                        nameController.text = '';
                        addressController.text = '';
                        contactController.text = '';
                        amountController.text = '';
                        productTypeController.text = '';
                        noteController.text = '';
                        qtyController.text = '';
                        setState(() {});
                        _focusNode.requestFocus();
                        //
                      },
                      child: const Text('Reset')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
