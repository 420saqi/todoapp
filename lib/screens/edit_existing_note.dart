
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/db_provider.dart';

import '../enums.dart';


class EditExistingNote extends StatefulWidget {
  const EditExistingNote({
    super.key,
    required this.id,
    required this.dateTime,
    required this.priority,
    required this.description,
  });

  final int id;
  final String description;
  final String dateTime;
  final String priority;

  @override
  State<EditExistingNote> createState() => _EditExistingNoteState();
}

class _EditExistingNoteState extends State<EditExistingNote> {
  final _desController = TextEditingController();

  final _dateController = TextEditingController();

  Priority _selectedPriority = Priority.low;

  @override
  initState(){
    _desController.text = widget.description;
    _dateController.text = widget.dateTime;
    // print("runtime type :: ${widget.priority.runtimeType}");
    if(widget.priority == 'Priority.low')
      {
    _selectedPriority = Priority.low;
      }
    else  if(widget.priority == 'Priority.medium')
    {
      _selectedPriority = Priority.medium;
    }
    else  if(widget.priority == 'Priority.high')
    {
      _selectedPriority = Priority.high;
    }
    else
      {
        _selectedPriority = Priority.low;
      }
    super.initState();
  }



  // dispose controller in dispose
  // Future<void> insertNote() async {
  //   final id = await DBHelper.insertNoteToDb(
  //     _desController.text.toString(),
  //     _dateController.text.toString(),
  //     _selectedPriority,
  //   );
  //   Timer(
  //     const Duration(seconds: 0),
  //     () {
  //       Provider.of<DatabaseProvider>(context, listen: false).mapDatabaseData();
  //     },
  //   );

  //   print('id of the inserted row :: $id');
  // }

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
    final provider = Provider.of<DatabaseProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan,
        appBar: AppBar(
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 100,left: 10,right: 10),
          child: Card(
            elevation: 10,
            child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(height: 20,),
                  const Center(
                    child: Text('Edit Note',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),),
                  ),
                  const SizedBox(height: 15,),
                  TextField(
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    controller: _desController,
                    decoration: const InputDecoration(
                        labelText: 'Enter notes description',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
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
                        provider.editNote(widget.id,
                            _desController.text,
                            _dateController.text,
                            _selectedPriority.toString(),
                        );
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
