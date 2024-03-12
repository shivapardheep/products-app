import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/data/models/products_serilize.dart';
import '../../../core/data/repositories/services.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<FilterProducts>(_filterProducts);
  }

  Future<void> _filterProducts(
      FilterProducts event, Emitter<FilterState> emit) async {
    emit(FilterLoading());
    try {
      List<ProductSerialize> dataList = await ServicesFunctions()
          .filterDataFun(query: event.query, id: event.id);

      emit(FilteredData(dataList));
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }
}
