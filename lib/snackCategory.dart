import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:order_it/widgets/clippingStyle.dart';
import 'package:order_it/widgets/customAppBar.dart';
import 'package:order_it/widgets/customListViewTile.dart';
import 'package:order_it/widgets/customTitle.dart';

class SnackCategory extends StatefulWidget {
  @override
  _SnackCategoryState createState() => _SnackCategoryState();
}

class _SnackCategoryState extends State<SnackCategory> {
  /*Future Type method is created to get Data from FireBase
  1. It will include a firestore instance variable
  2. then a QuerySnapshot to get data from specific Collection
  3. and finally returning the Array of Data fetched from Firebase*/
  Future getSnacks() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("_snacks").getDocuments();
    return qn.documents;
  }

  /*Future Builds everytime the screen is loaded, so to obtain the Future in advace
  lets initialize the state onces it is obtain. But if your database is dynamic then
  this approach is not good */
  // Future _snackData;
  // @override
  // void initState() {
  //   super.initState();
  //   _snackData = getSnacks();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF213045),
        body: Stack(children: <Widget>[
          //background blue color of screen
          ClipPath(
            clipper: ClipBack(),
            child: Container(color: Colors.white),
          ),
          //widget holding back button and cart button.
          CustomAppBar(),
          CustomTitle(
            firstPart: 'Snacks',
            secondPart: 'Menu',
          ),

          /*This widget will hold:
          1. future: that will get data from FireBase
          2. builder: which will get context and snapshot of data to be shown
          3. if-else condition: if data is not loaded and connection is in waiting state then a circular
              progress bar will be loaded at center of screen
              Otherwise, It will return List tile holding specifc detials from Firebase mentioned in method below */
          FutureBuilder(
              future: getSnacks(),
              builder: (context, snapshot) {
                //In case data is not yet loaded from Firebase and our connection is waiting for it, we will display a progress bar on screen
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFF03B5CF),
                    ),
                  );
                } else {
                  return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: 570,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                      color: Colors.transparent,
                                    ),

                                //itemCount simply gets the length of array that we are returning from Future
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: CustomListViewTile(
                                      imgURL: snapshot.data[index].data['img'],
                                      subcategories:
                                          snapshot.data[index].data['subCat'],
                                      title: snapshot
                                          .data[index].data['snackType'],
                                      documentSnapshot: snapshot.data[index],
                                    ),
                                  );
                                }),
                          )));
                }
              })
        ]));
  }
}
