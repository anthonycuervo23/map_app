import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//My imports
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/core/repository/page_repository.dart';
import 'package:map_app/features/widgets/widgets.dart';


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
    Size size = MediaQuery.of(context).size;
    final pageController = context.watch<PageRepository>().pageController;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              FocusManager.instance.primaryFocus.unfocus();
              pageController.animateToPage(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }),
      ),
      body: ListView(
        children: [
          Image.asset('assets/image/logo_splash.png',
              width: size.width * 0.20, height: size.height * 0.20),
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
                        FocusManager.instance.primaryFocus.unfocus();
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
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
