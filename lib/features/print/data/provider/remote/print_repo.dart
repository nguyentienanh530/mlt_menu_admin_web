import 'package:print_repository/print_repository.dart';
import '../../../../../common/firebase/firebase_base.dart';
import '../../../../../common/firebase/firebase_result.dart';
import '../../model/print_model.dart';

class PrintRepo extends FirebaseBase<PrintModel> {
  final PrintRepository _printRepository;

  PrintRepo({required PrintRepository printRepository})
      : _printRepository = printRepository;

  Future<FirebaseResult<List<PrintModel>>> getPrints() async {
    return await getItems(
        await _printRepository.getPrints(), PrintModel.fromJson);
  }

  Future<FirebaseResult<bool>> createPrint(
      {required PrintModel printModel}) async {
    return await createItem(
        _printRepository.createPrint(dataJson: printModel.toJson()));
  }

  Future<FirebaseResult<bool>> updatePrint(
      {required PrintModel printModel}) async {
    return await updateItem(_printRepository.updatePrint(
        printID: printModel.id, dataJson: printModel.toJson()));
  }

  Future<FirebaseResult<bool>> deletePrint(
      {required PrintModel printModel}) async {
    return await deleteItem(
        _printRepository.deletePrint(printID: printModel.id));
  }
}
