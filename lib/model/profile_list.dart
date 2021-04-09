class Profile {
  final int id;
  final String babyImage;
  final String babyName;
  final String babyBirth;

  Profile({this.id, this.babyImage, this.babyName, this.babyBirth});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json['id'],
        babyImage: json['babyImage'],
        babyName: json['babyName'],
        babyBirth: json['babyBirth'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "babyImage": babyImage,
        "babyName": babyName,
        "babyBirth": babyBirth,
      };
}
