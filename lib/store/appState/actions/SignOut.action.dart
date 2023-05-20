import 'package:async_redux/async_redux.dart';
import 'package:starkids_app/store/appState/appState.dart';

class SignOutAction extends ReduxAction<AppState> {
  @override
  AppState reduce() {
    return AppState.initialState();
  }
}
