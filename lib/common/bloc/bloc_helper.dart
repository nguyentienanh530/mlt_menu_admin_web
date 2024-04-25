import 'dart:async';

import 'package:mlt_menu_admin/common/firebase/firebase_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'generic_bloc_state.dart';

typedef Emit<T> = Emitter<GenericBlocState<T>>;

enum ApiOperation { select, create, update, delete, itemSelectStream }

mixin BlocHelper<T> {
  ApiOperation operation = ApiOperation.select;

  Future _checkFailureOrSuccess(
      FirebaseResult failureOrSuccess, Emit<T> emit) async {
    failureOrSuccess.when(
      failure: (String failure) {
        emit(GenericBlocState.failure(failure));
      },
      success: (_) {
        emit(GenericBlocState.success());
      },
    );
  }

  Future _apiOperationTemplate(
      Future<FirebaseResult> apiCallback, Emit<T> emit) async {
    emit(GenericBlocState.loading());
    FirebaseResult failureOrSuccess = await apiCallback;
    _checkFailureOrSuccess(failureOrSuccess, emit);
  }

  Future<void> createItem(
      Future<FirebaseResult> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.create;
    await _apiOperationTemplate(apiCallback, emit);
  }

  Future<void> updateItem(
      Future<FirebaseResult> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.update;
    await _apiOperationTemplate(apiCallback, emit);
  }

  Future<void> deleteItem(
      Future<FirebaseResult> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.delete;
    await _apiOperationTemplate(apiCallback, emit);
  }

  Future<void> getItems(
      Future<FirebaseResult<List<T>>> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.select;
    emit(GenericBlocState.loading());
    FirebaseResult<List<T>> failureOrSuccess = await apiCallback;

    failureOrSuccess.when(failure: (String failure) async {
      emit(GenericBlocState.failure(failure));
    }, success: (List<T> items) async {
      if (items.isEmpty) {
        emit(GenericBlocState.empty());
      } else {
        emit(GenericBlocState.success(datas: items));
      }
    });
  }

  Future<void> getItemsOnStream(
      Stream<FirebaseResult<List<T>>> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.itemSelectStream;
    emit(GenericBlocState.loading());
    await emit.forEach(apiCallback,
        onData: (data) => data.when(
            success: (List<T> data) => data.isEmpty
                ? GenericBlocState.empty()
                : GenericBlocState.success(datas: data),
            failure: (error) => GenericBlocState.failure(error)),
        onError: (error, stackTrace) =>
            GenericBlocState.failure(error.toString()));
  }

  Future<void> getItemOnStream(
      Stream<FirebaseResult<T>> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.itemSelectStream;
    emit(GenericBlocState.loading());
    await emit.forEach(apiCallback,
        onData: (data) => data.when(
            success: (T data) => GenericBlocState.success(data: data),
            failure: (error) => GenericBlocState.failure(error)),
        onError: (error, stackTrace) =>
            GenericBlocState.failure(error.toString()));
  }

  Future<void> getItem(
      Future<FirebaseResult<T>> apiCallback, Emit<T> emit) async {
    operation = ApiOperation.select;
    emit(GenericBlocState.loading());
    FirebaseResult<T> failureOrSuccess = await apiCallback;

    failureOrSuccess.when(failure: (String failure) async {
      emit(GenericBlocState.failure(failure));
    }, success: (T item) async {
      if (item == null) {
        emit(GenericBlocState.empty());
      } else {
        emit(GenericBlocState.success(data: item));
      }
    });
  }
}
