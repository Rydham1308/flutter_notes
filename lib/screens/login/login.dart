import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/constants/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/sp_keys.dart';
import '../../models/user_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  bool isObscureText = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //region -- Gradient 1
          Positioned(
            top: -300,
            left: -300,
            child: Container(
              height: 600,
              width: 600,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  stops: [0.0005, 0.8],
                  colors: [
                    Color(0xff3191FF),
                    Colors.transparent,
                  ],
                  radius: 0.5,
                ),
              ),
            ),
          ),
          //endregion

          //region -- Main Screen
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //region  --- Image
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: SvgPicture.asset(
                    'assets/images/Illustration.svg',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                //endregion

                const SizedBox(
                  height: 25,
                ),

                //region --- TextField & Button
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 52),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Email
                        const Text(
                          'Email',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextFormField(
                          controller: txtEmail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* Required";
                            } else if (txtEmail.text.isValidEmail == false) {
                              return "Email is not valid";
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Email',
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 73, 73, 73)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),

                        // Gap
                        const SizedBox(
                          height: 16,
                        ),

                        // Password
                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextFormField(
                          controller: txtPass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* Required";
                            } else if (txtPass.text.isValidPassword == false) {
                              return "Password should include at-least one Capital, Small, Number & Spacial Char.";
                            } else if (value.length < 6) {
                              return "Password should be at-least 6 characters";
                            } else if (value.length > 15) {
                              return "Password should not be greater than 15 characters";
                            } else {
                              return null;
                            }
                          },
                          obscureText: isObscureText,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorMaxLines: 3,
                            labelText: 'Enter Your Password',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 73, 73, 73)),
                            suffixIcon: isObscureText
                                ? IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureText = false;
                                      });
                                    },
                                    icon: const Icon(CupertinoIcons.eye_slash),
                                  )
                                : IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureText = true;
                                      });
                                    },
                                    icon: const Icon(CupertinoIcons.eye),
                                  ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),

                        // Gap
                        const SizedBox(
                          height: 8,
                        ),

                        // Forgot Pass
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                //endregion
              ],
            ),
          ),
          //endregion
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.165,
        child: Stack(
          children: [
            Positioned(
              left: -7,
              child: Container(
                height: 388,
                width: 388,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromARGB(255, 49, 145, 255),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    radius: 0.7,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      minimumSize: const Size(double.maxFinite, 48),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await login();
                      }
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don’t have an account yet?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final getEmail = await Navigator.pushNamed(
                              context, '/register',
                              arguments: txtPass.text);

                          setState(() {
                            if (getEmail != null) {
                              txtEmail.text = getEmail.toString();
                            }
                          });
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const RegisterScreen(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          'Register here',
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    var sp = await SharedPreferences.getInstance();
    List<dynamic>? userList =
        sp.getStringList(AppKeys.userListKey) as List<dynamic>;
    List<UserModel> mapList =
        userList.map((e) => UserModel.fromJson(jsonDecode(e))).toList();
    for (int i = 0; i < (userList.length); i++) {
      if (mapList[i].email == txtEmail.text.trim() &&
          mapList[i].pass == txtPass.text.trim()) {

        sp.setString(AppKeys.currentUserKey, (mapList[i].email ?? ''));
        isValid = true;
        break;
      }
    }
    if (isValid) {
      final currUser = '${sp.getString(AppKeys.currentUserKey)}';
      AppKeys.currUser = currUser;
      sp.setBool(AppKeys.keyLogin, true);
      Future.delayed(Duration.zero)
          .then((value) => Navigator.pushReplacementNamed(context, '/home'));
    } else {
      Future.delayed(Duration.zero).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xd52d2d2d),
            content: Text(
              "Invalid Email or Password!",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(milliseconds: 1000),
          ),
        ),
      );
    }
    List<String>? usersList = sp.getStringList(AppKeys.userListKey);
    if (kDebugMode) {
      print('userList :: $usersList');
    }
  }
}
