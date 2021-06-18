part of 'widgets.dart';

class TextFieldInput extends StatelessWidget {
  TextFieldInput({
    Key key,
    this.name,
    this.initialValue,
    this.inputFormatters,
    this.validator,
    this.inputType,
    this.inputAction,
    this.icon,
    this.hint,
  }) : super(key: key);

  final String name;
  final String initialValue;
  final Function validator;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final IconData icon;
  final String hint;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: size.height * 0.08,
        width: size.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.grey[500].withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
            child: FormBuilderTextField(
          inputFormatters: inputFormatters,
          name: name,
          initialValue: initialValue,
          validator: validator,
          keyboardType: inputType,
          textInputAction: inputAction,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                icon,
                size: 28,
                color: Colors.black87,
              ),
            ),
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 22, color: Colors.white, height: 1.5),
          ),
          style: TextStyle(fontSize: 22, color: Colors.white, height: 1.5),
        )),
      ),
    );
  }
}
