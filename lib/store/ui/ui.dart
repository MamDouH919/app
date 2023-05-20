class UI {
  bool? loading;
  String? currentRoute;

  UI({this.loading = false, this.currentRoute});

  UI copy({bool? loading, String? currentRoute}) => UI(
      loading: loading ?? this.loading,
      currentRoute: currentRoute ?? this.currentRoute);
}
