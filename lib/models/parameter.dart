class Parameter {
  int index;
  int devType;
  int devAddr;
  int funcGroup;
  int funcNum;
  int rw;
  int id;
  String name;
  String value;


  Parameter({
    required this.index,
    required this.devType,
    required this.devAddr,
    required this.funcGroup,
    required this.funcNum,
    required this.rw,
    required this.id,
    required this.name,
    required this.value,
  });
}