import 'package:starkids_app/store/ui/ui.dart';
import 'package:starkids_app/store/user/user.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class AppState {
  User? user;
  @JsonProperty(ignore: true)
  UI? ui;
  AppState({required this.user, required this.ui});

  AppState.initialState() {
    user = user;
    ui = UI();
  }

  AppState copy({User? user, UI? ui}) =>
      AppState(user: user, ui: ui);
}
