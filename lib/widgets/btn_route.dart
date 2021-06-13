part of 'widgets.dart';

class BtnRoute extends StatelessWidget {
  const BtnRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black87,
            ),
            onPressed: () {
              mapBloc.add(OnShowRoute());
            }),
      ),
    );
  }
}
