// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$JobStore on _JobStoreBase, Store {
  late final _$statusJobAtom =
      Atom(name: '_JobStoreBase.statusJob', context: context);

  @override
  ObservableMap<JobsEnum, EnumJobStatus> get statusJob {
    _$statusJobAtom.reportRead();
    return super.statusJob;
  }

  @override
  set statusJob(ObservableMap<JobsEnum, EnumJobStatus> value) {
    _$statusJobAtom.reportWrite(value, super.statusJob, () {
      super.statusJob = value;
    });
  }

  @override
  String toString() {
    return '''
statusJob: ${statusJob}
    ''';
  }
}
