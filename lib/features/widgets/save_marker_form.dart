part of 'widgets.dart';

class SaveMarkerForm extends StatelessWidget {
  const SaveMarkerForm({
    Key key,
    @required GlobalKey<FormBuilderState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormBuilderState> _formKey;
  @override
  Widget build(BuildContext context) {
    final markerRepository = context.watch<MarkerRepository>();
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
              initialValue:
                  markerRepository.latitude?.toStringAsFixed(6) ?? null,
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
              initialValue:
                  markerRepository.longitude?.toStringAsFixed(6) ?? null,
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
