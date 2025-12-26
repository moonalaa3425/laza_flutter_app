import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  void placeOrder(BuildContext context, String paymentMethod) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .get();

    if (cartSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    double total = 0;
    for (var item in cartSnapshot.docs) {
      total += item['price'] * item['quantity'];
    }

    final orderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc();

    final orderData = {
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Pending',
      'paymentMethod': paymentMethod,
      'total': total,
      'items': cartSnapshot.docs
          .map((doc) => {
                'productId': doc['productId'],
                'name': doc['name'],
                'price': doc['price'],
                'quantity': doc['quantity'],
                'image': doc['image'],
              })
          .toList(),
    };

    await orderRef.set(orderData);

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
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
                child: Column(
                  children: [
                    Text('Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => placeOrder(context, 'Cash'),
                          child: const Text('Pay Cash'),
                        ),
                        ElevatedButton(
                          onPressed: () => placeOrder(context, 'Visa'),
                          child: const Text('Pay Visa'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
