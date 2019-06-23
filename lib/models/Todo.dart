import './Category.dart';

class Todo {
  String id;
  String title;
  Category category;

  DateTime completeDate;
  DateTime createdDate;
  bool completed;
  bool important;
  String note;

  bool deleted = false;

  Todo(this.title, this.category, {this.completed = false, String note, String id = '', DateTime completeDate, DateTime createdDate, bool important}) 
    : this.id = id,
      this.note = note ?? '',
      this.completeDate = completeDate ?? null,
      this.createdDate = createdDate ?? DateTime.now(),
      this.important = important ?? false
      ;

  Todo copyWith({String id, String title, bool completed}) {
    return Todo(
      title ?? this.title,
      category ?? this.category,
      id: id ?? this.id,
      completed: completed ?? this.completed,
      note: note ?? this.note,
    );
  }

  toMap(){
    Map<String, dynamic> data = {
      "title"       : this.title,
      "category"    : this.category.ref,
      "completeDate": this.completeDate,
      "completed"   : this.completed,
      "note"        : this.note,
      "createdDate" : this.createdDate,
      "deleted"     : this.deleted,
      "important"   : this.important,
    };
    return data; 
  }
}