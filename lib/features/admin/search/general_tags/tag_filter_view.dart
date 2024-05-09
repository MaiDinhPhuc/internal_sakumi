import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_cubit.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_part_1.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/tag_filter_part_2.dart';

import '../../../../configs/color_configs.dart';
import '../../../../utils/resizable.dart';

class TagFilterView extends StatelessWidget {
  const TagFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TagFilterCubit()..load(),
      child: BlocBuilder<TagFilterCubit, int>(
        builder: (context, state) {
          final tagFilterCubit = context.read<TagFilterCubit>();

          if(state == 0) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: grey1,
            ),
            child: Padding(
              padding: EdgeInsets.all(Resizable.padding(context, 15)),
              child: Row(
                children: [
                  Container(
                    width: Resizable.size(context, 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  const TagFilterPart1(
                    ),
                  ),
                  SizedBox(width: Resizable.padding(context, 10),),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  const TagFilterPart2(
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
