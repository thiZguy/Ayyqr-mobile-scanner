

class Ticket {
  String name;
  String gov_id;
  String ticket_alias;
  bool is_used;
  Ticket({this.name, this.gov_id, this.ticket_alias, this.is_used});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      name: json['name'],
      gov_id: json['gov_id'],
      ticket_alias: json['ticket_alias'],
      is_used: json['is_used'],
    );
  }
}