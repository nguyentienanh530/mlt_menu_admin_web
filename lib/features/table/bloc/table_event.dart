part of 'table_bloc.dart';

sealed class TableEvent {
  const TableEvent();
}

final class TablesFetched extends TableEvent {}

final class TablesOnStreamFetched extends TableEvent {}

final class TableDeleted extends TableEvent {
  final String idTable;

  const TableDeleted({required this.idTable});
}

final class TableCreated extends TableEvent {
  final Table tableModel;

  const TableCreated({required this.tableModel});
}

final class TableUpdated extends TableEvent {
  final Table table;

  const TableUpdated({required this.table});
}
