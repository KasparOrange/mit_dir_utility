class PostModel {
  int id;
  String heading;
  String post;
  DateTime creationTime;
  late DateTime lastUpdate;

  PostModel(
      {required this.id, required this.creationTime, required this.heading, required this.post}) {
    lastUpdate = DateTime.now().toUtc();
  }

  PostModel.test() 
  : id = 000001,
    heading = 'This is the heading!',
    post = 'This is the content of the post.',
    creationTime = DateTime.now().toUtc(),
    lastUpdate = DateTime.now().toUtc();
}
