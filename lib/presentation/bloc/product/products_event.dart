part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}

class AddProduct extends ProductsEvent {
  final Product product;

  AddProduct(this.product);
}

class AddLog extends ProductsEvent {
  final String log;
  final String userId;

  AddLog(this.log, this.userId);
}
