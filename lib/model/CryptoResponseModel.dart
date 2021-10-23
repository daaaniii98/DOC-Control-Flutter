class CryptoResponseModel{
  String? ciphertext;
  String? initializationVector;

  CryptoResponseModel(this.ciphertext, this.initializationVector);

  factory CryptoResponseModel.fromJson(Map<String, dynamic> myJson) {
    return CryptoResponseModel(myJson['ciphertext'], myJson['initializationVector']);
  }

  Map<String, dynamic> toMap() {
    var myMap = {
      'ciphertext': this.ciphertext,
      'initializationVector': this.initializationVector
    };
    return myMap;
  }

}