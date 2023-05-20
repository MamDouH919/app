import 'package:starkids_app/store/ui/actions/uiAction.dart';
import 'package:starkids_app/store/ui/ui.dart';

class EnableLoadingAction extends UIAction {
  @override
  UI reduceState() => ui.copy(loading: true);
}

class DisableLoadingAction extends UIAction {
  @override
  UI reduceState() => ui.copy(loading: false);
}
