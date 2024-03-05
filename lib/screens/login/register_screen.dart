import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/constants/validation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/sp_keys.dart';
import '../../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isObscureTextPass = true;
  bool isObscureTextRePass = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtConfPass = TextEditingController();
  TextEditingController txtFName = TextEditingController();
  TextEditingController txtLName = TextEditingController();

  // @override
  // void didChangeDependencies() {
  //  final getPass = ModalRoute.of(context)?.settings.arguments;
  //  if(getPass is String ){
  //    txtPass.text = getPass;
  //  }
  //   super.didChangeDependencies();
  // }

  UserModel addUser = UserModel();
  List<String> getUserList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: -300,
            left: -300,
            child: Container(
              height: 600,
              width: 600,
              decoration: const BoxDecoration(
                gradient: RadialGradient(stops: [
                  0.0005,
                  0.8
                ], colors: [
                  Color(0xff3191FF),
                  Colors.transparent,
                ], radius: 0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //region  --- Image
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: SvgPicture.asset(
                    'assets/images/Register_SVG.svg',
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
                        //Name & LastName
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: txtFName,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "* Required";
                                      } else if (value.isValidName) {
                                        return '* Invalid Name';
                                      } else {
                                        return null;
                                      }
                                    },
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: 'Enter Your Name',
                                      labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 73, 73, 73)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(width: 10,),
                            // Flexible(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       const Text(
                            //         'Last Name',
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //         ),
                            //       ),
                            //       TextFormField(
                            //         controller: txtLName,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "* Required";
                            //           } else {
                            //             return null;
                            //           }
                            //         },
                            //         style: const TextStyle(color: Colors.white),
                            //         decoration: const InputDecoration(
                            //           labelText: 'Enter Your Last Name',
                            //           labelStyle: TextStyle(
                            //               color:
                            //                   Color.fromARGB(255, 73, 73, 73)),
                            //           enabledBorder: UnderlineInputBorder(
                            //             borderSide:
                            //                 BorderSide(color: Colors.white),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),

                        // Gap
                        const SizedBox(
                          height: 16,
                        ),

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
                          obscureText: isObscureTextPass,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Enter Your Password',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 73, 73, 73)),
                            suffixIcon: isObscureTextPass
                                ? IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureTextPass = false;
                                      });
                                    },
                                    icon: const Icon(CupertinoIcons.eye_slash),
                                  )
                                : IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureTextPass = true;
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
                          height: 16,
                        ),

                        // Confirm Password
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextFormField(
                          controller: txtConfPass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "* Required";
                            } else if (txtPass.text.isValidPassword == false) {
                              return "Password should include at-least one Capital, Small, Number & Spacial Char.";
                            } else if (value.length < 6) {
                              return "Password should be at-least 6 characters";
                            } else if (value.length > 15) {
                              return "Password should not be greater than 15 characters";
                            } else if (txtConfPass.text != txtPass.text) {
                              return "Password doesn't match.";
                            } else {
                              return null;
                            }
                          },
                          obscureText: isObscureTextRePass,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Re-Enter Your Password',
                            labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 73, 73, 73)),
                            suffixIcon: isObscureTextRePass
                                ? IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureTextRePass = false;
                                      });
                                    },
                                    icon: const Icon(CupertinoIcons.eye_slash),
                                  )
                                : IconButton(
                                    color:
                                        const Color.fromARGB(255, 73, 73, 73),
                                    onPressed: () {
                                      setState(() {
                                        isObscureTextRePass = true;
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
                      ],
                    ),
                  ),
                ),
                //endregion
              ],
            ),
          ),
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
                        addUser.email = txtEmail.text.trim();
                        addUser.name = txtFName.text.trim();
                        addUser.pass = txtPass.text;
                        await register();
                        Future.delayed(Duration.zero)
                            .then((value) => Navigator.pop(context));
                        Future.delayed(Duration.zero).then(
                              (value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xd52d2d2d),
                                  content: Text("User Registered!",style: TextStyle(color: Colors.white),),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              ),
                        );
                      }
                    },
                    child: const Text(
                      'Register',
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
                        'Already have an account?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          // setState(() {
                          //
                          // });
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const Login(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          'Sign in',
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

  Future<void> register() async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(AppKeys.userKey, json.encode(addUser));
    final data = sp.getString(AppKeys.userKey);
    // print('Data:$data');
    final getList = sp.getStringList(AppKeys.userListKey) ?? [];
    // print('getListData $getList');
    if (getList.isEmpty) {
      getList.add(data ?? '');
      // print('getList$getList');
      sp.setStringList(AppKeys.userListKey, getList);
    } else {
      getUserList.add(data ?? '');
      getUserList.addAll(getList);
      sp.setStringList(AppKeys.userListKey, getUserList);
    }
    List<String>? userList = sp.getStringList(AppKeys.userListKey);
    if (kDebugMode) {
      print('userList :: $userList');
      print('userList :: ${sp.getString(AppKeys.json)}');
    }
  }
}
