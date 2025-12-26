import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCardsScreen extends StatelessWidget {
  const MyCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cards')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .doc(user!.uid)
            .collection('payments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final cards = snapshot.data!.docs;
          if (cards.isEmpty) return const Center(child: Text('No payment methods added'));
          return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return ListTile(
                leading: const Icon(Icons.credit_card),
                title: Text(card['method']),
                subtitle: Text(card['timestamp'] != null ? card['timestamp'].toDate().toString() : ''),
              );
            },
          );
        },
      ),
    );
  }
}