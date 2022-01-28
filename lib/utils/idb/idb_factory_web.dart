import "package:idb_shim/idb_shim.dart";
import "package:idb_shim/idb_browser.dart";

/// Provides access to an IndexedDB implementation.
///
/// The browser has an implementation built-in.
Future<IdbFactory> get idbFactory async => idbFactoryBrowser;
