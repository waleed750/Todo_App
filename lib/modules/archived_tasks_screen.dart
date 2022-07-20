import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/state_managment/cubit.dart';
import 'package:todo_app/layout/state_managment/states.dart';
import 'package:todo_app/shared/common/components.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppStates>(
      listener: (context , state ) {

      },
      builder: (context , state ){
        var cubit = AppCubit.get(context);
        return cubit.archivedTasks.length > 0  ?
        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ListView.separated(
                  itemBuilder: (context, index) => defaultTaskItem(cubit.archivedTasks[index] ,context ),
                  separatorBuilder: (context , index ) => Container(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  itemCount: cubit.archivedTasks.length),
            ) : buildNoDataItem(icon: Icons.menu, text: 'no archived tasks , to show ');
      },);
  }
}
/*buildNoDataItem(icon: Icons.archive_outlined, text: 'no archived tasks , to show ');*/