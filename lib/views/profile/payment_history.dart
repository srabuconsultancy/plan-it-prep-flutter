import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({
    super.key,
  });
  Color _getStatusColor(String status) {
    if (status == 'S') {
      return Colors.green; // Green for successful payments
    } else {
      return Colors.red; // Red for failed payments
    }
  }

  @override
  Widget build(BuildContext context) {
    UserService userService = Get.find();
    return PopScope(
      canPop: false, // Prevent default pop
      onPopInvokedWithResult: (didPop, result) {
        // No action needed, as back navigation is blocked
      },
      child: Scaffold(
        appBar: AppBarWidget(
          height: 80,
          onTap: () {
            Get.back(canPop: true);
          },
          title: "Payment History",
        ),
        body: userService.myPaymentTransactions.value.isEmpty
            ? SizedBox(
                height: Get.height * 0.8,
                width: Get.width,
                child: "No payments made.".text.make().centered(),
              )
            : ListView.builder(
                itemCount: userService.myPaymentTransactions.value.length,
                itemBuilder: (context, index) {
                  final payment = userService.myPaymentTransactions.value[index];
                  /*return ListTile(
              title: Text(payment.createdAt.toString()),
              subtitle: Text('Amount: ₹${payment.price}'),
              trailing: Text(
                payment.status == "P"
                    ? "Pending"
                    : payment.status == "S"
                        ? "Success"
                        : "Failed",
              ),
            );*/
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getStatusColor(payment.status),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      title: Text(
                        'Amount: ₹${payment.price}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(payment.createdAt.toLocal()),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            payment.status == 'S'
                                ? Icons.check_circle
                                : payment.status == "P"
                                    ? Icons.hourglass_top_outlined
                                    : Icons.cancel,
                            color: Colors.white,
                          ),
                          (payment.status == "P"
                                  ? "Pending"
                                  : payment.status == "S"
                                      ? "Success"
                                      : "Failed")
                              .text
                              .white
                              .make(),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      );
      
  }
}
