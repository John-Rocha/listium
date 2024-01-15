enum OrdemProduto {
  name(label: 'Nome'),
  price(label: 'Preço'),
  amount(label: 'Quantidade');

  final String label;
  const OrdemProduto({required this.label});
}
