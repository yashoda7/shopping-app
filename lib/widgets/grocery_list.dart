import 'package:flutter/material.dart';
import 'package:shoppin_list/data/dummy_item.dart';
import 'package:shoppin_list/widgets/new_item.dart';

class GroceryList  extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewItem()));
}

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addItem();
            },
          ),
        ]
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: groceryItems[index].category.color,
            ),
            title: Text(groceryItems[index].name),
            // trailing: Icon(Icons.delete),
            trailing: Text(groceryItems[index].quantity.toString()),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item added to the list')));
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}