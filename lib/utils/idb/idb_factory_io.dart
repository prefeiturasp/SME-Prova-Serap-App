import "package:idb_shim/idb_shim.dart";
import "package:idb_shim/idb_io.dart";
import "package:path_provider/path_provider.dart";

/// Provides access to an IndexedDB implementation.
///
/// The mobile implementation is based on a .json file.
Future<IdbFactory> get idbFactory async => getIdbFactoryPersistent((await getApplicationDocumentsDirectory()).path);
