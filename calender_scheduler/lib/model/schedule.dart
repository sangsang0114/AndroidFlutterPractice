import 'package:drift/drift.dart';

class Schedules extends Table {
  //PK
  IntColumn get id => integer().autoIncrement()();

  //내용
  TextColumn get content => text()();

  //날짜
  DateTimeColumn get date => dateTime()();

  //시작 시간
  IntColumn get startTime => integer()();

  //마감 시간
  IntColumn get endTime => integer()();

  // Category Color Table Id
  IntColumn get colorId => integer()();

  //생성 날짜
  DateTimeColumn get createdAt => dateTime().clientDefault(
        () => DateTime.now(),
      )();
}
