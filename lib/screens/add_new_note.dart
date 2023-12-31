import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/db_helper/dbhelper.dart';
import 'package:todo/provider/db_provider.dart';

import '../enums.dart';



class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  final _desController = TextEditingController();

  final _dateController = TextEditingController();

  Priority _selectedPriority = Priority.low;

  // dispose controller in dispose
  Future<void> insertNote() async {
    final context = this.context;

    final cleanedDescription = _desController.text.trim();

    final id = await DBHelper.insertNoteToDb(
      cleanedDescription,
      _dateController.text.toString(),
      _selectedPriority.toString(),
    );
    Timer(const Duration(seconds: 0),() {
    Provider.of<DatabaseProvider>(context, listen: false).mapDatabaseData();
    },);

    print('id of the inserted row :: $id');
  }

  String priorityString(Priority value) {
    if (value == Priority.low) {
      return 'Low';
    } else if (value == Priority.medium) {
      return 'Medium';
    } else if (value == Priority.high) {
      return 'High';
    } else {
      return '';
    }
  }

  void _showDatePicker(BuildContext context) async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    );
    if (dateTime != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      _dateController.text = formattedDate.toString();
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan.shade500,
        appBar: AppBar(
          backgroundColor: Colors.cyan.shade500,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100,left: 10,right: 10),
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
              vertical: 10
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Center(
                    child: Text('Add Note',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),),
                  ),

                  const SizedBox(height: 20,),

                   Padding(
                     padding: EdgeInsets.all(2),
                     child: TextField(
                       maxLines: null,
                       textInputAction: TextInputAction.newline,
                       controller: _desController,
                       decoration: const InputDecoration(
                           labelText: 'Enter notes description',
                       ),
                     ),
                   ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: AbsorbPointer // avoid user not to type into field
                        (
                      child: TextField(
                        readOnly: true,
                        controller: _dateController,
                        decoration: const InputDecoration(
                            labelText: 'Click to choose Date',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<Priority>(
                    value: _selectedPriority, // default value
                    items: Priority.values.map((itemValue) {
                      return DropdownMenuItem<Priority>(
                        value: itemValue,
                        child: Text(priorityString(itemValue)),
                      );
                    }).toList(),

                    onChanged: (newValue) {
                      _selectedPriority = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () async {
                        if (_desController.text.isEmpty ||
                            _dateController.text.isEmpty) {
                          return;
                        }
                        insertNote();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green
                      ),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
