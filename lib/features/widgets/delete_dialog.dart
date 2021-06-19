part of 'widgets.dart';

//My Imports

class DeleteAlertDialog extends StatelessWidget {
  final String content;
  const DeleteAlertDialog({
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = (context.watch<MarkerRepository>().latitude +
            context.watch<MarkerRepository>().longitude)
        .toString();
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Do you want to delete this marker?',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(
            onPressed: () {
              context.read<MarkerRepository>().deleteMarker(id);
              Navigator.pop(context);
            },
            child: Text('Ok'))
      ],
    );
  }
}
