import 'package:flutter/material.dart';
import 'package:intern_go/auth/login_page.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

class Resetpasssword extends StatefulWidget {
  const Resetpasssword({super.key});

  @override
  State<Resetpasssword> createState() => _ResetpassswordState();
}

class _ResetpassswordState extends State<Resetpasssword> {
  TextEditingController emailController =TextEditingController();

  Widget buildModernTextField({
  required TextEditingController controller,
  required String hintText,
  required IconData icon,
  required bool obscureText,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    ),
  );
}


   customTextfield( TextEditingController controller, 
     String text, IconData icon, bool tohide){
       return Padding(
         padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20),
         child: TextField(
            controller: controller,
            obscureText: tohide,
              style: TextStyle(color: Colors.blue),
            decoration: InputDecoration(
              hintText: text,
              hintStyle: TextStyle(color: Colors.blue), // 👈 Optional: hint text color
        suffixIcon: Icon(icon, color: Colors.blue),
               border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(25)
          )
                          ),
                     ),
       );

     }     


      static customButton(VoidCallback voidCallBack, String text){
           return SizedBox(height: 30,width: 200,child: ElevatedButton(onPressed: (){
            voidCallBack();
           },style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
           ), child: Text(text, style: TextStyle(color: Colors.blue),)),
           );
           }

           static customALertBox(BuildContext context, String text){
      return showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: Text(text),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("ok") )
          ],
        );
      });
     }


   PreferredSizeWidget buildModernAppBar(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.6),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF00BCD4), // cyan
                        Color(0xFF2196F3), // blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  "Intern Go AI",
                  style: TextStyle(
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          
          ),
        ),
      ),
    ),
  );
}
  forgotPassword(String email){
    if(email==""){
      return customALertBox(context,"Enter Email");
    }
    else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar:buildModernAppBar(context),
           body: Center(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Reset Password 🔐",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildModernTextField(
                    controller: emailController,
                    hintText: "Enter your registered email",
                    icon: Icons.email_outlined,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  customButton(() {
                    forgotPassword(emailController.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password reset link has been sent to your email."),
                        backgroundColor: Colors.blueAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }, "Send Reset Link"),
                  const SizedBox(height: 10),
                  customButton(() {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => LogInPage()));
                  }, "Login with New Password"),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "Make sure to check your spam or promotions folder 📩",
          style: TextStyle(fontSize: 13, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  ),
),






    );
  }
}