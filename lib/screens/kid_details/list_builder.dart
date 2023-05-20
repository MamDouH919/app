import 'package:flutter/material.dart';
import 'package:starkids_app/data/kid/kid_class_response.dart';
import 'package:starkids_app/data/kid/kid_route_response.dart';
import 'package:starkids_app/settings/ThemeSettings.dart';

class ListViewBuilderWidget extends StatelessWidget {
  final List ?list;
  final Color? bgColor;
  final String? dataType;
  final String? route;
  final String? type;
  final String? classType;
  final String? kidId;
  final int? screenIndex;

  const ListViewBuilderWidget(
      {Key? key,
      this.list,
      this.bgColor,
      this.dataType,
      this.route,
      this.type,
      this.classType,
      this.kidId,
      this.screenIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {};
    Color rowColor = bgColor!;

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list?.length,
        itemBuilder: (context, index) {
          if (list![index]['style'] != null) {
            if (list![index]['style'] == 'styled-orange') {
              rowColor = Colors.orange;
            } else if (list![index]['style'] == 'styled-brown') {
              rowColor = Colors.brown;
            } else if (list![index]['style'] == 'styled-blue') {
              rowColor = Colors.blue;
            } else if (list![index]['style'] == 'styled-gray') {
              rowColor = Colors.grey;
            } else if (list![index]['style'] == 'styled-pink') {
              rowColor = Colors.pink;
            } else if (list![index]['style'] == 'styled-green') {
              rowColor = Colors.green;
            }
          }
          return GestureDetector(
              onTap: () {
                if (type == 'c') {
                  data = {
                    "classType": classType,
                    "kidClassResponse": KidClassResponse.fromJson(list![index]),
                    "kidId": KidClassResponse.fromJson(list![index]).kidClassId,
                    "index": screenIndex
                  };
                  Navigator.pushNamed(context, route!, arguments: data);
                } else {
                  data = {
                    "classType": classType,
                    "kidClassResponse": KidRouteResponse.fromJson(list![index]),
                    "kidId": KidRouteResponse.fromJson(list![index]).kidRouteId,
                    "index": screenIndex
                  };
                  Navigator.pushNamed(context, route!, arguments: data);
                }
              },
              child: Row(children: [
                Container(
                  height: 50,
                  width: 40,
                  margin: EdgeInsets.fromLTRB(0, 5, 20, 5),
                  decoration: BoxDecoration(
                    color: list![index]['sign'] == 'star'
                        ? Colors.green
                        : list![index]['sign'] == 'warning'
                            ? Colors.orange
                            : Colors.red,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: list![index]['sign'] == 'star'
                        ? Icon(Icons.check, color: Colors.white)
                        : list![index]['sign'] == 'warning'
                            ? Icon(Icons.warning, color: Colors.white)
                            : Icon(Icons.close, color: Colors.white),
                  ),
                ),
                Expanded(
                    child: Container(
                  height: 50,
                  margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  decoration: BoxDecoration(
                    color: rowColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                  list![index][dataType].toString() ?? "",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ThemeSettings.fontMedSize)))),
                      Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 15)
                    ],
                  ),
                ))
              ]));
        });
  }
}
