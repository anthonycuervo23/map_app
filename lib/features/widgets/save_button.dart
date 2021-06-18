part of 'widgets.dart';

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
