class Developer {
  Developer({this.name, this.birthMonth, this.role, this.likes});
  String name;
  int birthMonth;
  String likes;
  String role;
}

Developer hanafuda =
    Developer(name: 'hanafuda', birthMonth: 5, role: 'Developer', likes: '釣り');

Developer kuroino721 = Developer(
    name: 'kuroino721', birthMonth: 7, role: 'Developer', likes: 'あざらし');

Developer rick = Developer(
    name: 'Rick', birthMonth: 9, role: 'Designer&Writer', likes: '藤子不二雄');

List<Developer> developers = [hanafuda, kuroino721, rick];
