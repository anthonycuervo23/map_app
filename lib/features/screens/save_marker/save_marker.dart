import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/features/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SaveMarkerScreen extends StatefulWidget {
  const SaveMarkerScreen({Key key}) : super(key: key);

  @override
  _SaveMarkerScreenState createState() => _SaveMarkerScreenState();
}

class _SaveMarkerScreenState extends State<SaveMarkerScreen> {
  bool _processing;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _processing = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image.asset('assets/image/logo_splash.png'),
          SaveMarkerForm(formKey: _formKey),
          ReusableButton(
              child: _processing
                  ? CircularProgressIndicator()
                  : Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: _processing
                  ? null
                  : () async {
                      bool validated = _formKey.currentState.validate();
                      if (validated) {
                        _formKey.currentState.save();
                        final data = Map<String, dynamic>.from(
                            _formKey.currentState.value);
                        data['lat'] = double.parse(data['lat']);
                        data['long'] = double.parse(data['long']);
                        await context
                            .read<MarkerRepository>()
                            .createMarker(data)
                            .then((value) => _formKey.currentState.reset());
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) => ErrorAlertDialog(
                            content: 'Algo ha salido mal, intenta de nuevo',
                          ),
                        );
                      }
                    }),
        ],
      ),
    );
  }
}
