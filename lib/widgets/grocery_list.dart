import 'package:flutter/material.dart';
import 'package:shoppin_list/data/dummy_item.dart';

class GroceryList  extends StatelessWidget{
  const GroceryList({super.key});
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
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