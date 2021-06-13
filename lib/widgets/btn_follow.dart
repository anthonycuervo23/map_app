part of 'widgets.dart';

class BtnFollow extends StatelessWidget {
  const BtnFollow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      builder: (BuildContext context, state) {
        return this._showBtn(context);
      },
    );
  }

  Widget _showBtn(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        maxRadius: 25,
        child: IconButton(
            icon: Icon(
              mapBloc.state.followRoute
                  ? Icons.directions_run
                  : Icons.accessibility,
              color: Colors.black87,
            ),
            onPressed: () {
              mapBloc.add(OnFollowRoute());
            }),
      ),
    );
  }
}
