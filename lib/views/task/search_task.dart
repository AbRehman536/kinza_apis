import 'package:flutter/material.dart';
import 'package:kinza_apis/models/taskListing.dart';
import 'package:kinza_apis/provider/user_token_provider.dart';
import 'package:kinza_apis/services/task.dart';
import 'package:provider/provider.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  TextEditingController searchController = TextEditingController();
  TaskListingModel? taskListingModel;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Task"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hint: Text("Type here to search"),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value)async{
                  try{
                    isLoading = true;
                    taskListingModel = null;
                    setState(() {});
                    await TaskServices().searchTask(
                        token: userProvider.getToken().toString(),
                        searchTask: searchController.text)
                        .then((value){
                          isLoading = false;
                          taskListingModel = value;
                          setState(() {});
                    });
                  }catch(e){
                    isLoading = false;
                    setState(() {});
                    ScaffoldMessenger
                    .of(context).showSnackBar(
                      SnackBar(content: Text(e.toString()))
                    );
                  }
                },
              ),
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
        ),
      ),
    );
  }
}
