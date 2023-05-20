import 'package:async_redux/async_redux.dart';
import 'package:starkids_app/store/appState/appState.dart';
import 'package:starkids_app/store/ui/ui.dart';

abstract class UIAction extends ReduxAction<AppState> {
  UI get ui => state.ui ?? UI();
  UI reduceState();

  @override
  AppState reduce() {
    return state.copy(ui: reduceState());
  }
}
