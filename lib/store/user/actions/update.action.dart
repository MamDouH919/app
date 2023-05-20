import 'package:starkids_app/store/user/actions/UserAction.dart';
import 'package:starkids_app/store/user/user.dart';

class UpdateUserModelAction extends UserAction {
  final User user;

  UpdateUserModelAction(this.user);

  @override
  User reduceState() => user;
}
