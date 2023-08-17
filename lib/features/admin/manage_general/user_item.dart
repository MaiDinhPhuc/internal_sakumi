import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class UserItem extends StatelessWidget {
  final String name, info, url;
  const UserItem(this.name, this.info, this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xffE0E0E0),
              width: Resizable.size(context, 1))),
      child: Row(
        children: [
          CircleAvatar(
            radius: Resizable.size(context, 15),
            backgroundColor: const Color(0xffD9D9D9),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1000),
              child: ImageNetwork(
                  image: url,
                  height: Resizable.size(context, 30),
                  width: Resizable.size(context, 30),
                  onError: Container(),
                  onLoading: Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(),
                  )),
            ),
          ),
          SizedBox(width: Resizable.padding(context, 20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 20),
                      color: Colors.black)),
              SizedBox(height: Resizable.padding(context, 3)),
              Text(info,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 15),
                      color: const Color(0xff757575)))
            ],
          )
        ],
      ),
    );
  }
}
