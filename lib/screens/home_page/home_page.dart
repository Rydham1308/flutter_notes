import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/sp_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import 'bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String name = 'No Data';
  List<String> getTitleList = [];
  List<String> getDescList = [];
  int delIndex = 0;
  int editIndex = 0;
  bool isEdit = false;
  bool status = false;
  ToDoModel toDoModel = ToDoModel();
  int editId = 0;
  @override
  void initState() {
    super.initState();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        shadowColor: Colors.blue,
        elevation: 15,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard');
            },
            icon: const Icon(CupertinoIcons.person, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: getTitleList.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: getTitleList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: status,
                            side: const BorderSide(
                                color: Colors.white, width: 1.5),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            onChanged: (c) {
                              // status = true;
                              setState(() {
                                status = !status;
                              });
                            },
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                await getBottomModelSheet(
                                    getTitleList[index],
                                    getDescList[index],
                                    editId,
                                    true); // Sends the stored data to bottom sheet
                                isEdit = true;
                                editIndex = index;
                                // final data = await Navigator.pushNamed(
                                //     context, '/addScreen',
                                //     arguments: getNameList[
                                //         index]); // Sends the stored data to bottom sheet
                                // isEdit = true;
                                // editIndex = index;
                                // if (data is bool) {
                                //   editName();
                                // }
                              },
                              child: Card(
                                shadowColor: Colors.blue,
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getTitleList[index],
                                              overflow: TextOverflow.visible,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              getDescList[index],
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: GestureDetector(
                                          onTap: () {
                                            delIndex = index;
                                            setState(() {
                                              delName();
                                            });
                                          },
                                          child: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // This is for another Screen
          // final data = await Navigator.pushNamed(context, '/addScreen');
          // if (data is bool) {
          //   getName();
          // }
          await getBottomModelSheet(null, null,null, false);
        },
        backgroundColor: Colors.blue,
        tooltip: 'Add',
        splashColor: Colors.blue,
        elevation: 25,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  //#region -- Methods
  Future<void> getBottomModelSheet(
      String? titleValue, String? descValue,int? editId, bool isEditBool) async {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        context: context,
        builder: (context) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddSheet(titleValue, descValue,editId));
        }).then((value) {
      if (value ?? false) {
        isEditBool ? editName() : getName();
      }
    });
  }

  void editName() async {
    var sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(AppKeys.json);
    final json = jsonDecode(jsonString!);
    List<dynamic> userDataList = json[sp.getString(AppKeys.currentUserKey)];
    List<ToDoModel> dataList =
        userDataList.map((e) => ToDoModel.fromJson((e))).toList();
      // dataList[editIndex].status = false;
      setState(() {
        final getEditData = sp.getString(AppKeys.editData)??'';
        final editedData = jsonDecode(getEditData);
        dataList[editIndex].title = editedData.title;
        dataList[editIndex].description = editedData.description;
      });
      sp.setString(AppKeys.json, jsonEncode(json));
      // final dataList = jsonDecode(jsonList[editIndex]);
      // dataList['title'] =
      //     getName; // First Updates the data in getName list and then sets to key's value
  }

  void delName() async {
    var sp = await SharedPreferences.getInstance();
    final jsonString = sp.getString(AppKeys.json);
    final json = jsonDecode(jsonString!);
    List<dynamic> userDataList = json[sp.getString(AppKeys.currentUserKey)];
    setState(() {
      getTitleList.removeAt(delIndex);
      getDescList.removeAt(delIndex);
      userDataList.removeAt(delIndex);
      json[sp.getString(AppKeys.currentUserKey)] = userDataList;
      sp.setString(AppKeys.json, jsonEncode(json));
    });
  }

  void getName() async {
    var sp = await SharedPreferences.getInstance();

    String? currentUserEmail =
        '"${sp.getString(AppKeys.currentUserKey) ?? ''}"';
    final jsonString = sp.getString(AppKeys.json);
    print(jsonString);

    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      print(json);
      if (json.containsKey(sp.getString(AppKeys.currentUserKey))) {
        List<dynamic> userDataList = json[sp.getString(AppKeys.currentUserKey)];
        print(userDataList);
        List<ToDoModel> dataList =
            userDataList.map((e) => ToDoModel.fromJson((e))).toList();
        getTitleList.clear();
        getDescList.clear();
        for (int i = 0; i < userDataList.length; i++) {
          setState(() {
            final dataTitle = dataList[i].title;
            final dataDesc = dataList[i].description;
            getTitleList.add(dataTitle ?? '');
            getDescList.add(dataDesc ?? '');
          });
        }
      } else {
        json[currentUserEmail] = [];
        final userDataList = [];
        print(userDataList);
        List<ToDoModel> dataList =
            userDataList.map((e) => ToDoModel.fromJson((e))).toList();
        getTitleList.clear();
        getDescList.clear();
        for (int i = 0; i < userDataList.length; i++) {
          setState(() {
            final dataTitle = dataList[i].title;
            final dataDesc = dataList[i].description;
            getTitleList.add(dataTitle ?? '');
            getDescList.add(dataDesc ?? '');
          });
        }
      }
    } else {
      final json = {currentUserEmail: []};
      json[currentUserEmail] = [];
      sp.setString(AppKeys.json, json.toString());
    }
  }
//endregion
}
