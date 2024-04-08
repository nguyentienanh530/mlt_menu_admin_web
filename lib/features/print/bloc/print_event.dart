part of 'print_bloc.dart';

class PrintEvent {}

class PrintsFetched extends PrintEvent {}

class PrintCreated extends PrintEvent {
  final PrintModel printModel;

  PrintCreated({required this.printModel});
}

class PrintUpdated extends PrintEvent {
  final PrintModel printModel;

  PrintUpdated({required this.printModel});
}

class PrintDeleted extends PrintEvent {
  final PrintModel printModel;

  PrintDeleted({required this.printModel});
}
