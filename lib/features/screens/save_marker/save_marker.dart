import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:map_app/core/repository/marker_repository.dart';
import 'package:map_app/core/utils/decimalTextInputFormatter.dart';
import 'package:map_app/features/widgets/alert_dialog.dart';
import 'package:map_app/features/widgets/reusable_button.dart';
import 'package:map_app/features/widgets/reusable_card.dart';
import 'package:map_app/features/widgets/text_field_container.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                            .createMarker(data);
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

class SaveMarkerForm extends StatelessWidget {
  const SaveMarkerForm({
    Key key,
    @required GlobalKey<FormBuilderState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Save a new marker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextFieldInput(
              name: 'name',
              hint: 'Marker name',
              icon: Icons.drive_file_rename_outline,
              validator: FormBuilderValidators.required(context),
              inputAction: TextInputAction.next,
            ),
            TextFieldInput(
              name: 'lat',
              hint: 'latitude',
              inputFormatters: [
                DecimalTextInputFormatter(decimalRange: 6, signed: false)
              ],
              icon: Icons.add_location_alt,
              validator: FormBuilderValidators.required(context),
              inputAction: TextInputAction.next,
              inputType: TextInputType.number,
            ),
            TextFieldInput(
              name: 'long',
              hint: 'longitude',
              inputFormatters: [
                DecimalTextInputFormatter(decimalRange: 6, signed: false)
              ],
              icon: Icons.add_location_alt,
              validator: FormBuilderValidators.required(context),
              inputAction: TextInputAction.done,
              inputType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}
