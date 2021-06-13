part of 'main_helpers.dart';

void calculatingAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Center(child: Text('Please wait...')),
            content: Text(
              'We are calculating your route',
              textAlign: TextAlign.center,
            ),
          ));
}
