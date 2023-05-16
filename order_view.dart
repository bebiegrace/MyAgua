import 'package:flutter/material.dart';

import '../order/database.dart';
import '../order/order_model.dart';

class CusOrders extends StatefulWidget {
  const CusOrders({Key? key}) : super(key: key);
  const CusOrders._();

  @override
  State<CusOrders> createState() => _CusOrdersPageState();
}

class _CusOrdersPageState extends State<CusOrders> {
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
      appBar: AppBar(
        title: Text('Orders ($count)'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text('No Orders yet'),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EditOrder(
                        //       order: orders[index],
                        //       myDatabase: _myDatabase,
                        //     ),
                        //   ),
                        // );
                      },
                      title: Text(
                        '${orders[index].cusName} (${orders[index].orderId})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      // subtitle: orders[index].cusAddress != null
                      //     ? Text(orders[index].cusAddress!)
                      //     : null,

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Details:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                              'Customer Address: ${orders[index].cusAddress ?? 'N/A'}'),
                          Text('Contact: ${orders[index].contact ?? 'N/A'}'),
                          Text('Amount: ${orders[index].amount ?? 'N/A'}'),
                          Text(
                              'Product Type: ${orders[index].producttype ?? 'N/A'}'),
                          Text('Payment: ${orders[index].payment ?? 'N/A'}'),
                          Text('Status: ${orders[index].status}'),
                          Text('Quantity: ${orders[index].quantity ?? 'N/A'}'),
                          const SizedBox(height: 4),
                          Text('Order Date: ${orders[index].orderDate}'),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          final empName = orders[index].cusName;
                          await _myDatabase.deleteOrder(orders[index].orderId!);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('$empName deleted.'),
                              ),
                            );
                            await getDataFromDb();
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddOrder(
      //             myDatabase: _myDatabase,
      //             onOrderAdded: () async {
      //               await getDataFromDb();
      //             }),
      //       ),
      //     );

      //     // ).then((value) async {
      //     //   if (value != null && value) {
      //     //     await getDataFromDb();
      //     //   }
      //     // });
      //   },
      // ),
    );
  }
}
