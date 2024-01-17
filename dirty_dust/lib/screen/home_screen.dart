import 'package:dirty_dust/component/category_card.dart';
import 'package:dirty_dust/component/hourly_card.dart';
import 'package:dirty_dust/component/main_app_bar.dart';
import 'package:dirty_dust/component/main_drawer.dart';
import 'package:dirty_dust/const/regions.dart';
import 'package:dirty_dust/model/stat_and_status_model.dart';
import 'package:dirty_dust/model/stat_model.dart';
import 'package:dirty_dust/repository/stat_repository.dart';
import 'package:dirty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String region = regions[0];
  bool isExpanded = true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<Map<ItemCode, List<StatModel>>> fetchData() async {
    Map<ItemCode, List<StatModel>> stats = {};
    List<Future> futures = [];

    for (ItemCode itemCode in ItemCode.values) {
      futures.add(StatRepository.fetchData(itemCode: itemCode));
    }

    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      final key = ItemCode.values[i];
      final value = results[i];
      stats.addAll({key: value});
    }
    return stats;
  }

  void onRegionTap(String region) {
    setState(() {
      this.region = region;
    });
    Navigator.of(context).pop();
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 500 - kToolbarHeight;
    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<ItemCode, List<StatModel>>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text('에러 발생')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        Map<ItemCode, List<StatModel>> stats = snapshot.data!;
        StatModel pm10RecentStat = stats[ItemCode.PM10]![0];

        final status = DataUtils.getStatusFromItemCodeAndValue(
          value: pm10RecentStat.seoul,
          itemCode: ItemCode.PM10,
        );

        final ssModel = stats.keys.map((key) {
          final value = stats[key]!;
          final stat = value[0];
          return StatAndStatusModel(
            itemCode: key,
            status: DataUtils.getStatusFromItemCodeAndValue(
              value: stat.getLevelFromRegion(region),
              itemCode: key,
            ),
            stat: stat,
          );
        }).toList();
        return Scaffold(
          drawer: MainDrawer(
            darkColor: status.darkColor,
            lightColor: status.lightColor,
            onRegionTap: onRegionTap,
            selectedRegion: region,
          ),
          body: Container(
            color: status.primaryColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                MainAppBar(
                  isExpanded: isExpanded,
                  dateTime: pm10RecentStat.dataTime,
                  region: region,
                  status: status,
                  stat: pm10RecentStat,
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CategoryCard(
                        region: region,
                        models: ssModel,
                        lightColor: status.lightColor,
                        darkColor: status.darkColor,
                      ),
                      const SizedBox(height: 16.0),
                      ...stats.keys.map((itemCode) {
                        final stat = stats[itemCode]!;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: HourlyCard(
                            darkColor: status.darkColor,
                            lightColor: status.lightColor,
                            category: DataUtils.getItemCodeKrString(
                              itemCode: itemCode,
                            ),
                            stats: stat,
                            region: region,
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
