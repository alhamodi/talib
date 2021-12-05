import 'package:flutter/material.dart';
import 'package:talib/home/home/home_view.dart';
import 'package:talib/shared/cacheHelper.dart';
import 'package:talib/shared/colors.dart';
import 'package:talib/shared/components.dart';

class OnBoardingScreen extends StatelessWidget {
  PageController onBoardingController = PageController();

  List<List<String>> headline = [
    [
      'شاهد اخر أنشطة',
      'تواصل مع إدارة الروضة',
      'تابع واجبات الطالب',
    ],
    [
      'sub 1',
      'sub 2',
      'sub 3',
    ],
    [
      'description 1',
      'description 2',
      'description 3',
    ],
  ];

  List<String> images = [
    'flat1.jpg',
    'flat2.jpg',
    'flat3.jpg',
  ];
  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: BouncingScrollPhysics(),
      onPageChanged: (value) {
        print(value.toString());
        if (value == images.length - 1)
          isLast = true;
        else
          isLast = false;
      },
      controller: onBoardingController,
      itemCount: images.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (_, index) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            elevation: 0,
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(right: 20),
                  ),
                  backgroundColor: MaterialStateProperty.all(white),
                  elevation: MaterialStateProperty.all(0),
                ),
                onPressed: () {
                  CacheHelper.saveData(key: 'ShowOnBoard', value: false)
                      .then((value) {
                    if (value) navigateAndReplacement(context, HomePage());
                  });
                },
                child: Text(
                  'تخطي',
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ],
          ),
          backgroundColor: white,
          body: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: List.generate(
                                3,
                                (indexDots) => Container(
                                      margin: const EdgeInsets.only(bottom: 2),
                                      width: 8,
                                      height: index == indexDots ? 25 : 8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: index == indexDots
                                            ? mainColor
                                            : subColor,
                                      ),
                                    )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                headline[0][index],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              Text(
                                headline[1][index],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: subColor),
                              ),
                              Text(
                                headline[2][index],
                                style: TextStyle(fontSize: 14, color: black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.height / 1.5,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(30)),
                      image: DecorationImage(
                          image: AssetImage('assets/images/${images[index]}'),
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (isLast) {
                CacheHelper.saveData(key: 'ShowOnBoard', value: false)
                    .then((value) {
                  if (value) navigateAndReplacement(context, HomePage());
                });
              } else {
                onBoardingController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              }
            },
            child: Icon(Icons.arrow_forward_ios_rounded),
          ),
        );
      },
    );
  }
}
