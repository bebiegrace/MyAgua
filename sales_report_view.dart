import 'package:flutter/material.dart';

import '../order/database.dart';
import '../order/order_model.dart';

class salesReport extends StatefulWidget {
  const salesReport({Key? key}) : super(key: key);
  const salesReport._();

  @override
  State<salesReport> createState() => _salesReportPageState();
}

class _salesReportPageState extends State<salesReport> {
  bool isLoading = false;
  List<Order> orders = [];
  final MyDatabase _myDatabase = MyDatabase();
  int count = 0;
  double totalRevenue = 0.0;

  Future<void> getDataFromDb() async {
    setState(() {
      isLoading = true;
    });

    await _myDatabase.openDb();
    final List<Order> result = await _myDatabase.getOrders();
    orders.clear();
    orders.addAll(result);
    count = await _myDatabase.countEmp();
    calculateTotalRevenue();
    setState(() {
      isLoading = false;
    });
  }

  void calculateTotalRevenue() {
    totalRevenue = orders.fold<double>(
      0.0,
      (sum, order) => sum + double.parse(order.amount ?? '0.0'),
    );
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
        title: const Text('SUMMARY CUSTOMERS SALES REPORT'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Code\t\t\tName\t\t\tAmount',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  '${orders[index].orderId}\t\t${orders[index].cusName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${orders[index].amount}',
                ),
                onTap: () {
                  // Navigate to order details screen
                },
              ),
            ),
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'All Sales Revenue Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Php $totalRevenue',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
