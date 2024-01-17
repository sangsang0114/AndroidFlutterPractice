import 'package:dirty_dust/model/stat_model.dart';
import 'package:dirty_dust/model/status_model.dart';

class StatAndStatusModel {
  final StatusModel status;
  final StatModel stat;
  final ItemCode itemCode;

  StatAndStatusModel({
    required this.itemCode,
    required this.status,
    required this.stat,
  });
}
