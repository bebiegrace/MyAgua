import 'package:aguadaa/pages/employees/sales_report_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../order/database.dart';
import '../order/order_model.dart';
import 'employee_viewlist.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminScreenState();
}

class _DashboardAdminScreenState extends State<DashboardAdmin> {
  bool isLoading = false;
  List<Order> orders = [];
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;

  Future<void> getDataFromDb() async {
    setState(() {
      isLoading = true;
    });

    await _myDatabase.openDb();
    final List<Order> result = await _myDatabase.getOrders();
    orders.clear();
    orders.addAll(result);
    count = await _myDatabase.countEmp();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(50))),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    "Hi",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    "Good Day",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('lib/images/user.jpg'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          // Container(
          //   color: Theme.of(context).primaryColor,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 30),
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(100),
          //       ),
          //     ),
          //     child: GridView.count(
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 40,
          //       mainAxisSpacing: 30,
          //       children: [
          //         GestureDetector(
          //           onTap: () async {
          //             // final myDatabase = MyDatabase();
          //             // await myDatabase.openDb();
          //             // List<Order> orders = await myDatabase.getOrders();
          //             // // Process the orders as needed

          //             // if (mounted) {
          //             //   Navigator.pushAndRemoveUntil(
          //             //     context,
          //             //     MaterialPageRoute(
          //             //         builder: (context) => const CusOrders()),
          //             //     (route) => false,
          //             //   );
          //             // }
          //           },
          //           child: itemDashboard('Order Now',
          //               CupertinoIcons.play_rectangle, Colors.deepOrange),
          //         ),
          //         itemDashboard(
          //             'Orders', CupertinoIcons.graph_circle, Colors.green),
          //         itemDashboard(
          //             'Chats', CupertinoIcons.play_rectangle, Colors.purple),
          //         itemDashboard(
          //             'Delivery', CupertinoIcons.play_rectangle, Colors.brown),
          //       ],
          //     ),
          //   ),
          // ),
          ElevatedButton(
            onPressed: () async {
              final myDatabase = MyDatabase();
              await myDatabase.openDb();
              List<Order> orders = await myDatabase.getOrders();
              // final order = Order(
              //   cusName: nameController.text,
              //   cusAddress: addressController.text,
              //   contact: contactController.text,
              //   amount: amountController.text,
              //   producttype: _selectedProductType ?? '',
              //   payment: _selectedPayment ?? '',
              //   status: 'Pending',
              //   quantity: qtyController.text,
              //   orderDate: DateTime.now(),
              // );

              // final orders = await widget.myDatabase.getOrders();
              // orders.forEach((order) => print(order.orderDate));

              if (mounted) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   backgroundColor: Colors.green,
                //   content: Text('${myDatabase} confirm order.'),
                // ));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EployeeViewScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Employees'),
          ),

          ElevatedButton(
            onPressed: () async {
              final myDatabase = MyDatabase();
              await myDatabase.openDb();
              List<Order> orders = await myDatabase.getOrders();
              // final order = Order(
              //   cusName: nameController.text,
              //   cusAddress: addressController.text,
              //   contact: contactController.text,
              //   amount: amountController.text,
              //   producttype: _selectedProductType ?? '',
              //   payment: _selectedPayment ?? '',
              //   status: 'Pending',
              //   quantity: qtyController.text,
              //   orderDate: DateTime.now(),
              // );

              // final orders = await widget.myDatabase.getOrders();
              // orders.forEach((order) => print(order.orderDate));

              if (mounted) {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   backgroundColor: Colors.green,
                //   content: Text('${myDatabase} confirm order.'),
                // ));
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const salesReport()),
                  (route) => false,
                );
              }
            },
            child: const Text('Sales Report'),
          ),
        ],
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context).primaryColor.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5,
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: background, shape: BoxShape.circle),
              child: Icon(
                iconData,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
}
