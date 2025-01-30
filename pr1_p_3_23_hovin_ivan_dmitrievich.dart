void main(List<String> arguments) {
  var lastName = "Ховин";
  var name = "Иван";
  var middleName = "Дмитриевич";
  var age = 17;
  var gender = "мужской";
  var group = "П-3-23";
  var shortCollege = "МПТ им Г.В. Плеханова";
  var fullCollege = "Московский приборостроительный техникум (колледж) | РЭУ им. Г.В.Плеханова";
  var knownLang = <String>{"Python", "C#", "Java"};
  var futureLang = <String>{"C++", "Dart", "JavaScript"};
  var abstract = """
  int - целое число;
  double - дробное число (число с плавающей точкой);
  String - строка, состоит из символов взятых в кавычки;
  bool - булево значение, принимает true или false;
  List - список, изменяемый массив, содержащий определенный тип объектов;
  Set - изменяемый массив, сожержащий определенный тип уникальных объектов.
""";

  print("$lastName $name $middleName, $age лет, $gender пол");
  print("Студент группы $group $shortCollege");
  print("($fullCollege)");
  print("***************************");
  print("Конспект по некоторым типам объектов в языке программирования Dart.");
  print(abstract);
  var runeNum = abstract.contains("Rune");
  var ifRune = "";
  if (runeNum == false) {
    ifRune = "отсутствует";
  }
  else {
    ifRune = "присутствует";
  }
  print("Упоминание слова 'Rune' в конспекте $ifRune");
  print("***************************");
  var newKnownLang = Set<String>.from([...knownLang, ...futureLang]).toList();
  var newFutureLang = Set<String>.from([...knownLang, ...futureLang]).toList();
  newKnownLang.removeRange(knownLang.length, newKnownLang.length);
  newFutureLang.removeRange(0, knownLang.length);
  print("Изученные языки программирования: $newKnownLang");
  print("Планируемые для изучения языки программирования: $newFutureLang");
  print("Переменные, использующиеся в программе:");
  print("lastName, name, middleName, age, gender, group, shortCollege, fullCollege, knownLang, futureLang, abstract, runeNum, ifRune, newKnownLang, newFutureLang");

}
