import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'data/local/db_helper.dart';


class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _homePage();

}
class _homePage extends State<HomePage>{

  TextEditingController titleController = TextEditingController();
  TextEditingController titleUpdateController = TextEditingController();
  TextEditingController descUpdateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  DbHelper? mainDb;
  List<Map<String,dynamic>>allNotes = [];

  @override
  void initState() {
    mainDb = DbHelper.getInstances;
    getAllNotes();
    super.initState();
  }

  void getAllNotes()async{
    allNotes = await mainDb!.getNote();
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Database Page")),),
      body: mainDb != null ? ListView.builder(
          itemCount: allNotes.length,
          itemBuilder: (_,Index){
            return ListTile(
              leading: CircleAvatar(
                child: Text('${allNotes[Index][DbHelper.tableNoteColSNo]}'),
              ),
              title: Text(allNotes[Index][DbHelper.tableNoteColTitle]),
              subtitle: Text(allNotes[Index][DbHelper.tableNoteColDesc]),
              trailing: SizedBox(
                width: 50,
                child: Row(
                  children: [
                    /*-----------Update-----------*/
                    InkWell(
                        onTap: (){

                          showModalBottomSheet(context: context, builder: (_){
                            titleController.text = allNotes[Index][DbHelper.tableNoteColTitle];
                            descController.text = allNotes[Index][DbHelper.tableNoteColDesc];
                            return Column(
                              children: [
                                Text("Update Note",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                SizedBox(height: 50,),

                                /*-----------Title-----------*/
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                        hintText: "Enter your updated title here...",
                                        labelText: "Title",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),

                                /*-----------Desc-----------*/
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 20),
                                  child: TextField(
                                    controller: descController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                        hintText: "Enter your updated description here..",
                                        labelText: "Description",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        )
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                /*-----------Buttons-----------*/
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      /*-----------Update-----------*/
                                      OutlinedButton(onPressed: (){
                                        updateInDb(s_no: allNotes[Index][DbHelper.tableNoteColSNo]);
                                        Navigator.pop(context);
                                      }, child: Text("Update")),
                                      /*-----------Cancel-----------*/
                                      OutlinedButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("Cancel")),
                                    ],
                                  ),
                                )
                              ],
                            );
                          });
                        },
                        child: Icon(Icons.edit,color: Colors.blue,)),
                    /*-----------Delete-----------*/
                    InkWell(
                        onTap: (){
                          mainDb!.removeNote(s_no: allNotes[Index][DbHelper.tableNoteColSNo]);
                          getAllNotes();
                          setState(() {

                          });
                        },
                        child: Icon(Icons.delete,color: Colors.red,)),
                  ],
                ),
              ),
            );
          }) : Text("No Notes Yet"),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           showModalBottomSheet(context: context, builder: (_){
             return Column(
               children: [
                 Text("Add Note",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                 SizedBox(height: 50,),

                 /*-----------Title-----------*/
                 Padding(
                   padding:  EdgeInsets.symmetric(horizontal: 20),
                   child: TextField(
                     controller: titleController,
                     decoration: InputDecoration(
                       hintText: "Enter your title here....",
                       labelText: "Title",
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(20),
                       )
                     ),
                   ),
                 ),
                 SizedBox(height: 30,),

                 /*-----------Desc-----------*/
                 Padding(
                   padding:  EdgeInsets.symmetric(horizontal: 20),
                   child: TextField(
                     controller: descController,
                     maxLines: 3,
                     decoration: InputDecoration(
                         hintText: "Enter your Description here...",
                         labelText: "Description",
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20),
                         )
                     ),
                   ),
                 ),
                 SizedBox(height: 30,),
                 /*-----------Buttons-----------*/
                 Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       /*-----------Add-----------*/
                       OutlinedButton(onPressed: (){
                         addNoteInDb();
                         titleController.clear();
                         descController.clear();
                         Navigator.pop(context);
                       }, child: Text("Add")),
                       /*-----------Cancel-----------*/
                       OutlinedButton(onPressed: (){
                         Navigator.pop(context);
                       }, child: Text("Cancel")),
                     ],
                   ),
                 )
               ],
             );
           });
        },
        child: Icon(Icons.add),
      ),
    );
  }
  void addNoteInDb()async{
    String mTitle = titleController.text.toString();
    String mDesc = descController.text.toString();
    bool check = await mainDb!.addNote(title: mTitle, desc: mDesc);
    getAllNotes();
    String msg = "Notes added successfully";
    if(!check){
      msg = "Notes added failed";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void updateInDb({required int s_no})async{
    String mTitle = titleController.text.toString();
    String mDesc = descController.text.toString();
    bool check = await mainDb!.updateNote(s_no: s_no, title: mTitle, desc: mDesc);
    getAllNotes();
    String msg = "Notes updated successfully";
    if(!check){
      msg = "Notes updated failed";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}