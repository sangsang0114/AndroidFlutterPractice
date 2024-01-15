// private 요소들은 불러올 수 없다
import 'dart:io';

import 'package:calender_scheduler/model/category_color.dart';
import 'package:calender_scheduler/model/schedule.dart';
import 'package:calender_scheduler/model/schedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 요소들도 불러올 수 있다. 코드를 여러 파일에 나눠쓰는 느낌
part 'drift_database.g.dart'; //현재 코드를 쓰고 있는 db 클래스 파일.g.dart

@DriftDatabase(
  //어떤 클래스를 테이블로 쓸지
  tables: [
    Schedules,
    CategoryColors,
  ],
)
class LocalDatabase extends _$LocalDatabase {
  //drift가 g.dart 파일에 _$LocalDatabase 클래스를 생성
  LocalDatabase() : super(_openConnection());

  //DB 테이블 구조 상태 버전
  @override
  int get schemaVersion => 1;

  //id를 반환
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  // Stream<List<Schedule>> watchSchedules() => select(schedules).watch();

  // Stream<List<Schedule>> watchSchedules(DateTime date)
  // => (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  // Stream<List<Schedule>> watchSchedules(DateTime date) {
  Stream<List<ScheduleWithColor>> watchSchedules(DateTime date) {
    /*
    final query = select(schedules);
    query.where((tbl) => tbl.date.equals(date));
    return query.watch();
     */

    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId)),
    ]);

    //테이블이 2개가 되었으므로
    query.where(schedules.date.equals(date));
    query.orderBy(
      [
        OrderingTerm.asc(
          schedules.startTime,
        ),
      ],
    );

    //rows : 모든 데이터. row : 각각의 행
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );
    // return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  //삭제한 행의 id값
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

/*
  Future<Schedule> getScheduleById(int id) {
    final query = select(schedules);
    query.where((tbl) => tbl.id.equals(id));
    return query.getSingle();
  }
   */

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase(file);
  });
}
