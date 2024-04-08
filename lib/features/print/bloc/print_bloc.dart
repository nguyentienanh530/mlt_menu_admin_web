import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_repository/print_repository.dart';

import '../../../common/bloc/bloc_helper.dart';
import '../../../common/bloc/generic_bloc_state.dart';
import '../data/model/print_model.dart';
import '../data/provider/remote/print_repo.dart';

part 'print_event.dart';

typedef Emit = Emitter<GenericBlocState<PrintModel>>;

class PrintBloc extends Bloc<PrintEvent, GenericBlocState<PrintModel>>
    with BlocHelper<PrintModel> {
  PrintBloc() : super(GenericBlocState.loading()) {
    on<PrintsFetched>(_getPrints);
    on<PrintCreated>(_createPrint);
    on<PrintUpdated>(_updatePrint);
    on<PrintDeleted>(_deletePrint);
  }
  final _printRepository = PrintRepo(
      printRepository:
          PrintRepository(firebaseFirestore: FirebaseFirestore.instance));

  FutureOr<void> _getPrints(PrintsFetched event, Emit emit) async {
    await getItems(_printRepository.getPrints(), emit);
  }

  FutureOr<void> _createPrint(PrintCreated event, Emit emit) async {
    await createItem(
        _printRepository.createPrint(printModel: event.printModel), emit);
  }

  FutureOr<void> _updatePrint(PrintUpdated event, Emit emit) async {
    await updateItem(
        _printRepository.updatePrint(printModel: event.printModel), emit);
  }

  FutureOr<void> _deletePrint(PrintDeleted event, Emit emit) async {
    await deleteItem(
        _printRepository.deletePrint(printModel: event.printModel), emit);
  }
}
