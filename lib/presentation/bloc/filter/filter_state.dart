part of 'filter_bloc.dart';

@immutable
abstract class FilterState {}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilteredData extends FilterState {
  final List<ProductSerialize> data;

  FilteredData(this.data);
}

class QrFilteredData extends FilterState {
  final List<ProductSerialize> data;

  QrFilteredData(this.data);
}

class FilterError extends FilterState {
  final String error;

  FilterError(this.error);
}
