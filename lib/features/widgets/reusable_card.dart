part of 'widgets.dart';

class DefaultCard extends StatelessWidget {
  final Widget child;

  DefaultCard({this.child});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Card(
        elevation: 0,
        color: Colors.indigo,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all((Radius.circular(10)))),
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: child,
        ),
      ),
    );
  }
}
