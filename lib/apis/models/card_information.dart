class CardInformation {
  String? cardNumber;
  String? cvvCode;
  String? expdate;
  String? cardNameHolder;

  CardInformation({
    this.cardNumber,
    this.cvvCode,
    this.expdate,
    this.cardNameHolder,
  });

  factory CardInformation.fromJson(Map<String, dynamic> json) {
    return CardInformation(
      cardNumber: json['cardNumber'],
      cvvCode: json['cvvCode'],
      expdate: json['expdate'],
      cardNameHolder: json['cardNameHolder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber,
      'cvvCode': cvvCode,
      'expdate': expdate,
      'cardNameHolder': cardNameHolder,
    };
  }
}
