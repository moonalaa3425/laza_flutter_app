import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});
  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  String? selectedMethod;
  final user = FirebaseAuth.instance.currentUser;
  final paymentMethods = ['Visa', 'MasterCard', 'Cash On Delivery'];

  void savePayment() {
    if (selectedMethod == null) return;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('payments')
        .add({
      'method': selectedMethod,
      'timestamp': FieldValue.serverTimestamp()
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Payment method saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: paymentMethods.length,
        itemBuilder: (context, index) {
          final method = paymentMethods[index];
          return ListTile(
            title: Text(method),
            trailing: Radio<String>(
              value: method,
              groupValue: selectedMethod,
              onChanged: (value) => setState(() => selectedMethod = value),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: savePayment,
        child: const Icon(Icons.save),
      ),
    );
  }
}
