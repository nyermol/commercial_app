// ignore_for_file: library_private_types_in_public_api

import 'package:commercial_app/data/datasources/remote/remark_api.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:substring_highlight/substring_highlight.dart';

class RemarksListTextField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;
  final String? Function() errorText;
  final void Function(String title, String gost) onSuggestionSelected;

  const RemarksListTextField({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.errorText,
    required this.onSuggestionSelected,
  });

  @override
  _RemarksListTextFieldState createState() => _RemarksListTextFieldState();
}

class _RemarksListTextFieldState extends State<RemarksListTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TypeAheadField<Remark?>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: widget.controller,
              cursorColor: Colors.teal,
              style: const TextStyle(fontSize: mainFontSize),
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(textRegExp),
              ],
              decoration: InputDecoration(
                hintText: S.of(context).remarks,
                hintStyle: const TextStyle(fontSize: mainFontSize),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                errorText: widget.errorText(),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                errorStyle: const TextStyle(fontSize: subtitleFontSize),
              ),
            ),
            suggestionsCallback: (String query) async {
              if (query.isEmpty) {
                return <Remark?>[];
              }
              return await RemarkApi.getRemarkSuggestions(query);
            },
            itemBuilder: (BuildContext context, Remark? suggestion) {
              final Remark remark = suggestion!;
              return ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                title: SubstringHighlight(
                  text: remark.remarkText,
                  term: widget.controller.text,
                  textStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: subtitleFontSize,
                  ),
                  textStyleHighlight: const TextStyle(
                    color: Colors.teal,
                    fontSize: subtitleFontSize,
                  ),
                ),
                subtitle: SubstringHighlight(
                  text: remark.gost ?? '',
                  term: widget.controller.text,
                  textStyleHighlight: const TextStyle(
                    color: Colors.teal,
                    fontSize: subtitleFontSize,
                  ),
                  textStyle: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: subtitleFontSize,
                    color: Colors.grey,
                  ),
                ),
              );
            },
            noItemsFoundBuilder: (BuildContext context) => SizedBox(
              height: SizeConfig.screenHeight * 0.05,
              child: Center(
                child: Text(
                  S.of(context).remarksNotFound,
                ),
              ),
            ),
            onSuggestionSelected: (Remark? suggestion) {
              final Remark remark = suggestion!;
              widget.onSuggestionSelected(remark.remarkText, remark.gost!);
            },
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              constraints: BoxConstraints(
                maxHeight: SizeConfig.screenHeight * 0.2,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.onAdd,
        ),
      ],
    );
  }
}
