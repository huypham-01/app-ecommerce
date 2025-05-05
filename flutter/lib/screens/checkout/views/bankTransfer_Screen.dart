import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BankTransferScreen extends StatefulWidget {
  const BankTransferScreen({super.key});

  @override
  _BankTransferScreenState createState() => _BankTransferScreenState();
}

class _BankTransferScreenState extends State<BankTransferScreen> {
  final transactionIdController = TextEditingController();
  final amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác nhận thanh toán chuyển khoản"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: transactionIdController,
              decoration: const InputDecoration(labelText: "Mã giao dịch"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Số tiền đã chuyển"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Gửi yêu cầu xác minh thanh toán
                final response = await http.post(
                  Uri.parse('http://your-api-url.com/api/verify-payment'),
                  body: jsonEncode({
                    'transaction_id': transactionIdController.text,
                    'amount': double.parse(amountController.text),
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thanh toán thành công")),
                  );
                  Navigator.pop(context); // Quay lại màn hình trước
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thanh toán thất bại")),
                  );
                }
              },
              child: const Text("Xác nhận thanh toán"),
            ),
          ],
        ),
      ),
    );
  }
}
