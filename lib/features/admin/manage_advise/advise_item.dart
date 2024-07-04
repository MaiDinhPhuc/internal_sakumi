import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/admin/manage_advise/status_advise_icon.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/advise_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'manage_advise_cubit.dart';

class AdviseItem extends StatelessWidget {
  const AdviseItem({super.key, required this.cubit, required this.advise});
  final ManageAdviseCubit cubit;
  final AdviseModel advise;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            vertical: Resizable.padding(context, 10),
            horizontal: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(Resizable.size(context, 5))),
            color: Colors.white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SmallAvatar(cubit.getAvt(advise.userId)),
                  SizedBox(width: Resizable.font(context, 10)),
                  Text(cubit.getName(advise.userId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  if(advise.type == "course")
                    Text(cubit.getCourse(advise.typeId),
                      style: TextStyle(
                          color: greyColor.shade500,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                  if(advise.type == "course")
                  Container(
                    height: Resizable.size(context, 15),
                    width: Resizable.size(context, 1),
                    margin: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 10)),
                    color: greyColor.shade300,
                  ),
                  Text(cubit.getDate(advise.date),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(context, 20))),
                ],
              ),
              StatusAdviseIcon(advise: advise, cubit: cubit)
            ],
          ),
          Container(
            height: Resizable.size(context, 1),
            margin: EdgeInsets.only(
                top: Resizable.padding(context, 5),
                bottom: Resizable.padding(context, 10)),
            color: greyColor.shade300,
          ),
          Row(
            children: [
              Expanded(
                  child: Text("Email: ${advise.email.isEmpty ? "Không có email" : advise.email}",
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          SizedBox(height: Resizable.padding(context, 5)),
          Row(
            children: [
              Expanded(
                  child: Text("Số điện thoại: ${advise.phone}",
                      style: TextStyle(
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.w500)))
            ],
          ),
          if(advise.type == "banner")
            Text("Banner cần tư vấn:",
                style: TextStyle(
                    fontSize: Resizable.font(context, 20),
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          if(advise.type == "banner")
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child:Image.network(cubit.getBanner(advise.typeId)!.image, fit: BoxFit.fill)),
        ]));
  }
}
