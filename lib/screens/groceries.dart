import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shopping_list/data/categories.dart';
import 'package:my_shopping_list/models/grocery_item.dart';
import 'package:my_shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();

    _loadItems();
  }

  void _loadItems() async {
    List<GroceryItem> items = [];

    final Uri url = Uri.https(
      'my-flutter-shopping-list-default-rtdb.asia-southeast1.firebasedatabase.app',
      'shopping_list.json',
    );

    final response = await http.get(url);
    print(response.body);
    if (response.body == 'null') {
      setState(() {
        _groceryItems.addAll(items);
      });
      return;
    }
    final Map<String, dynamic> resData = json.decode(response.body);

    for (final data in resData.entries) {
      final dynamic value = data.value;
      final category = categories.entries.firstWhere((element) {
        return element.value.name == value['category'];
      });

      items.add(
        GroceryItem(
          id: data.key,
          name: value['name'],
          quantity: value['quantity'],
          category: category.value,
        ),
      );
    }
    setState(() {
      _groceryItems.addAll(items);
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item) {
    final Uri url = Uri.https(
      'my-flutter-shopping-list-default-rtdb.asia-southeast1.firebasedatabase.app',
      'shopping_list/${item.id}.json',
    );

    http.delete(url);

    setState(() {
      _groceryItems.removeWhere((obj) => item == obj);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        'No items added yet',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge!.copyWith(color: Colors.red),
      ),
    );

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) {
          final item = _groceryItems[index];
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _removeItem(_groceryItems[index]);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${item.name} deleted')));
            },
            child: ListTile(
              title: Text(item.name),
              leading: Container(
                width: 24,
                height: 24,
                color: item.category.color,
              ),
              trailing: Text(item.quantity.toString()),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
