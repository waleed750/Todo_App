import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/state_managment/cubit.dart';

Widget defaultButton ({
  required String text  ,
  required Function method ,
  double width = double.infinity ,
  Color BackgroundColor = Colors.blue ,


}) =>Container(
  width: width,
  height: 50.0,
  child: MaterialButton(onPressed: (){
    method();
  },
    child: Text(
      text ,
      style: TextStyle(
          color: Colors.white
      ),

    ),
  ),
  decoration: BoxDecoration(
    color: BackgroundColor,
    borderRadius: BorderRadius.circular(10.0),
  ),
);

Widget defaultTextFormFeild({
  required TextInputType type ,
  required TextEditingController editingController ,
  required String label ,
  IconData? prefxIcon,
  IconData? suffxIcon ,
  String? Function(String? value)? validate,
  VoidCallback? suffxFunc ,
  bool password = false ,
  void Function()? onTap ,
}) => TextFormField(
  keyboardType: type,
  obscureText: password,
  controller: editingController,
  validator: validate,
  onTap: onTap,
  decoration: InputDecoration(
      prefixIcon: Icon(
          prefxIcon
      ) ,
      suffixIcon: suffxIcon != null ?  IconButton(
        onPressed: suffxFunc,
        icon: Icon(
            suffxIcon
        ),
      ) : null,
      label: Text(label == null ? '' : label),
      border: OutlineInputBorder()
  ),
) ;

Widget buildNoDataItem({
  required IconData icon ,
  required String text ,
}) => Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon ,
        size: 100.0,
      ) ,
      Text(
        '${text}' ,
        style: TextStyle(
            color: Colors.black45
        ),
      )
    ],
  ),
);

Widget defaultTaskItem (Map model , context) {
  Widget backgroundDissmisble1  = Container(
    color: Colors.redAccent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 25.0,),
        const Text(
          'Delete' ,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold ,
            fontSize: 25.0
          ),
        ),
      ],
    ),
  );
  Widget backgroundDissmisble2  = Container(
    color: Colors.lightBlue,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delete' ,
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ],
    ),
  );
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Dismissible(
      background: backgroundDissmisble1,
      key: Key(model['id'].toString()),
      secondaryBackground:backgroundDissmisble2 ,
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
              AppCubit.get(context).deleteFromDatabase(model["id"]);
        }

      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
                '${model["time"]}'
            ),
          ),
          SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  '${model["title"]}',

                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  '${model["date"]}',
                  style: TextStyle(
                      color: Colors.grey
                  ),
                )
              ],
            ),
          ),
          IconButton(onPressed: () {
            var id = model["id"];

            AppCubit.get(context).updateDatabase(id: id, status: 'done');
          }, icon: const Icon(
            Icons.check_box,
            color: Colors.green,
            size: 25,
          )),
          IconButton(onPressed: () {
            var id = model["id"];
            AppCubit.get(context).updateDatabase(id: id, status: 'archived');
          }, icon: const Icon(
            Icons.archive_outlined,
            color: Colors.black,
            size: 25,
          )),


        ],
      ),
    ),
  );
}