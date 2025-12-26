import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laza/extensions/context_extension.dart';
import '../models/product.dart';
import '../theme.dart';
import 'colors.dart';
import 'laza_icons.dart';
import '../product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final productModel = Product.fromFirestore(
      product.data() as Map<String, dynamic>,
      product.id,
    );

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsScreen(product: productModel),
          ),
        );
      },
      child: Ink(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(productModel.thumbnailPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      productModel.title,
                      style: context.bodyExtraSmallW500
                          ?.copyWith(overflow: TextOverflow.ellipsis),
                      maxLines: 4,
                    ),
                  ),
                  Text(productModel.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
