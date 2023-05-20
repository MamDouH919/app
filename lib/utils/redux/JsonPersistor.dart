import 'package:async_redux/async_redux.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starkids_app/store/appState/appState.dart';

const String _jsonKey = 'starkidsState';

class JsonPersistor implements Persistor<AppState> {
  final Duration? _throttle;
  final Duration? _saveDuration;

  JsonPersistor({
    Duration? throttle,
    Duration? saveDuration,
  })  : _throttle = throttle,
        _saveDuration = saveDuration;

  @override
  Duration? get throttle => _throttle;

  Duration? get saveDuration => _saveDuration;

  late SharedPreferences _localDb;

  Future<SharedPreferences> get localDb async {
    return _localDb ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveInitialState(AppState state) async {
    if ((await localDb).containsKey(_jsonKey)) {
      throw PersistException('Store is already persisted.');
    } else {
      return persistDifference(lastPersistedState: null, newState: state);
    }
  }

  @override
  Future<void> persistDifference({
    AppState? lastPersistedState,
    AppState? newState,
  }) async {
    assert(newState != null);

    if (saveDuration != null) await Future<dynamic>.delayed(saveDuration!);

    // always update storage
    await (await localDb).setString(_jsonKey,
        JsonMapper.serialize(newState, const SerializationOptions(indent: '')));
  }

  @override
  Future<AppState?> readState() async {
    if (!(await localDb).containsKey(_jsonKey)) return null;
    return JsonMapper.deserialize<AppState>(
        (await localDb).getString(_jsonKey));
  }

  @override
  Future<bool> deleteState() async => (await localDb).clear();
}
