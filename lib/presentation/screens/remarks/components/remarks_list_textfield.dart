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
  final void Function(String title, String gost) onSuggestionSelected;

  const RemarksListTextField({
    super.key,
    required this.controller,
    required this.onAdd,
    required this.onSuggestionSelected,
  });

  @override
  State<RemarksListTextField> createState() => _RemarksListTextFieldState();
}

class _RemarksListTextFieldState extends State<RemarksListTextField> {
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  // Инициализация значений
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_scrollIfNeeded);
  }

  // Освобождение памяти
  @override
  void dispose() {
    _focusNode.removeListener(_scrollIfNeeded);
    _scrollController.dispose();
    super.dispose();
  }

  // Метод скролла экрана, если клавиатура перекрывает поле совпадений
  void _scrollIfNeeded() {
    if (_focusNode.hasFocus) {
      // Проверка, перекрывает ли клавиатура поле совпадений
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
          // Если клавиатура перекрывает поле совпадений, то прокрутить экран вверх на 40% экрана
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
            // Поле ввода текста с отображением поля совпадений
            child: TypeAheadField<RemarkApi?>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: widget.controller,
                focusNode: _focusNode,
                cursorColor: mainColor,
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
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: mainColor,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: widget.onAdd,
                  ),
                ),
              ),
              // Поиск и отображение совпадений на основе вводимого текста
              suggestionsCallback: (String query) async {
                if (query.isEmpty) {
                  return <RemarkApi?>[];
                }
                try {
                  return await RemarkData.getRemarkSuggestions(query);
                } catch (e) {
                  showCustomDialog(
                    context: context,
                    title: 'Ошибка при получении списка совпадений',
                    content: Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'ОК',
                          style: TextStyle(
                            fontSize: mainFontSize,
                            color: mainColor,
                          ),
                        ),
                      ),
                    ],
                  );
                  return <RemarkApi?>[];
                }
              },
              // Построение списка элементов поля совпадений
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
                    textStyleHighlight: TextStyle(
                      color: mainColor,
                      fontSize: remarksFontSize,
                    ),
                  ),
                  subtitle: SubstringHighlight(
                    text: remark.gost ?? '',
                    term: widget.controller.text,
                    textStyleHighlight: TextStyle(
                      color: mainColor,
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
              // Сообщение, если совпадений не найдено
              noItemsFoundBuilder: (BuildContext context) => SizedBox(
                height: SizeConfig.screenHeight * 0.05,
                child: Center(
                  child: Text(S.of(context).remarksNotFound),
                ),
              ),
              // Обработка выбора
              onSuggestionSelected: (RemarkApi? suggestion) {
                final RemarkApi remark = suggestion!;
                widget.onSuggestionSelected(
                  remark.remarkText,
                  remark.gost!,
                );
              },
              // Настройки отображения поля совпадений
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
