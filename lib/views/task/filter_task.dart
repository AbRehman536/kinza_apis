import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kinza_apis/models/taskListing.dart';
import 'package:kinza_apis/provider/user_token_provider.dart';
import 'package:kinza_apis/services/task.dart';
import 'package:provider/provider.dart';

class FilterTask extends StatefulWidget {
  const FilterTask({super.key});

  @override
  State<FilterTask> createState() => _FilterTaskState();
}

class _FilterTaskState extends State<FilterTask> {
  TaskListingModel? taskListingModel;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Task"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now())
                .then((val){
                  setState(() {
                    startDate = val;
                  });
            });
          }, child: Text("Select Start Date")),
          if(startDate != null)
          Text(DateFormat.yMMMMEEEEd().format(startDate!)),
          ElevatedButton(onPressed: (){
            showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now())
                .then((val){
                  setState(() {
                    endDate = val;
                  });
            });
          }, child: Text("Select End Date")),
          if(endDate != null)
            Text(DateFormat.yMMMMEEEEd().format(endDate!)),
          ElevatedButton(onPressed: ()async{
            try{
              isLoading = true;
              taskListingModel = null;
              setState(() {});
              final start = startDate!.toUtc().toIso8601String();
              final end = endDate!.toUtc().toIso8601String();
              TaskListingModel filteredTask =
              await TaskServices().filterTask(
                  token: userProvider.getToken().toString(),
                  startDate: start,
                  endDate: end);
              isLoading = false;
              taskListingModel = filteredTask;
              setState(() {});
            }catch(e){
              isLoading = false;
              setState(() {});
              ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }, child: Text("Filter Task")),
          if(isLoading == true)
            Center(child: CircularProgressIndicator(),),
          if(taskListingModel == null)
            Center(
              child: Text("No Data Found"),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: taskListingModel!.tasks!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Icon(Icons.task),
                    title: Text(taskListingModel!.tasks![index].description.toString()),
                  );
                },),
            )

        ],
      ),
    );
  }
}
