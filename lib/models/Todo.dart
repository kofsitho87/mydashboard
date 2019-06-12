class Todo {
  String id;
  String title;
  String category;

  DateTime completeDate;
  DateTime createdDate;
  bool completed;
  String note;

  bool deleted = false;

  Todo(this.title, this.category, {this.completed = false, String note, String id = '', DateTime completeDate, DateTime createdDate}) 
    : this.id = id,
      this.note = note ?? '',
      this.completeDate = completeDate ?? null,
      this.createdDate = createdDate ?? DateTime.now()
      ;

  Todo copyWith({String id, String title, String category, bool completed}) {
    return Todo(
      title ?? this.title,
      category ?? this.title,

      id: id ?? this.id,
      completed: completed ?? this.completed,
      note: note ?? this.note,
    );
  }

  toMap(){
    Map<String, dynamic> data = {
      "title"       : this.title,
      "category"    : this.category,
      "completeDate": this.completeDate,
      "completed"   : this.completed,
      "note"        : this.note,
      "createdDate" : this.createdDate,
      "deleted"     : this.deleted,
    };
    return data; 
  }
}