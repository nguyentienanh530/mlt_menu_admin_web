import 'dart:async';
import 'package:mlt_menu_admin/common/bloc/bloc_helper.dart';
import 'package:mlt_menu_admin/common/bloc/generic_bloc_state.dart';
import 'package:mlt_menu_admin/features/table/data/provider/remote/table_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_repository/table_repository.dart';
import '../data/model/table_model.dart';
part 'table_event.dart';

typedef Emit = Emitter<GenericBlocState<Table>>;
typedef Table = TableModel;

class TableBloc extends Bloc<TableEvent, GenericBlocState<Table>>
    with BlocHelper<Table> {
  TableBloc() : super(GenericBlocState.loading()) {
    on<TablesFetched>(_getAllTable);
    on<TablesOnStreamFetched>(_getTablesOnStream);
    on<TableDeleted>(_deleteTable);
    on<TableCreated>(_createTable);
    on<TableUpdated>(_updateTable);
  }
  final _tableRepository = TableRepo(
      tableRepository:
          TableRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getAllTable(TablesFetched event, Emit emit) async {
    await getItems(_tableRepository.getTable(), emit);
  }

  FutureOr<void> _deleteTable(TableDeleted event, Emit emit) async {
    await deleteItem(
        _tableRepository.deleteTable(idTable: event.idTable), emit);
  }

  FutureOr<void> _createTable(TableCreated event, Emit emit) async {
    await createItem(
        _tableRepository.createTable(table: event.tableModel), emit);
  }

  FutureOr<void> _updateTable(
      TableUpdated event, Emitter<GenericBlocState<Table>> emit) async {
    await updateItem(_tableRepository.updateTable(table: event.table), emit);
  }

  FutureOr<void> _getTablesOnStream(
      TablesOnStreamFetched event, Emit emit) async {
    await getItemsOnStream(_tableRepository.getTablesOnStream(), emit);
  }
}
