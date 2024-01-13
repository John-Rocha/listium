import 'package:flutter/material.dart';
import '../models/listium.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Listium> listListiums = [
    Listium(id: 'L001', name: 'Feira de Outubro'),
    Listium(id: 'L002', name: 'Feira de Novembro'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listin - Feira Colaborativa'),
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
          : ListView.builder(
              itemCount: listListiums.length,
              itemBuilder: (context, index) {
                Listium model = listListiums[index];
                return ListTile(
                  leading: const Icon(Icons.list_alt_rounded),
                  title: Text(model.name),
                  subtitle: Text(model.id),
                );
              },
            ),
    );
  }

  showFormModal() {
    // Labels à serem mostradas no Modal
    String title = 'Adicionar Listin';
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
                    const InputDecoration(label: Text('Nome do Listin')),
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
                        //TODO: Implementar adição
                      },
                      child: Text(confirmationButton)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
