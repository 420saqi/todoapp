

import 'package:flutter/cupertino.dart';
import 'package:todo/db_helper/dbhelper.dart';


class DatabaseProvider with ChangeNotifier{
   List<Map<String,dynamic>> _listOfNotes=[];
  List<Map<String,dynamic>> get listOfNotes=> _listOfNotes;

  void mapDatabaseData()async{
    _listOfNotes = await DBHelper.fetchData();
    // print(_listOfNotes);
    notifyListeners();
  }

  void deleteNoteFromProvider(int id)async{
    final deletedId = await DBHelper.deleteFromDb(id);
    print('deleted item id : : : $deletedId');
    mapDatabaseData(); // to update the current list after deletion
    notifyListeners();
  }

  void editNote(int id, String newDesc,newDate,  newPriority)async{
    final updatedId = await DBHelper.updateNote(id, newDesc, newDate, newPriority);
    mapDatabaseData();
    print(' the id of updated note is :: $updatedId');
    notifyListeners();
  }

}