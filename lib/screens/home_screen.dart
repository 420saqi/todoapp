
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/db_provider.dart';
import 'package:todo/screens/add_new_note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // to get all items into the listOfNotes from db..
    Provider.of<DatabaseProvider>(context, listen: false).mapDatabaseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: Consumer<DatabaseProvider>(
          builder: (context, notes, child) =>  ListView.builder(
            itemCount: notes.listOfNotes.length,
            itemBuilder: (context, index) {
              final getPriority = notes.listOfNotes[index]['priority'];
              print(getPriority);
              final setPriority;
              if(getPriority== 'Priority.low')
                {
                 setPriority = 'Low';
                }
              else if(getPriority== 'Priority.medium')
              {
                setPriority = 'Medium';
              }
              else
                {
                  setPriority = 'High';
                }
              return ListTile(
                title: Text(notes.listOfNotes[index]['descriptionText']),
                subtitle: Row(
                  children: [
                    Text(notes.listOfNotes[index]['date'],style: const TextStyle(
                      color: Colors.cyan
                    ),),
                    const SizedBox(width: 20,),

                    Text(setPriority,style: const TextStyle(
                      color: Colors.green
                    ),),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        final id = notes.listOfNotes[index]['id'];
                        notes.deleteNoteFromProvider(id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        // edit notes
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddNewNote(),
            ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
