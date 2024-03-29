// Mocks generated by Mockito 5.4.2 from annotations
// in appserap/test/fixtures/user/http.fixture.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:http/src/base_response.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [BaseResponse].
///
/// See the documentation for Mockito's code generation for more information.
class MockBaseResponse extends _i1.Mock implements _i2.BaseResponse {
  MockBaseResponse() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get statusCode => (super.noSuchMethod(
        Invocation.getter(#statusCode),
        returnValue: 0,
      ) as int);
  @override
  Map<String, String> get headers => (super.noSuchMethod(
        Invocation.getter(#headers),
        returnValue: <String, String>{},
      ) as Map<String, String>);
  @override
  bool get isRedirect => (super.noSuchMethod(
        Invocation.getter(#isRedirect),
        returnValue: false,
      ) as bool);
  @override
  bool get persistentConnection => (super.noSuchMethod(
        Invocation.getter(#persistentConnection),
        returnValue: false,
      ) as bool);
}
