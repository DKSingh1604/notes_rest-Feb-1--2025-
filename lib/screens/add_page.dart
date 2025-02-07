// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({
    super.key,
    this.todo,
  });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
    }
    titleController.text = widget.todo!['title'];
    descriptionController.text = widget.todo!['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Title",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: isEdit ? updateData : submitData,
                  child: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You cannnot not call updated without todo data');
      return;
    }

    final id = todo['_id'];

    final body = {
      'title': titleController.text,
      'description': descriptionController.text,
      'is_completed': false,
    };

    //submit updated data to the sever
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or fail message based on status
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Data edited successfully");
      print(titleController.text);
      print(descriptionController.text);

      showSuccessMessage("Data edited successfully!");
    } else {
      print("Failed to edit data");
      print(response.body);
      showErrorMessage("${response.body}, Failed to edit data");
    }
  }

  //S U B M I T   D A T A    T O   T H E   S E R V E R
  Future<void> submitData() async {
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    //submit data to the sever
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    //show success or fail message based on status
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Data saved successfully");
      print(title);
      print(description);
      showSuccessMessage("Data saved successfully!");
    } else {
      print("Failed to save data");
      print(response.body);
      showErrorMessage("${response.body}, Failed to save data");
    }
  }

  //visual message of response
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.pop(context);
  }
}
