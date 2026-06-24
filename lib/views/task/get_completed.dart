import 'package:flutter/material.dart';
import 'package:kinza_apis/models/taskListing.dart';
import 'package:kinza_apis/services/task.dart';
import 'package:kinza_apis/views/task/create_task.dart';
import 'package:kinza_apis/views/task/update_task.dart';
import 'package:provider/provider.dart';

import '../../provider/user_token_provider.dart';

class GetCompletedTask extends StatelessWidget {
  const GetCompletedTask({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Completed Task"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureProvider.value(
        value: TaskServices().getCompletedTask(userProvider.getToken().toString()),
        initialData: TaskListingModel(),
        builder: (context, child){
          TaskListingModel taskListingModel =context.watch<TaskListingModel>();
          return ListView.builder(
            itemCount: taskListingModel.tasks!.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                        value: taskListingModel.tasks![index].complete ?? false,
                        onChanged: taskListingModel.tasks![index].complete == true ? null
                            : (value)async{
                          try{
                            await TaskServices().markTaskAsCompleted(
                                token: userProvider.getToken().toString(),
                                taskID: taskListingModel.tasks![index].id.toString());
                          }catch(e){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        }),
                    IconButton(onPressed: ()async{
                      try {
                        await TaskServices().deleteTask(
                            token: userProvider.getToken().toString(),
                            taskID: taskListingModel.tasks![index].id.toString()
                        );
                      }
                      catch(e){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }, icon: Icon(Icons.delete,color: Colors.red,)),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTask(model: taskListingModel.tasks![index])));
                    }, icon: Icon(Icons.edit,color: Colors.blue,))
                  ],
                ),
              );
            },);
        },

      ),
    );
  }
}
