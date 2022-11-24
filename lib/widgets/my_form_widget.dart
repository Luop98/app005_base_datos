import 'package:app05_basedatos/db/db_admin.dart';
import 'package:app05_basedatos/models/task_model.dart';
import 'package:flutter/material.dart';

class MyformWidgets extends StatefulWidget {
  const MyformWidgets({Key? key}) : super(key: key);

  @override
  State<MyformWidgets> createState() => _MyformWidgetsState();
}

class _MyformWidgetsState extends State<MyformWidgets> {

  final _formKey = GlobalKey<FormState>();

  bool isFinished = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  addTask() {

    if(_formKey.currentState!.validate()){
 TaskModel taskModel = TaskModel(
      title: _titleController.text,
      description: _descriptionController.text,
      status: isFinished.toString(),
    );
    DBAdmin.db.insertTask(taskModel).then((value) {
      if(value > 0){
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                duration: const Duration(milliseconds: 1400),
                content: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Tarea registrada con éxito",
                    ),
                  ],
                ),
              ),
            );
          }
        });
   }

   
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
       key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Agregar tarea"),
            SizedBox(
              height: 6.0,
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(hintText: "Titulo"),
              validator: (String? value){
                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }
                if(value.length<6){
                  return "Debe de tener minino 6 caracteres";
                }

                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: InputDecoration(hintText: "Descripción"),
              validator: (String? value){
                if(value!.isEmpty){
                  return "El campo es obligatorio";
                }

                return null;
              },
            ),
            SizedBox(
              height: 6.0,
            ),
            Row(
              children: [
                Text("Estado: "),
                SizedBox(
                  width: 6.0,
                ),
                Checkbox(
                  value: isFinished,
                  onChanged: (value) {
                    isFinished = value!;
                    setState(() {});
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancelar",
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask();
                    
                  },
                  child: Text(
                    "Aceptar",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
