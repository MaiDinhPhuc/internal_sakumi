import 'package:d_chart/d_chart.dart';
import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ColumnChart extends StatelessWidget {
  const ColumnChart({Key? key, required this.listStd}) : super(key: key);

  final List<double> listStd;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppText.titleStdNumber.text,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: Resizable.font(context, 17))),
        SizedBox(height: Resizable.size(context, 5)),
        Container(
         // width: Resizable.size(context, 300),
          // height: Resizable.size(context, 130),
          constraints: BoxConstraints(
            maxHeight: Resizable.size(context, 130),
            maxWidth: Resizable.size(context, 300)
          ),
          child: DChartBarCustom(
            spaceBetweenItem: Resizable.size(context, 5),
            spaceDomainLinetoChart: Resizable.size(context, 1),
            spaceMeasureLinetoChart: Resizable.size(context, 0),
            showDomainLine: true,
            listData: [
              DChartBarDataCustom(
                  color: const Color(0xff33691E),
                  value: listStd[0],
                  label: 'A',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xff757575),
                  value: listStd[1],
                  label: 'B',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffFFD600),
                  value: listStd[2],
                  label: 'C',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffE65100),
                  value: listStd[3],
                  label: 'D',
                  showValue: true),
              DChartBarDataCustom(
                  color: const Color(0xffB71C1C),
                  value: listStd[4],
                  label: 'E',
                  showValue: true),
            ],
          ),
        ),
        SizedBox(height: Resizable.size(context, 5)),
        Row(
          children: [
            Container(
              height: Resizable.size(context, 3),
              width: Resizable.size(context, 20),
              color: const Color(0xff33691E),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol1.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: const Color(0xff757575),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 20)),
                  child: Text(
                    AppText.txtCol2.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: Resizable.size(context, 3),
                  width: Resizable.size(context, 20),
                  color: const Color(0xffFFD600),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: Resizable.padding(context, 3),
                      right: Resizable.padding(context, 0)),
                  child: Text(
                    AppText.txtCol3.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 14),
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: Resizable.size(context, 3),
              width: Resizable.size(context, 20),
              color: const Color(0xffE65100),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol4.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              height: Resizable.size(context, 3),
              width: Resizable.size(context, 20),
              color: const Color(0xffB71C1C),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: Resizable.padding(context, 3),
                  right: Resizable.padding(context, 20)),
              child: Text(
                AppText.txtCol5.text,
                style: TextStyle(
                    fontSize: Resizable.font(context, 14),
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        )
      ],
    );
  }
}
