// Статусы интернет-соединения
enum InternetTypes {
  connected,
  offline,
  unknown,
}

class InternetState {
  final InternetTypes type;

  InternetState({
    this.type = InternetTypes.unknown,
  });
}
