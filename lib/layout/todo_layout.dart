import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/state_managment/states.dart';
import 'package:todo_app/modules/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/common/components.dart';
import 'package:todo_app/shared/imports/exports.dart';
import 'package:todo_app/shared/local/database_methods.dart';

import 'state_managment/cubit.dart';

import 'package:intl/intl.dart';


import 'package:sqflite/sqflite.dart';





class HomeLayout extends StatelessWidget {



  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AppCubit()..createDatabase(),
    child: BlocConsumer<AppCubit , AppStates>(
      listener: (context , state){
      },
      builder: (context , state){

        var cubit = AppCubit.get(context) ;

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title:Text(cubit.titles[cubit.currentIndex]),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeNavBarItem(index);
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(icon: Icon(
                Icons.menu,
              ),
                  label: 'Tasks'
              ),
              BottomNavigationBarItem(icon: Icon(
                Icons.check_circle_outline,
              ),
                  label: 'Done'
              ),
              BottomNavigationBarItem(icon: Icon(
                Icons.archive_outlined,
              ),
                  label: 'Archived'
              ),
            ],
          ),
          body: ConditionalBuilder(
            condition: state is! AppLoadingGetDataFromDatabaseState,
            builder: (context) => cubit.screens[cubit.currentIndex],
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              if(cubit.isBottomSheet)
                {
                    if(formKey.currentState!.validate())
                      {
                        cubit.insertDataToDatabase(title: titleController.text,
                            time: timeController.text
                            , date: dateController.text).then((value) {
                          Navigator.pop(context);
                          return null;
                        });
                      }
                }
              else {
                scaffoldKey.currentState!.showBottomSheet((context) => Container(
                  padding: EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultTextFormFeild(type: TextInputType.text,
                            prefxIcon: Icons.title,
                            validate: (value){
                              if(value!.isEmpty || value == " ")
                              {
                                return "you must enter title "  ;
                              }
                              return null;
                            },
                            editingController: titleController,
                            label: 'Title'),
                        SizedBox(height: 10.0,),
                        defaultTextFormFeild(
                            type: TextInputType.none,
                            prefxIcon: Icons.access_time_outlined,
                            editingController: timeController,
                            validate: (value){
                                if(value!.isEmpty){
                                  return "you must enter time" ;
                                }
                                return null;
                            },
                            onTap: (){
                            showTimePicker(context: context,
                                  initialTime: TimeOfDay.now()).then((value) {
                                    timeController.text = value!.format(context);
                                    return null;
                            });

                            },
                            label: 'Time'),
                        SizedBox(height: 10.0,),
                        defaultTextFormFeild(
                            type: TextInputType.none,
                            prefxIcon: Icons.calendar_today,
                            editingController: dateController,
                            validate: (value){
                              if(value!.isEmpty){
                                return "you must enter date" ;
                              }
                              return null;
                            },
                            onTap: (){
                              DateTime now = DateTime.now();
                              DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
                              showDatePicker(context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-08-30')).then((value) => {
                              dateController.text =
                              DateFormat.yMMMd()
                                  .format(value!)
                                  .toString()
                              });

                            },
                            label: 'Date')
                      ],
                    ),
                  ),
                ) ).closed.then((value) {
                  cubit.changeBottomSheet(false, Icons.edit);
                });
                cubit.changeBottomSheet(true, Icons.add);
              }

            },
            child: Icon(
                cubit.fabIcon
            ),
          ),
        );
      },
    ),
    );
  }



}
