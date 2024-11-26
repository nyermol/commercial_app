import 'package:commercial_app/data/models/remark_api.dart';
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/remark_data.dart';
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
  State<RemarksListTextField> createState() => _RemarksListTextFieldState();
}

class _RemarksListTextFieldState extends State<RemarksListTextField> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_scrollIfNeeded);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_scrollIfNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollIfNeeded() {
    if (_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderObject? object = context.findRenderObject();
        if (object is RenderBox) {
          final Offset offset = object.localToGlobal(
            Offset.zero,
          );
          final double screenHeight = MediaQuery.of(context).size.height;
          final double keyboardHeight =
              MediaQuery.of(context).viewInsets.bottom;
          final double remainingSpace =
              screenHeight - offset.dy - keyboardHeight;
          if (remainingSpace < SizeConfig.screenHeight * 0.4) {
            _scrollController.animateTo(
              _scrollController.position.pixels +
                  (SizeConfig.screenHeight * 0.4 - remainingSpace),
              duration: const Duration(
                milliseconds: 300,
              ),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: TypeAheadField<RemarkApi?>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: widget.controller,
                focusNode: _focusNode,
                cursorColor: const Color(0xFF24555E),
                style: const TextStyle(
                  fontSize: textFontSize,
                ),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  widget.onAdd();
                },
                scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      SizeConfig.screenHeight * 0.4,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    textRegExp,
                  ),
                ],
                decoration: InputDecoration(
                  hintText: S.of(context).remarks,
                  hintStyle: const TextStyle(
                    fontSize: textFontSize,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF24555E),
                    ),
                  ),
                  errorText: widget.errorText(),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  errorStyle: const TextStyle(
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
              suggestionsCallback: (String query) async {
                if (query.isEmpty) {
                  return <RemarkApi?>[];
                }
                return await RemarkData.getRemarkSuggestions(query);
              },
              itemBuilder: (BuildContext context, RemarkApi? suggestion) {
                final RemarkApi remark = suggestion!;
                return ListTile(
                  visualDensity: const VisualDensity(
                    vertical: -4,
                  ),
                  title: SubstringHighlight(
                    text: remark.remarkText,
                    term: widget.controller.text,
                    textStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: remarksFontSize,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textStyleHighlight: const TextStyle(
                      color: Color(0xFF24555E),
                      fontSize: remarksFontSize,
                    ),
                  ),
                  subtitle: SubstringHighlight(
                    text: remark.gost ?? '',
                    term: widget.controller.text,
                    textStyleHighlight: const TextStyle(
                      color: Color(0xFF24555E),
                      fontSize: remarksFontSize,
                    ),
                    textStyle: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: remarksFontSize,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              noItemsFoundBuilder: (BuildContext context) => SizedBox(
                height: SizeConfig.screenHeight * 0.05,
                child: Center(
                  child: Text(S.of(context).remarksNotFound),
                ),
              ),
              onSuggestionSelected: (RemarkApi? suggestion) {
                final RemarkApi remark = suggestion!;
                widget.onSuggestionSelected(
                  remark.remarkText,
                  remark.gost!,
                );
              },
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                constraints: BoxConstraints(
                  maxHeight: SizeConfig.screenHeight * 0.3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
