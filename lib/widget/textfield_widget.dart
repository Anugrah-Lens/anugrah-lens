import 'package:anugrah_lens/style/color_style.dart';
import 'package:anugrah_lens/style/font_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ////////////////////////// formating number field //////////////////////////
// class NumberInputFormatter extends TextInputFormatter {
//   final NumberFormat numberFormat = NumberFormat.decimalPattern('en_US');

//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     if (newValue.text.isEmpty) {
//       return newValue;
//     }

//     // Check if the input can be parsed to a number
//     final newText = newValue.text;
//     final numericText = newText.replaceAll(RegExp(r'[^0-9]'), '');

//     if (numericText.isEmpty) {
//       // Allow non-numeric input (e.g., letters) to pass through
//       return newValue;
//     }

//     // Convert to number and then format it
//     final intValue = int.tryParse(numericText);
//     if (intValue == null) {
//       return newValue;
//     }

//     final formattedText = numberFormat.format(intValue);

//     return newValue.copyWith(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final double width;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  TextFieldWidget({
    Key? key,
    this.onChanged,
    this.inputFormatters,
    required this.hintText,
    this.width = double.infinity,
    this.controller,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        onChanged: widget.onChanged,
        controller: widget.controller,
        keyboardType: TextInputType.text,
        inputFormatters: widget.inputFormatters,
        // [
        //   NumberInputFormatter(),
        // ],
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: FontFamily.caption.copyWith(
            color: ColorStyle.disableColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorStyle.disableColor, // Warna stroke ketika tidak fokus
              width: 1.5, // Lebar stroke
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorStyle.primaryColor, // Warna stroke ketika fokus
              width: 1.5, // Lebar stroke ketika fokus
            ),
          ),
        ),
      ),
    );
  }
}

class SearchDropdownField extends StatefulWidget {
  final List<String> items;
  final String hintText;
  final TextEditingController? controller;
  final Widget? suffixIcons;
  final Widget? prefixIcons;

  const SearchDropdownField(
      {Key? key,
      required this.items,
      required this.hintText,
      this.controller,
      this.prefixIcons,
      this.suffixIcons})
      : super(key: key);

  @override
  _SearchDropdownFieldState createState() => _SearchDropdownFieldState();
}

class _SearchDropdownFieldState extends State<SearchDropdownField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Dispose of the controller if it was created within this widget
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return widget.items;
        }
        return widget.items.where((String item) {
          return item
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        _controller.text = selection;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        // Update the text editing controller if needed
        _controller = textEditingController;
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: FontFamily.caption.copyWith(
              color: ColorStyle.disableColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color:
                    ColorStyle.disableColor, // Warna stroke ketika tidak fokus
                width: 1.5, // Lebar stroke
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: ColorStyle.primaryColor, // Warna stroke ketika fokus
                width: 1.5, // Lebar stroke ketika fokus
              ),
            ),
            prefixIcon: widget.prefixIcons,
            suffixIcon: widget.suffixIcons,
          ),
        );
      },
    );
  }
}

class TextFieldCalenderWidget extends StatefulWidget {
  final String hintText;
  final double width;
  final TextEditingController? controller;
  TextFieldCalenderWidget({
    Key? key,
    required this.hintText,
    this.width = double.infinity,
    this.controller,
  }) : super(key: key);

  @override
  State<TextFieldCalenderWidget> createState() =>
      _TextFieldCalenderWidgetState();
}

class _TextFieldCalenderWidgetState extends State<TextFieldCalenderWidget> {
  // TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextField(
        readOnly: true, // Membuat TextField tidak bisa diubah
        controller: widget
            .controller, // Mengatur controller TextField dengan controller yang diberikan
        // focusNode: focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: FontFamily.caption.copyWith(
            color: ColorStyle.disableColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorStyle.disableColor, // Warna stroke ketika tidak fokus
              width: 1.5, // Lebar stroke
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorStyle.primaryColor, // Warna stroke ketika fokus
              width: 1.5, // Lebar stroke ketika fokus
            ),
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.calendar_today,
              color: ColorStyle.primaryColor,
            ), // Ikon kalender
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Tanggal awal
                firstDate: DateTime(2000), // Batasan tanggal terawal
                lastDate: DateTime(2101), // Batasan tanggal terakhir
              );

              if (pickedDate != null) {
                //date formatnya 27 februari 2022
                String formattedDate =
                    DateFormat('dd MMMM yyyy').format(pickedDate);
                setState(() {
                  widget.controller!.text = formattedDate;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class TextFieldColumnWiget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const TextFieldColumnWiget({
    super.key,
    this.inputFormatters,
    required this.onChanged,
    required this.hintText,
    this.controller,
  });

  @override
  State<TextFieldColumnWiget> createState() => _TextFieldColumnWigetState();
}

class _TextFieldColumnWigetState extends State<TextFieldColumnWiget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        inputFormatters: widget.inputFormatters,
        controller: TextEditingController(text: widget.controller!.text),
        onChanged: widget.onChanged,
        decoration: InputDecoration(hintText: widget.hintText),
      ),
    );
  }
}
