import 'package:flutter/material.dart';
// import 'package:shoppin_list/data/dummy_item.dart';
import 'dart:convert';
import 'package:shoppin_list/models/grocery_item.dart';
import 'package:shoppin_list/widgets/new_item.dart';
import 'package:shoppin_list/data/categories.dart';
import 'package:http/http.dart' as http;

class GroceryList  extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
  //  final _isLoading = true;
   @override
  void initState() {
    super.initState();
    _loadItems();

  }
  void _loadItems() async {
     final url = Uri.https(
    'flutter-prep-b0bb1-default-rtdb.firebaseio.com', 
    '/shopping-list.json'
  );
     final response=await http.get(url);
  //    if(response.statusCode == 200){
  //      final Map<String,Map<String,dynamic>> data = json.decode(response.body);
  //       List<GroceryItem> _loadedItems=[];
  //      for(final item in data.entries)
  //       _loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity:item.value['quantity'], category:item.value['category']));
  //     //  setState(() => _groceryItems = _loadedItems
  //     //  );
  //     print(_loadedItems);
  //    } 
  // }
   final Map<String, dynamic> data = json.decode(response.body); // Corrected type
    List<GroceryItem> _loadedItems = [];

    for (final entry in data.entries) {
      _loadedItems.add(
        GroceryItem(
          id: entry.key,
          name: entry.value['name'],
          quantity: entry.value['quantity'],
          category:categories.entries.firstWhere((cat) => cat.value.title == entry.value['category']).value,
               // Convert category title back to a `Category`
        ),
      );
    }
    setState(() => _groceryItems = _loadedItems);
  }
  void _addItem() async{
    final newItem= await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(builder: (context) => const NewItem()));
    if(newItem!= null){
      setState(() => _groceryItems.add(newItem));
    }
    else return;
    // _loadItems();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient:LinearGradient(colors:  [Colors.deepPurple,Colors.teal]),
                  ),
                  // height: 28,
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    color: _groceryItems[index].category.color,
                    padding: EdgeInsets.all(8),
                  ),
                  title: Text(_groceryItems[index].name),
                  // trailing: Icon(Icons.delete),
                  trailing: Text(_groceryItems[index].quantity.toString()),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                _groceryItems.removeAt(index);
              });
            },

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