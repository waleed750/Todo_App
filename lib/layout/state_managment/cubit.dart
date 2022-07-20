import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/state_managment/states.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/imports/exports.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context) ;

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen() ,
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks'
  ];
  int currentIndex = 0;

  late Database database ;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  var isBottomSheet = false ;
  var fabIcon = Icons.edit;

  void changeNavBarItem(int index)
  {
      currentIndex = index ;
      emit(AppChangeNavBarItem());
  }
  void createDatabase () async
  {
    database = await openDatabase('todo.db' ,
        version: 1 ,
        onCreate: (database ,version) async{

          await database.execute(' CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT)').then((value) {
            print('database created ');
            emit(AppCreateDatabaseState());

          }).catchError((onError) {

            print('Error on Creating Database : ${onError.toString()}');
          });
        },
        onOpen: (database){
          emit(AppOpenDatabaseState());
          getDataFromDatabase(database);
        }

    );

  }

  void getDataFromDatabase (Database database)
  {
    newTasks = [] ;
    doneTasks =[];
    archivedTasks  = [] ;
    emit(AppLoadingGetDataFromDatabaseState());
    database.rawQuery('select * from tasks').then((value) {
      //watch data from database
      print("Data from Databasse : $value");
      value.forEach((element) {
      if(element['status'] == "new")
        newTasks.add(element);
      else if (element['status'] == 'done')
        doneTasks.add(element);
      else
        archivedTasks.add(element);
      });

      emit(AppGetDataFromDatabaseState());

    });
  }

  void updateDatabase({
     required int id ,
     required String status
}){
     database.rawUpdate('update tasks set status = ? where id = ?' ,
      [status, id]
     ).then((value) {

       emit(AppUpdateDatabaseState());
       getDataFromDatabase(database);
     }).catchError((onError){
       print("On update Error : ${onError.toString()}");
     });
  }
  void deleteFromDatabase (int id){
      database.rawDelete('delete from tasks where id = ${id}').then((value) {
        getDataFromDatabase(database);
        emit(AppDeleteDataFromDatabaseState());
      });
  }

    Future insertDataToDatabase({
  required String title ,
  required String time ,
  required String date ,
}){
    return database.transaction((txn) async{
            txn.rawInsert('Insert into tasks(title,date,time,status) values (? , ? , ? , "new")' ,
              [title , date , time] ,
            ).then((value) {
              emit(AppInsertDataIntoDatabaseState());
              getDataFromDatabase(database);
            })
                .catchError((onError){
              print("Insert Error : ${onError.toString()}");

            });
          });
  }


  void changeBottomSheet(bool bottomSheetClosed , IconData icon)
  {
    isBottomSheet = !isBottomSheet;
    fabIcon = icon ;
    emit(AppBottomSheetChanged());

  }
}