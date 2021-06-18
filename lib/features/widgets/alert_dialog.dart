part of 'widgets.dart';

//My Imports

class ErrorAlertDialog extends StatelessWidget {
  final String content;
  const ErrorAlertDialog({
    this.content,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.blueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('ERROR',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Close'))
      ],
    );
  }
}
