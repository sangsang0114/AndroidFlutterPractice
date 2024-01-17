import 'package:dirty_dust/component/card_title.dart';
import 'package:dirty_dust/component/main_card.dart';
import 'package:dirty_dust/model/stat_and_status_model.dart';
import 'package:dirty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';

import 'main_stat.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final List<StatAndStatusModel> models;
  final Color darkColor;
  final Color lightColor;

  const CategoryCard({
    super.key,
    required this.region,
    required this.models,
    required this.darkColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0,
      child: MainCard(
        backgroundColor: lightColor,
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류병 통계',
                backgroundColor: darkColor,
              ),
              Expanded(
                child: ListView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: models
                      .map((model) => MainStat(
                            category: DataUtils.getItemCodeKrString(
                                itemCode: model.itemCode),
                            imgPath: model.status.imagePath,
                            level: model.status.label,
                            stat:
                                '${model.stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItcomeCode(itemCode: model.itemCode)}',
                            width: constraint.maxWidth / 3,
                          ))
                      .toList(),
                  /*
                  children: List.generate(
                    11,
                    (index) => MainStat(
                      category: '미세먼지$index',
                      imgPath: 'asset/img/best.png',
                      label: '최고',
                      stat: '0㎍/㎥',
                      width: constraint.maxWidth / 3,
                    ),
                  ),
                   */
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
