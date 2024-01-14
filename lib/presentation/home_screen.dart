import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listium/core/helpers/date_format_utils.dart';
import 'package:listium/presentation/produto_screen.dart';
import 'package:listium/widgets/flush_bars.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _salvaListium(String name, BuildContext context, Listium? model) {
    setState(() {
      _isLoading = true;
    });
    Listium listium = Listium(
      id: const Uuid().v1(),
      name: name,
      createdAt: DateTime.now(),
    );

    // User o ID do model
    if (model != null) {
      listium = model.copyWith(
        name: name,
        updatedAt: DateTime.now(),
      );
    }
    _firestore
        .collection('listiums')
        .doc(listium.id)
        .set(listium.toMap())
        .whenComplete(() {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
      _refresh();
    });
  }

  Future<void> _refresh() async {
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
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: listListiums.length,
                itemBuilder: (context, index) {
                  listListiums.sort(
                    (a, b) => b.createdAt.compareTo(a.createdAt),
                  );
                  Listium model = listListiums[index];
                  return Dismissible(
                    key: ValueKey<Listium>(model),
                    background: Container(
                      padding: const EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      final temp = listListiums.removeAt(index);
                      FlushBars.undo(
                        message: 'Você está prestes a excluir ${temp.name}',
                        onUndo: () {
                          _salvaListium(temp.name, context, model);
                          listListiums.insert(index, temp);
                          setState(() {});
                        },
                        duration: const Duration(seconds: 4),
                      ).show(context);

                      _removeListium(direction, model);
                    },
                    child: ListTile(
                      leading: const Icon(Icons.list_alt_rounded),
                      title: Text(model.name),
                      subtitle: Text(
                        'Criado em: ${DateFormatUtils.formatDateFromISO8601ToString(
                          model.createdAt.toIso8601String(),
                        )}',
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProdutoScreen(
                              listium: model,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showFormModal(model: model);
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _removeListium(DismissDirection direction, Listium model) {
    if (direction == DismissDirection.endToStart) {
      _firestore
          .collection('listiums')
          .doc(model.id)
          .delete()
          .whenComplete(() => _refresh());
    }
  }

  showFormModal({Listium? model}) {
    // Labels à serem mostradas no Modal
    String title = 'Adicionar Listium';
    String confirmationButton = 'Salvar';
    String skipButton = 'Cancelar';

    // Controlador do campo que receberá o nome do Listin
    TextEditingController nameController = TextEditingController();

    // Caso esteja editando um Listium, preenche o campo com o nome atual

    if (model != null) {
      title = 'Editando ${model.name}';
      nameController.text = model.name;
    }

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
                    onPressed: _isLoading
                        ? null
                        : () {
                            _salvaListium(nameController.text, context, model);
                          },
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(confirmationButton),
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
