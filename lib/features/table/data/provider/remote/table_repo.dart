import 'package:mlt_menu_admin_web/common/firebase/firebase_base.dart';
import 'package:mlt_menu_admin_web/common/firebase/firebase_result.dart';
import 'package:table_repository/table_repository.dart';

import '../../model/table_model.dart';

class TableRepo extends FirebaseBase<TableModel> {
  final TableRepository _tableRepository;

  TableRepo({required TableRepository tableRepository})
      : _tableRepository = tableRepository;

  Future<FirebaseResult<List<TableModel>>> getTable() async {
    Future<FirebaseResult<List<TableModel>>> result =
        getItems(await _tableRepository.getAllTable(), TableModel.fromJson);
    return result;
  }

  Stream<FirebaseResult<List<TableModel>>> getTablesOnStream() {
    return getItemsOnStream(
        _tableRepository.getTablesOnStream(), TableModel.fromJson);
  }

  Future<FirebaseResult> deleteTable({required String idTable}) async {
    return await deleteItem(_tableRepository.deleteTable(idTable: idTable));
  }

  Future<FirebaseResult<bool>> createTable({required TableModel table}) async {
    return await createItem(
        _tableRepository.createTable(dataJson: table.toJson()));
  }

  Future<FirebaseResult<bool>> updateTable({required TableModel table}) async {
    return await updateItem(_tableRepository.updateTable(
        tableID: table.id!, dataJson: table.toJson()));
  }
}
