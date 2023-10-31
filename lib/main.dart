import 'package:lab_5/db/db_class.dart';
import 'package:lab_5/db/db_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(home: FirstScreen()));
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  DBProvider db = DBProvider.db;

  final _formKey = GlobalKey<FormState>();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  bool _agreement = false;

  Future<void> addResultDataOnClick() async {
    final weight = double.tryParse(_weight.text);
    final height = double.tryParse(_height.text);
    double? result = 0;

    if (weight != null && height != null) {
      result = weight / height;
    }
    Result saveResult = Result(weight: weight, height: height, result: result);
    await db.insertResult(saveResult);

    resetData();
    setState(() {});
  }

  Future<int> addResult(Result result) async {
    return await db.insertResult(result);
  }

  void resetData() {
    _weight.clear();
    _height.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Калькулятор'),
          leading: IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(),
                ),
              );
            },
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "Введите ваши параметры для вычисления ИМТ",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      const Text(
                        "вес",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      TextFormField(
                          controller: _weight,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return "Введите вес";
                            int? number = int.tryParse(value);

                            if (number == null || number <= 10) {
                              return 'Пожалуйста, введите число больше 10';
                            }
                            return null;
                          }),
                      const Text(
                        "рост",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      TextFormField(
                          controller: _height,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return "Введите рост";
                            int? number = int.tryParse(value);

                            if (number == null || number <= 50) {
                              return 'Пожалуйста, введите число больше 50';
                            }
                            return null;
                          }),
                      CheckboxListTile(
                          title: const Text("Согласие на обработку данных"),
                          value: _agreement,
                          onChanged: (bool? value) {
                            setState(() {
                              _agreement = value!;
                            });
                          }),
                      ElevatedButton(
                          child: const Text("Проверить"),
                          onPressed: () {
                            if (_agreement) {
                              if (_formKey.currentState!.validate()) {
                                addResultDataOnClick();
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ошибка'),
                                  content: const Text(
                                      'Пожалуйста, поставьте согласие на обработку данных'),
                                  actions: [
                                    TextButton(
                                      child: const Text('ОК'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ))));
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<Map<String, dynamic>> _journals = [];
  DBProvider db = DBProvider.db;
  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await db?.getItems();
    setState(() {
      _journals = data!;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Результаты расчетов'),
        ),
        body: (_isLoading)
            ? const Text("isLoading")
            : ListView.builder(
                itemCount: _journals.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.orange[200],
                  margin: const EdgeInsets.all(15),
                  child: ListTile(
                    title: Text(_journals[index]['weight']),
                    subtitle: Text(_journals[index]['height']),
                    trailing: Text(_journals[index]['result']),
                  ),
                ),
              ));
  }
}
