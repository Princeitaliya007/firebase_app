class Employee {
  final String? name;
  final int? age;
  final String? city;

  Employee({
    required this.name,
    required this.age,
    required this.city,
  });

  // factory Employee.fromMap(Map<String, dynamic> data) {
  //   return Employee(
  //     name: data['name'],
  //     age: data['age'],
  //     city: data['city'],
  //   );
  // }
}
