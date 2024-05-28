import 'package:flutter/material.dart';
import 'package:internal_sakumi/features/admin/search/general_tags/add_tag_filter_content.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import '../../../../configs/color_configs.dart';
import '../../../../configs/text_configs.dart';
import '../../../../model/tag_model.dart';
import '../../manage_general/input_form/input_field.dart';
import '../../manage_tag/custom_button_v1.dart';
import 'add_tag_filter_cubit.dart';

class NoteTagDialog extends StatefulWidget {
  const NoteTagDialog({super.key,required this.addTagFilterCubit, required this.tag});
  final AddTagFilterCubit addTagFilterCubit;
  final TagModel tag;
  @override
  State<NoteTagDialog> createState() => _NoteTagDialogState();
}

class _NoteTagDialogState extends State<NoteTagDialog> {
  TextEditingController textFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: Text(AppText.textAddNote.text, style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: Resizable.font(context, 25)
      ),),
      actionsPadding: EdgeInsets.symmetric(
        vertical: Resizable.padding(context, 10),
        horizontal: Resizable.padding(context, 10),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputItem(
                title: AppText.txtNote.text,
                controller: textFieldController,
                onValidate: (value) {
                  if(value != null && value.isEmpty ) {
                    return AppText.txtNoteEmpty.text;
                  }
                  return null;
                },
                isExpand: true),
          ],
        ),
      ),
      actions: <Widget>[
        CustomButtonV1(
            onPressed: () {
              widget.addTagFilterCubit.addTag(widget.tag);
              Navigator.pop(context);
            },
            border: Colors.black,
            textColor: Colors.black,
            backgroundColor: Colors.white,
            title: AppText.btnPass.text),

        CustomButtonV1(
            onPressed: () async {
              if(formKey.currentState!
                  .validate()) {
                formKey.currentState!.save();
              }
              widget.addTagFilterCubit.addTag(widget.tag);
              widget.addTagFilterCubit.updateNotes(widget.tag.id, textFieldController.text);

              Navigator.pop(context);
            },
            textColor: Colors.white,
            backgroundColor: primaryColor,
            title: AppText.textAdd.text),
      ],
    );
  }
}
