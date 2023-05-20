import 'package:async_redux/async_redux.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/user/user.dart';

abstract class UserAction extends ReduxAction<AppState> {
  User reduceState();

  @override
  AppState reduce() {
    // don't return null, if user == null to allow no user
    return state.copy(user: reduceState());
  }
}
