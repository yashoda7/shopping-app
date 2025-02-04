import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoppin_list/data/categories.dart';
import 'package:shoppin_list/models/category.dart';
// import 'package:shoppin_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'package:shoppin_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey=GlobalKey<FormState>();
  var enteredName='';
  var enteredQuantity=1;
  var _selectedCategory=categories[Categories.vegetables]!;
  void _savaItem() async {  // Make this an async function
  final isValid = _formKey.currentState!.validate();
  if (!isValid) {
    return; // Stop execution if the form is invalid
  }

  _formKey.currentState!.save();

  final url = Uri.https(
    'flutter-prep-b0bb1-default-rtdb.firebaseio.com', 
    '/shopping-list.json'
  );

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': enteredName,
        'quantity': enteredQuantity,
        'category': _selectedCategory.title,
      }),
    );

  final Map<String,dynamic> data= json.decode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successfully added item to Firebase
      print("Item added successfully!");

      if (context.mounted) {
        Navigator.of(context).pop( GroceryItem(id: data['name'], name: enteredName, quantity: enteredQuantity, category: _selectedCategory)); // Close the form after saving
      }
    } else {
      // Handle HTTP error
      print("Failed to add item: ${response.body}");
    }
  } catch (error) {
    // Handle network or Firebase rule errors
    print("Error: $error");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        // child: Text("the form"),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                ),
                validator: (value){
                  if(value ==null || value.isEmpty || value.trim()==1 || value.trim().length > 50){
                    return "must be between 1 and 50 characters";
                  }
                  return null;
                // return "Demo Item";
                },
                onSaved: (value){
                    enteredName=value!;
  
                },
              ),
              SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        label: Text("Quantity"),
                      ),
                      initialValue: enteredQuantity.toString(),
                      validator: (value){
                        if(value ==null || value.isEmpty || int.tryParse(value)==null || int.tryParse(value)! <= 0){
                          return "must be valid positive number";
                        }
                        return null;
                // return "Demo Item";
                },
                onSaved: (value){
                  enteredQuantity=int.parse(value!);
                },
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(
                      value:_selectedCategory,
                      items:[
                        for(final cat in categories.entries)
                          DropdownMenuItem(
                            value:cat.value,
                            child:Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: cat.value.color,
                                ),
                            const SizedBox(width: 6,),
                            Text(cat.value.title),
                      ]
                            ),
                          ),    
                      ], 
                      onChanged: (value){
                        // _savaItem();
                       if (value == null) return; // Ensure value is not null
                      setState(() {
                        _selectedCategory = value; // Correctly assign value
                      });
                    },
                    onSaved: (value){
                      _selectedCategory = value!; // Correctly assign value
                    }
                      ,),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                onPressed: (){
                  _formKey.currentState!.reset();
                }, 
                child: Text("Reset"),
                ),
                const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () {
                  // Add your code here to save the item to your database
                  _savaItem();
                  // ScaffoldMessenger.of(context).showSnackBar( SnackBar(content:Text( "saved sucessfully")));
                },
                child: const Text("Add item"),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}