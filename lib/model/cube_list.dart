class Cube {
  final int id;
  final String cubeName;
  final String cubeMadeDate;
  final String cubeEndDate;
  final int cubeCount;

  Cube(
      {this.id,
      this.cubeName,
      this.cubeMadeDate,
      this.cubeEndDate,
      this.cubeCount});

  factory Cube.fromJson(Map<String, dynamic> json) => Cube(
        id: json['id'],
        cubeName: json['cubeName'],
        cubeMadeDate: json['cubeMadeDate'],
        cubeEndDate: json['cubeEndDate'],
        cubeCount: json['cubeCount'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cubeName": cubeName,
        "cubeMadeDate": cubeMadeDate,
        "cubeEndDate": cubeEndDate,
        "cubeCount": cubeCount,
      };
}
