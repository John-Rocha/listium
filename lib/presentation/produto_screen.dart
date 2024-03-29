import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:listium/core/helpers/enum_ordem_produto.dart';
import 'package:listium/models/listium.dart';
import 'package:listium/models/produto.dart';
import 'package:listium/widgets/list_tile_produto.dart';
import 'package:uuid/uuid.dart';

class ProdutoScreen extends StatefulWidget {
  final Listium listium;
  const ProdutoScreen({super.key, required this.listium});

  @override
  State<ProdutoScreen> createState() => _ProdutoScreenState();
}

class _ProdutoScreenState extends State<ProdutoScreen> {
  final _firestore = FirebaseFirestore.instance;

  List<Produto> listaProdutosPlanejados = [];
  List<Produto> listaProdutosPegos = [];

  OrdemProduto ordem = OrdemProduto.name;
  bool isDecrescente = false;

  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    setupListeners();
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listium.name),
        actions: [
          PopupMenuButton(
            tooltip: 'Ordenar lista',
            itemBuilder: (context) {
              return OrdemProduto.values.map((ordemProduto) {
                return PopupMenuItem(
                  value: ordemProduto,
                  child: Text('Ordenar por ${ordemProduto.label}'),
                );
              }).toList();
            },
            onSelected: _ordenarProdutos,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showFormModal,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    'R\$${calcularPrecosPegos().toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 42),
                  ),
                  const Text(
                    'total previsto para essa compra',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              'Produtos Planejados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: List.generate(listaProdutosPlanejados.length, (index) {
                Produto produto = listaProdutosPlanejados[index];
                return ListTileProduto(
                  produto: produto,
                  isComprado: produto.isComprado,
                  showModal: showFormModal,
                  iconClick: alternarComprado,
                  deleteClick: removeProduto,
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(thickness: 2),
            ),
            const Text(
              'Produtos Comprados',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: List.generate(listaProdutosPegos.length, (index) {
                Produto produto = listaProdutosPegos[index];
                return ListTileProduto(
                  produto: produto,
                  isComprado: true,
                  showModal: showFormModal,
                  iconClick: alternarComprado,
                  deleteClick: removeProduto,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _ordenarProdutos(ordemValue) {
    setState(() {
      if (ordem == ordemValue) {
        isDecrescente = !isDecrescente;
      } else {
        ordem = ordemValue;
        isDecrescente = false;
      }
    });
    refresh();
  }

  showFormModal({Produto? model}) {
    // Labels à serem mostradas no Modal
    String labelTitle = 'Adicionar Produto';
    String labelConfirmationButton = 'Salvar';
    String labelSkipButton = 'Cancelar';

    // Controlador dos campos do produto
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    bool isComprado = false;

    // Caso esteja editando
    if (model != null) {
      labelTitle = 'Editando ${model.name}';
      nameController.text = model.name;

      if (model.price != null) {
        priceController.text = model.price.toString();
      }

      if (model.amount != null) {
        amountController.text = model.amount.toString();
      }

      isComprado = model.isComprado;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Define que as bordas verticais serão arredondadas
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(32.0),

          // Formulário com Título, Campo e Botões
          child: ListView(
            children: [
              Text(
                labelTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text('Nome do Produto*'),
                  icon: Icon(Icons.abc_rounded),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                decoration: const InputDecoration(
                  label: Text('Quantidade'),
                  icon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  label: Text('Preço'),
                  icon: Icon(Icons.attach_money_rounded),
                ),
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
                    child: Text(labelSkipButton),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Criar um objeto Produto com as infos
                      Produto produto = Produto(
                        id: const Uuid().v1(),
                        name: nameController.text,
                        price: double.parse(priceController.text),
                        amount: double.parse(amountController.text),
                        isComprado: isComprado,
                        createdAt: DateTime.now(),
                      );

                      // Usar id do model
                      if (model != null) {
                        produto = model.copyWith(
                          name: nameController.text,
                          isComprado: isComprado,
                          amount: double.parse(amountController.text),
                          price: double.parse(priceController.text),
                          updatedAt: DateTime.now(),
                        );
                      }

                      if (amountController.text.isEmpty) {
                        produto.copyWith(
                          amount: double.parse(amountController.text),
                        );
                      }

                      if (priceController.text.isEmpty) {
                        produto.copyWith(
                          price: double.parse(priceController.text),
                        );
                      }

                      // Salvar no Firestore
                      _firestore
                          .collection('listiums')
                          .doc(widget.listium.id)
                          .collection('produtos')
                          .doc(produto.id)
                          .set(produto.toMap());

                      // Fechar o Modal
                      Navigator.pop(context);
                    },
                    child: Text(labelConfirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> refresh({QuerySnapshot<Map<String, dynamic>>? snapshot}) async {
    List<Produto> listaProdutos = [];

    snapshot ??= await _firestore
        .collection('listiums')
        .doc(widget.listium.id)
        .collection('produtos')
        // .where('isComprado', isEqualTo: isComprado)
        .orderBy(
          ordem.name,
          descending: isDecrescente,
        )
        .get();

    verificarAlteracoes(snapshot);

    for (var doc in snapshot.docs) {
      Produto produto = Produto.fromMap(doc.data());
      listaProdutos.add(produto);
    }
    filtrarProdutos(listaProdutos);
  }

  void filtrarProdutos(List<Produto> listaProdutos) {
    var listaTempPlanejados = <Produto>[];
    var listaTempComprados = <Produto>[];

    for (var produto in listaProdutos) {
      if (produto.isComprado) {
        listaTempComprados.add(produto);
      } else {
        listaTempPlanejados.add(produto);
      }
    }

    setState(() {
      listaProdutosPlanejados = listaTempPlanejados;
      listaProdutosPegos = listaTempComprados;
    });
  }

  Future<void> alternarComprado(Produto produto) async {
    produto.copyWith(isComprado: !produto.isComprado);
    await _firestore
        .collection('listiums')
        .doc(widget.listium.id)
        .collection('produtos')
        .doc(produto.id)
        .update({
      'isComprado': !produto.isComprado,
    });
  }

  void setupListeners() {
    _streamSubscription = _firestore
        .collection('listiums')
        .doc(widget.listium.id)
        .collection('produtos')
        .orderBy(ordem.name, descending: isDecrescente)
        .snapshots()
        .listen(
      (snapshot) {
        refresh(snapshot: snapshot);
      },
    );
  }

  void verificarAlteracoes(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    if (snapshot.docChanges.length == 1) {
      for (var change in snapshot.docChanges) {
        Produto produto = Produto.fromMap(change.doc.data()!);
        String tipoAlteracao = '';
        Color cor = Colors.white;

        switch (change.type) {
          case DocumentChangeType.added:
            tipoAlteracao = 'Produto ${produto.name} adicionado';
            cor = Colors.green;
            break;
          case DocumentChangeType.modified:
            tipoAlteracao = 'Produto ${produto.name} modificado';
            cor = Colors.orange;
            break;
          case DocumentChangeType.removed:
            tipoAlteracao = 'Produto ${produto.name} removido';
            cor = Colors.red;
            break;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentMaterialBanner()
          ..showSnackBar(
            SnackBar(
              content: Text(tipoAlteracao),
              backgroundColor: cor,
            ),
          );
      }
    }
  }

  Future<void> removeProduto(Produto produto) async {
    await _firestore
        .collection('listiums')
        .doc(widget.listium.id)
        .collection('produtos')
        .doc(produto.id)
        .delete();
  }

  double calcularPrecosPegos() {
    double total = 0;
    for (var produto in listaProdutosPegos) {
      if (produto.amount != null && produto.price != null) {
        total += (produto.amount! * produto.price!);
      }
    }
    return total;
  }
}
