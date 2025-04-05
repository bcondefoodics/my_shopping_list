import 'package:flutter/material.dart';

import '../data/dummy_items.dart';
import '../widgets/grocery_card_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Groceries')),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder:
            (ctx, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: GroceryCardItem(model: groceryItems[index]),
            ),
      ),
    );
  }
}
