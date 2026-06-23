import 'package:flutter/material.dart';
import 'package:kinza_apis/services/auth.dart';
import 'package:kinza_apis/views/auth/register.dart';
import 'package:kinza_apis/views/task/get_all_task.dart';
import 'package:provider/provider.dart';

import '../../provider/user_token_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Password",
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
                  await AuthServices()
                      .loginUser(
                      email: emailController.text,
                      password: passwordController.text)
                      .then((value)async{
                         userProvider.setToken(value.token!.toString());
                         await AuthServices().getProfile(
                           userProvider.getToken().toString()
                         ).then((val){
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
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=> GetAllTask()));
                                     }, child: Text("Ok"))
                                   ],
                                 );
                               }
                           );
                         });

                  });
                }catch(e){
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
          }, child: Text("Login")),
          TextButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
          }, child: Text("Register"))
        ],
      ),
    );
  }
}
