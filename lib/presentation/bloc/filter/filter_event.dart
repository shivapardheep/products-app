part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent {}

class FilterProducts extends FilterEvent {
  final String query;
  final bool id;

  FilterProducts(this.query, this.id);
}
