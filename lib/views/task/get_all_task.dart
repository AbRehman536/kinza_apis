import 'package:flutter/material.dart';
import 'package:kinza_apis/models/taskListing.dart';
import 'package:kinza_apis/services/task.dart';
import 'package:kinza_apis/views/task/create_task.dart';
import 'package:provider/provider.dart';

import '../../provider/user_token_provider.dart';

class GetAllTask extends StatelessWidget {
  const GetAllTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateTask()));
      },child: Icon(Icons.add),),
      body: FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: TaskListingModel(),
          builder: (context, child){
            TaskListingModel taskListingModel =context.watch<TaskListingModel>();
            return ListView.builder(
              itemCount: taskListingModel.tasks!.length,
              itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
              );
            },);
          },

      ),
    );
  }
}
