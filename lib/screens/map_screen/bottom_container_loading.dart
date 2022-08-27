import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/classes/loading.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';

class BottomContainerLoading extends StatelessWidget {
  const BottomContainerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // height: 324,
      padding: EdgeInsets.symmetric(horizontal: 30),
      // color: Colors.blue,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 60,
                // color: Colors.red,
              ),
              Container(
                // height: 324,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                width: MediaQuery.of(context).size.width - 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer.fromColors(
                      enabled: true,
                      period: Duration(milliseconds: 1000),
                      baseColor: Colors.grey,
                      highlightColor:Provider.of<MyThemesProvider>(context).getThemeMode() == ThemeMode.dark ?Colors.grey.shade300 : Colors.grey.shade700,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          // Align(alignment: Alignment.topRight, child: Icon(Icons.favorite)),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: LoadingData.shimmerContainerHeight,
                            width: screenWidth * 0.25,
                            color: Theme.of(context).colorScheme.primaryVariant,
                            // color: Colors.white54,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                              height: LoadingData.shimmerContainerHeight,
                              width: screenWidth * 0.46,
                              color: Theme.of(context).colorScheme.primaryVariant),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: LoadingData.shimmerContainerHeight,
                              width: screenWidth * 0.7,
                              color: Theme.of(context).colorScheme.primaryVariant),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                              height: LoadingData.shimmerContainerHeight,
                              width: screenWidth * 0.7,
                              color: Theme.of(context).colorScheme.primaryVariant),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                              height: LoadingData.shimmerContainerHeight,
                              width: screenWidth * 0.7,
                              color: Theme.of(context).colorScheme.primaryVariant),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                              height: LoadingData.shimmerContainerHeight,
                              width: screenWidth * 0.5,
                              color: Theme.of(context).colorScheme.primaryVariant),

                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.lightBlueAccent,
                          elevation: 6,
                          shadowColor: Theme.of(context).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),),),
                          child: FlatButton(
                            // splashColor: Colors.transparent,
                            height: 50,
                            minWidth: 50,
                            // padding: EdgeInsets.all(0),
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                            // color:Theme.of(context).colorScheme.primaryContainer ,
                            color: Colors.lightBlueAccent,
                            onPressed: () {},
                            child: Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Card(
                            // color: Theme.of(context).primaryColor,
                            color: Colors.lightBlueAccent,
                            elevation: 6,
                            shadowColor: Theme.of(context).colorScheme.primaryContainer,
                            shape:
                                RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: FlatButton(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                // splashColor: Colors.transparent,
                                // color: Theme.of(context).primaryColor,
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.message,
                                      // color: Theme.of(context).colorScheme.primaryContainer,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Send Message',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )
                                  ],
                                )),
                          ),
                        )
                      ],
                    ),

                    // Row
                  ],
                ),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    // color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(40))),
              ),
            ],
          ),
          Positioned(
              top: 5,
              child: CircleAvatar(
                backgroundColor: Colors.lightBlueAccent,
                radius: 55,
                child: Container(
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: NetworkImage(
                  //           '',
                  //         )
                  //     )
                  // ),
                  child: ChatUi.getImageLoaderIcon(60)
                ),
              )),
        ],
      ),
    );
  }
}
