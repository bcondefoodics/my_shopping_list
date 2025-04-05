import 'package:flutter/material.dart';

import '../models/grocery_item.dart';

class GroceryCardItem extends StatelessWidget {
  const GroceryCardItem({super.key, required this.model});

  final GroceryItem model;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(color: model.category.color, width: 20, height: 20),
        SizedBox(width: 20),
        Text(
          model.name,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        Spacer(),
        Text(model.quantity.toString()),
      ],
    );
  }
}
