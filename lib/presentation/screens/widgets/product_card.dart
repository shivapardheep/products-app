import 'package:flutter/material.dart';
import 'package:test_app/core/data/models/products_serilize.dart';
import 'package:test_app/core/utils/navigation_function.dart';

import '../../../core/utils/app_color.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductSerialize product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        NavigationFun().navToProductDetailsScreen(context, product);
      },
      child: Ink(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.containerGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Hero(
                    tag: product.productId,
                    child: Image.network(
                      product.images,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: Ink(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "\$${product.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
