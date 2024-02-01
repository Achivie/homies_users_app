class RoommateModel {
  RoommateModel({
    required this.name,
    required this.work,
    required this.id,
    required this.profile,
    required this.otherPics,
    required this.age,
  });

  final String name, work, id, profile;
  final List<String> otherPics;
  final int age;
}
