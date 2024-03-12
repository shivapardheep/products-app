part of 'products_bloc.dart';

@immutable
abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductLoading extends ProductsState {}

class ProductAdded extends ProductsState {}

class Error extends ProductsState {}
