import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Enter Email";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _passController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                  return "Please Enter Password";
                }
                return null;
              },
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              height: 55,
              child: ElevatedButton(
                  onPressed: ()async{
                   try{
                     await authProvider.signin(_emailController.text, _passController.text);
                     Fluttertoast.showToast(msg: "Login Success");
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                   }
                   catch(e){
                     print(e);
                   }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFF3876FD),
                    foregroundColor: Colors.white,
                  ),
                  child:Text('Log In',
                  style: TextStyle(fontSize: 18,),
                  ),
              ),
            ),
            SizedBox(height: 20,),
            Text("OR"),
            SizedBox(height: 10,),
            TextButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignupScreen()));
            }, child: Text("Create Account",style:
              TextStyle(color: Color(0XFF3876FD),fontWeight: FontWeight.bold,fontSize: 16),

              )),
          ],
        ),
      ),
    );
  }
}
