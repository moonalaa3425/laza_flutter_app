import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laza/add_review_screen.dart';
import 'package:laza/components/custom_appbar.dart';
import 'package:laza/components/laza_icons.dart';
import 'package:laza/extensions/context_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'components/colors.dart';

class ReviewsScreen extends StatelessWidget {
  final String productId; // عشان نجيب reviews لكل منتج
  const ReviewsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        context.bottomViewPadding == 0.0 ? 30.0 : context.bottomViewPadding;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.theme.appBarTheme.systemOverlayStyle!,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Reviews'),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('productId', isEqualTo: productId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final reviews = snapshot.data!.docs;
            return ListView.separated(
              padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
              itemCount: reviews.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 20.0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${reviews.length} Reviews',
                              style: context.bodyMediumW500),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 10.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddReviewScreen())),
                        child: const Row(
                          children: [
                            Icon(LazaIcons.edit_square, size: 18),
                            SizedBox(width: 5.0),
                            Text('Add Review'),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                final review = reviews[index - 1];
                return ListTile(
                  title: Text(review['title'] ?? 'No title'),
                  subtitle: Text(review['comment'] ?? 'No comment'),
                  trailing: Text('${review['rating'] ?? 0}/5'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
