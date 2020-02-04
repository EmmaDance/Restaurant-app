
class Order{

  int id;
  String table;
  String details;
  String status;
  int time;
  String type;

  Order();
  Order.withDetails({this.id, this.table, this.details, this.status, this.time, this.type });


  factory Order.fromJson(Map<String, dynamic> i){
    Order o = new Order();
    o.id = i["id"];
    o.table = i["table"];
    o.details = i["details"];
    o.status = i["status"];
    o.time = i["time"];
    o.type = i["type"];
    return o;
  }

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      "table":table,
      "details":details,
      "status":status,
      "time":time,
      "type":type,

    };
  }

  @override
  String toString() {
    return 'Order {id: $id, table: $table, details: $details, status: $status, time: $time, type: $type}';
  }

  @override
  bool operator ==(other) {
    // TODO: implement ==
    return this.id == other.id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

  factory Order.fromMap(Map<String, String> map) {
    return Order.withDetails(
      id: int.parse(map['id']),
      table: map["table"],
      details: map["details"],
      status: map["status"],
      time: int.parse(map["time"]),
      type: map["type"],
    );
  }

}
