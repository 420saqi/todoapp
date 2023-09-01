import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/db_provider.dart';
import 'package:todo/screens/add_new_note.dart';
import 'package:todo/screens/edit_existing_note.dart';

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
    final notesLength =
        Provider.of<DatabaseProvider>(context).listOfNotes.length;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.cyan.shade400,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Your Todos',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                "$notesLength Task",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: Consumer<DatabaseProvider>(
                  builder: (context, notes, child) => notes.listOfNotes.isEmpty
                      ? const Center(
                          child: Text(
                          'No Task yet! Start adding some',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ))
                      : ListView.builder(
                          itemCount: notes.listOfNotes.length,
                          itemBuilder: (context, index) {
                            final getPriority =
                                notes.listOfNotes[index]['priority'];
                            print(getPriority);
                            String setPriority;
                            if (getPriority == 'Priority.low') {
                              setPriority = 'Low';
                            } else if (getPriority == 'Priority.medium') {
                              setPriority = 'Medium';
                            } else {
                              setPriority = 'High';
                            }

                            return Card(
                              child: ListTile(
                                title: Text(
                                  notes.listOfNotes[index]['descriptionText'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      notes.listOfNotes[index]['date'],
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      setPriority,
                                      style:
                                          const TextStyle(color: Colors.teal),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        // edit notes
                                        print(
                                            "runtime type of priority::${notes.listOfNotes[index]['priority'].runtimeType}");
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              EditExistingNote(
                                            id: notes.listOfNotes[index]['id'],
                                            dateTime: notes.listOfNotes[index]
                                                ['date'],
                                            description:
                                                notes.listOfNotes[index]
                                                    ['descriptionText'],
                                            priority: notes.listOfNotes[index]
                                                ['priority'],
                                          ),
                                        ));
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        final id =
                                            notes.listOfNotes[index]['id'];
                                        notes.deleteNoteFromProvider(id);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
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
