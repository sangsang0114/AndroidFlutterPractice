import 'package:dirty_dust/model/stat_model.dart';
import 'package:dirty_dust/model/status_model.dart';
import 'package:dirty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final StatusModel status;
  final StatModel stat;
  final String region;
  final DateTime dateTime;
  final bool isExpanded;

  const MainAppBar({
    super.key,
    required this.status,
    required this.stat,
    required this.region,
    required this.dateTime,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    const ts = TextStyle(color: Colors.white, fontSize: 30.0);

    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      title: isExpanded
          ? null
          : Text(
              '$region ${DataUtils.getTimeFromDateTime(dateTime: dateTime)}'),
      expandedHeight: 500,
      backgroundColor: status.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            child: Column(
              children: [
                Text(region,
                    style: ts.copyWith(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    )),
                Text(
                  DataUtils.getTimeFromDateTime(dateTime: stat.dataTime),
                  style: ts.copyWith(
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                Image.asset(status.imagePath,
                    width: MediaQuery.of(context).size.width / 2),
                const SizedBox(height: 20.0),
                Text(status.label,
                    style: ts.copyWith(
                        fontSize: 40.0, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8.0),
                Text(status.comment,
                    style: ts.copyWith(
                        fontSize: 20.0, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
