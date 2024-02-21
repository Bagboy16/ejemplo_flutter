import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/todo.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List<Todo>> fetchData() async {
  String url = 'https://jsonplaceholder.typicode.com/todos';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<Todo> todos = data.map((item) => Todo.fromJson(item)).toList();
    return todos;
  }
  return [];
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consulta HTTP'),
        ),
        body: Center(
          child: Column(children: [
            ElevatedButton(
              onPressed: () {
                fetchData().then((value) => {
                  setState(() {
                    items = value.map((e) => e.title.toString()).toList();
                  })
                });
              },
              child: const Text('Consultar'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemContainer(text: items[index]);
                  }),
            ),
            // Mostrar resultado
          ]),
        ));
  }
}

class ItemContainer extends StatelessWidget {
  const ItemContainer({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 33,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
