import 'package:app05_basedatos/db/db_admin.dart';
import 'package:app05_basedatos/models/task_model.dart';
import 'package:app05_basedatos/widgets/my_form_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async {
    return "Juan Manuel";
  }

  showDialoForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyformWidgets(
          taskModel: TaskModel,
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

 deleteTask(int taskId){
    DBAdmin.db.deleteTask(taskId).then((value){
      if(value > 0){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.indigo,
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white,),
                SizedBox(width: 10.0,),
                Text("Tarea eliminada"),
              ],
            ),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    DBAdmin.db.getTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialoForm();
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: DBAdmin.db.getTasks(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            List<TaskModel> myTasks = snap.data;
            return ListView.builder(
              itemCount: myTasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  /*confirmDismiss: (DismissDirection direction) async {
                    print(direction);
                    return true;
                  },*/

                  direction: DismissDirection.startToEnd,
                  background: Container(color: Colors.redAccent),
                  //secondaryBackground: Text("HOLA 2"),
                  onDismissed: (DismissDirection direction) {
                   deleteTask(myTasks[index].id!);



                    print("Elemento eliminado");
                  },
                  child: ListTile(
                    title: Text(myTasks[index].title),
                    subtitle: Text(myTasks[index].description),
                    trailing: IconButton(
                       onPressed:(){
                        showDialoForm();
                    },
                    icon: Icon(Icons.edit),
                    ),
                   
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
