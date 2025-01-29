import 'package:flutter/material.dart';
import 'package:shoppin_list/data/dummy_item.dart';
import 'package:shoppin_list/models/grocery_item.dart';
import 'package:shoppin_list/widgets/new_item.dart';

class GroceryList  extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  
  void _addItem() async{
    final newItem = await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (context) => const NewItem()));
    if(newItem == null)
      return;
    setState(() {
      _groceryItems.add(newItem);
    });
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
      body: _groceryItems.length>0 ? ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (context, index){
          return Dismissible(
            key: ValueKey(DateTime.now()),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient:LinearGradient(colors:  [Colors.deepPurple,Colors.teal]),
                ),
              child: ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _groceryItems[index].category.color,
                ),
                title: Text(_groceryItems[index].name),
                // trailing: Icon(Icons.delete),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                _groceryItems.removeAt(index);
              });
            }
          );
        },
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("no item selected yet")),
        ],
      )
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item added to the list')));
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}