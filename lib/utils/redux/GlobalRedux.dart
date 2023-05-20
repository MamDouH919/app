import 'package:async_redux/async_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:starkids_app/store/appState/actions/SignIn.action.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/utils/redux/JsonPersistor.dart';

typedef DispatchFunction = void Function(ReduxAction<AppState>, {bool notify});
typedef DispatchFutureFunction = Future<void> Function(ReduxAction<AppState>,
    {bool notify});

late Store<AppState> _store;

abstract class GlobalRedux {
  static Future<Store<AppState>> init() async {
    print("sdklfj");
    if (_store == null) {
      print('mamdouh');
      final JsonPersistor persistor = JsonPersistor();

      AppState? initialState = await persistor.readState();

      if (initialState == null) {
        initialState = AppState.initialState();
        await persistor.saveInitialState(initialState);
      }
      _store = Store<AppState>(
        initialState: initialState,
        persistor: persistor,
      );
    }
    return _store;
  }

  static Store<AppState> get store => _store;

  static AppState get state => _store.state;

  static DispatchFunction get dispatch => _store.dispatch;

  // static DispatchFutureFunction get dispatchFuture => _store.dispatchFuture;

  static Store<AppState> consumeStore(BuildContext context) =>
      Provider.of<Store<AppState>>(context, listen: false);

  static AppState consumeState(BuildContext context) =>
      Provider.of<AppState>(context, listen: false);

  static DispatchFunction consumeDispatch(BuildContext context) =>
      Provider.of<Dispatch>(context, listen: false);

  static dispatchFuture(SignInAction signInAction) {}

  // static DispatchFutureFunction consumeDispatchFuture(BuildContext context) =>
  //     Provider.of<DispatchFuture>(context, listen: false);
}
