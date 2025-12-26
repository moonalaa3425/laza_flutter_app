import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final cartItems = snapshot.data!.docs;
          if (cartItems.isEmpty)
            return const Center(child: Text('Your cart is empty'));
          double total = 0;
          for (var item in cartItems) total += item['price'] * item['quantity'];

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      leading:
                          Image.network(item['image'], width: 50, height: 50),
                      title: Text(item['name']),
                      subtitle: Text('Quantity: ${item['quantity']}'),
                      trailing: Text('\$${item['price'] * item['quantity']}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20)),
              ),
            ],
          );
        },
      ),
    );
  }
}
