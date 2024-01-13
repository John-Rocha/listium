import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/listium.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Listium> listListiums = [];
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void _salvaListium(String name, BuildContext context) {
    final listium = Listium(
      id: const Uuid().v1(),
      name: name,
      createdAt: DateTime.now(),
    );
    _firestore
        .collection('listiums')
        .doc(listium.id)
        .set(listium.toMap())
        .whenComplete(() => Navigator.of(context).pop());
    refresh();
  }

  Future<void> refresh() async {
    var tempList = <Listium>[];
    final snapshot = await _firestore.collection('listiums').get();
    for (var doc in snapshot.docs) {
      tempList.add(Listium.fromMap(doc.data()));
    }

    setState(() {
      listListiums = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listium - Feira Colaborativa'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFormModal();
        },
        child: const Icon(Icons.add),
      ),
      body: (listListiums.isEmpty)
          ? const Center(
              child: Text(
                'Nenhuma lista ainda.\nVamos criar a primeira?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                itemCount: listListiums.length,
                itemBuilder: (context, index) {
                  listListiums.sort(
                    (a, b) => b.createdAt.compareTo(a.createdAt),
                  );
                  Listium model = listListiums[index];
                  return ListTile(
                    leading: const Icon(Icons.list_alt_rounded),
                    title: Text(model.name),
                    subtitle: Text(model.id),
                  );
                },
              ),
            ),
    );
  }

  showFormModal() {
    // Labels à serem mostradas no Modal
    String title = 'Adicionar Listium';
    String confirmationButton = 'Salvar';
    String skipButton = 'Cancelar';

    // Controlador do campo que receberá o nome do Listin
    TextEditingController nameController = TextEditingController();

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,

      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(label: Text('Nome do Listium')),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _salvaListium(nameController.text, context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
