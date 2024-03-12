import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:test_app/core/data/models/products.dart';

import '../../../core/data/repositories/services.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<AddProduct>(_addProductsFun);
  }

  Future<void> _addProductsFun(
      AddProduct event, Emitter<ProductsState> emit) async {
    emit(ProductLoading());
    try {
      final bool response =
          await ServicesFunctions().addProductToFireStore(event.product);
      if (response) {
        emit(ProductAdded());
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ProductsInitial());
      } else {
        emit(Error());
      }
    } catch (_) {
      emit(Error());
    }
  }
}
