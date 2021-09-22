class Config {
  final int timeout;

  Config(this.timeout);

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(json['timeout']);
  }
}
