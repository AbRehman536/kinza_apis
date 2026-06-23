import 'package:flutter/material.dart';
import 'package:kinza_apis/services/task.dart';
import 'package:provider/provider.dart';

import '../../provider/user_token_provider.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          isLoading ? Center(child: CircularProgressIndicator(),)
              :ElevatedButton(onPressed: ()async{
                try{
                  isLoading = true;
                  setState(() {});
                  await TaskServices().createTask(
                      token: userProvider.getToken().toString(),
                      description: descriptionController.text)
                      .then((value){
                    isLoading = false;
                    setState(() {});
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Success"),
                                content: Text(value.message!),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }, child: Text("Ok"))
                                ],
                              );
                            });
                  });
                }catch(e){
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));

                }
          }, child: Text("Create Task"))
        ],
      ),
    );
  }
}
