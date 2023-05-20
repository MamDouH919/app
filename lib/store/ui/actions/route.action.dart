import 'package:starkids_app/store/ui/actions/uiAction.dart';
import 'package:starkids_app/store/ui/ui.dart';

class SetCurrentRouteAction extends UIAction {
  final String newRoute;

  SetCurrentRouteAction(this.newRoute) : assert(newRoute != null);

  @override
  UI reduceState() => ui.copy(currentRoute: newRoute);
}
