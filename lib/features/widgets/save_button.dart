import 'package:flutter/material.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/core/repository/page_repository.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<MarkerRepository>().newMarker != null) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: CircleAvatar(
          backgroundColor: Colors.green,
          maxRadius: 25,
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.black87,
            ),
            onPressed: () => context
                .read<PageRepository>()
                .pageController
                .animateToPage(1,
                    duration: Duration(milliseconds: 500), curve: Curves.ease),
          ),
        ),
      );
    }
    return Container();
  }
}
