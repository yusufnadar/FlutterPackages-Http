import 'package:flutter/material.dart';
import 'package:flutter_packages/models/todo_model.dart';
import 'package:flutter_packages/service/todo_service.dart';

class HttpPage extends StatefulWidget {
  const HttpPage({Key? key}) : super(key: key);

  @override
  _HttpPageState createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {


  var liste = <TodoModel>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Package'),
        actions: [
          IconButton(
              onPressed: () {
                TodoModel todoModel =
                    TodoModel(userId: 1, title: 'yeni veri', completed: false);
                TodoService.postTodo(todoModel);
              },
              icon: const Icon(Icons.add_circle))
        ],
      ),
      body: FutureBuilder<List<TodoModel>?>(
          future: TodoService.getTodos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Bu liste boş'),
                );
              } else {
                WidgetsBinding.instance!.addPostFrameCallback((_){
                  setState(() {
                    liste = snapshot.data!;
                  });
                });
                return ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    var todo = snapshot.data![index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            todo.id.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(todo.title!)),
                          ElevatedButton(
                            onPressed: () {
                              TodoModel todoModel = TodoModel();
                              todoModel.title = 'veri';
                              todoModel.id = todo.id;
                              TodoService.patchTodo(todoModel);
                            },
                            child: const Text('Patch'),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () {
                              TodoModel todoModel = TodoModel();
                              todoModel.title = 'veri';
                              todoModel.completed = true;
                              todoModel.userId = 2;
                              todoModel.id = todo.id;
                              TodoService.putTodo(todoModel);
                            },
                            child: const Text('Put'),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: () async{
                              var result = await TodoService.deleteTodo(todo.id);
                              if(result){
                               setState(() {
                                 liste.removeAt(0);
                               });
                              }else{
                                print('hatalı');
                              }
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
          }),
    );
  }
}
