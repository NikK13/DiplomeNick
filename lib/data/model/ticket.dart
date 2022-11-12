class Ticket{
  int? id;
  String? title;
  String? date;

  Ticket({this.id, this.title, this.date});

  factory Ticket.fromJson(Map<String, dynamic> json){
    return Ticket(
      id: json['id'],
      date: json['date'],
      title: json['title'],
    );
  }
}