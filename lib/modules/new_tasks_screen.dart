import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/state_managment/cubit.dart';
import 'package:todo_app/layout/state_managment/states.dart';
import 'package:todo_app/shared/common/components.dart';
import 'package:todo_app/shared/imports/exports.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
        listener: (context , state){
        },
        builder: (context , state){
          return   AppCubit.get(context).newTasks.length != 0  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ListView.separated(
                    itemBuilder: (context, index) => defaultTaskItem(AppCubit.get(context).newTasks[index] , context),
                    separatorBuilder: (context , index ) => Container(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    itemCount: AppCubit.get(context).newTasks.length),
              ) : buildNoDataItem(icon: Icons.menu, text: 'no new tasks , to show ');
        },
    );
  }
}

/*
* buildNoDataItem(icon: Icons.menu, text: 'no new tasks , to show ')*/

