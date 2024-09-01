// ignore_for_file: always_specify_types

import 'dart:io';

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class RemarksList extends StatefulWidget {
  final String title;
  final String itemsKey;
  final bool isListEmpty;
  final Function(int) onItemDismiss;
  const RemarksList({
    super.key,
    required this.title,
    required this.itemsKey,
    this.isListEmpty = false,
    required this.onItemDismiss,
  });
  @override
  State<RemarksList> createState() => _RemarksListState();
}

class _RemarksListState extends State<RemarksList> {
  final List<Map<String, dynamic>> _itemsList = <Map<String, dynamic>>[];
  final TextEditingController _listController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListCubit>().loadDataList(widget.itemsKey).then((_) {
        if (!mounted) return;
        setState(() {
          _itemsList.clear();
          Map<String, dynamic> state = context.read<ListCubit>().state;
          List<dynamic> items = state[widget.itemsKey] ?? [];
          for (var item in items) {
            _itemsList.add(Map<String, dynamic>.from(item));
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _onTitleSave(String title, int index) {
    _itemsList[index]['title'] = title;
    setState(() {});
    _saveList();
  }

  void _addSubtitle(String subtitle, int index) {
    _itemsList[index]['subtitle'] = subtitle;
    setState(() {});
    _saveList();
  }

  void _addItem() {
    String newItem = _listController.text.trim();
    if (newItem.isNotEmpty) {
      _itemsList
          .add({'title': newItem, 'subtitle': '', 'images': [], 'gost': ''});
      int newIndex = _itemsList.length - 1;
      setState(() {});
      _listController.clear();
      _saveList();
      if (context.read<RoomCubit>().selectedRooms.isNotEmpty) {
        _setRoom(newIndex);
      }
    }
  }

  void _addRemark(String remarkText, String gost) {
    _itemsList
        .add({'title': remarkText, 'subtitle': '', 'images': [], 'gost': gost});
    int newIndex = _itemsList.length - 1;
    setState(() {});
    _listController.clear();
    _saveList();
    if (context.read<RoomCubit>().selectedRooms.isNotEmpty) {
      _setRoom(newIndex);
    }
  }

  void _setRoom(int index) {
    _showOptionsDialog(
      context: context,
      currentItem: _itemsList[index]['subtitle'] ?? '',
      index: index,
      addSubtitle: _addSubtitle,
    );
  }

  void _saveList() {
    List<Map<String, dynamic>> formattedList =
        _itemsList.map((Map<String, dynamic> item) {
      return item.map((String key, value) {
        return MapEntry(key, value);
      });
    }).toList();
    context.read<ListCubit>().saveDataList(widget.itemsKey, formattedList);
  }

  Future<void> _onPickImage(int index) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List imageData = await image.readAsBytes();
      img.Image originalImage = img.decodeImage(imageData)!;
      int width = originalImage.width;
      int height = originalImage.height;
      int size = width < height ? width : height;
      int xOffset = (width - size) ~/ 2;
      int yOffset = (height - size) ~/ 2;
      img.Image croppedImage = img.copyCrop(
        originalImage,
        x: xOffset,
        y: yOffset,
        width: size,
        height: size,
      );
      List<int> encodedImage = img.encodeJpg(croppedImage);
      String extension = image.path.split('.').last;
      String shortName =
          'img_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final Directory directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/$shortName';
      File(imagePath).writeAsBytesSync(encodedImage);
      if (_itemsList[index]['images'] == null) {
        _itemsList[index]['images'] = [];
      }
      (_itemsList[index]['images'] as List).add(imagePath);
      setState(() {});
      _saveList();
    }
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required String currentItem,
    required int index,
    required Function(String, int) onSave,
  }) async {
    final TextEditingController editItemController =
        TextEditingController(text: currentItem);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            S.of(context).remarksEdit,
            style: const TextStyle(fontSize: mainFontSize),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            cursorColor: const Color.fromRGBO(236, 129, 49, 1),
            style: const TextStyle(fontSize: mainFontSize),
            controller: editItemController,
            autofocus: true,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(textRegExp),
            ],
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(236, 129, 49, 1)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(context).save,
                style: const TextStyle(
                  fontSize: mainFontSize,
                  color: Color.fromRGBO(236, 129, 49, 1),
                ),
              ),
              onPressed: () {
                onSave(editItemController.text, index);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showOptionsDialog({
    required BuildContext context,
    required String? currentItem,
    required int index,
    required Function(String, int) addSubtitle,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<RoomCubit, Map<String, dynamic>>(
          builder: (BuildContext context, Map<String, dynamic> state) {
            final selectedRooms = state['selectedRooms'] ?? <String>[];
            if (selectedRooms.isEmpty) {
              return AlertDialog(
                title: Text(
                  S.of(context).specifyRoom,
                  style: const TextStyle(fontSize: mainFontSize),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                        S.of(context).roomsNotSelected,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: mainFontSize),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return AlertDialog(
                title: Text(
                  S.of(context).specifyRoom,
                  style: const TextStyle(fontSize: mainFontSize),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: List.generate(
                      selectedRooms.length,
                      (int i) => ListTile(
                        title: Text(
                          selectedRooms[i],
                          style: const TextStyle(fontSize: 22),
                        ),
                        onTap: () {
                          addSubtitle(selectedRooms[i], index);
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListCubit, Map<String, dynamic>>(
      builder: (BuildContext context, Map<String, dynamic> state) {
        List<Map<String, dynamic>> itemList =
            state[widget.itemsKey] ?? <Map<String, dynamic>>[];
        String? errorText() {
          if (widget.isListEmpty) {
            return S.of(context).noRemarks;
          }
          return null;
        }

        return Container(
          margin: getContainerMargin(context, 0.01),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: mainFontSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                RemarksListTextField(
                  controller: _listController,
                  onAdd: _addItem,
                  errorText: errorText,
                  onSuggestionSelected: (String remarkText, String gost) {
                    _addRemark(remarkText, gost);
                  },
                ),
                itemList.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: SizeConfig.screenHeight * 0.01,
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).listEmpty,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: mainFontSize),
                          ),
                        ),
                      )
                    : RemarksListDisplay(
                        items: itemList,
                        onDismissed: widget.onItemDismiss,
                        onTap: (int index) => _showEditDialog(
                          context: context,
                          currentItem: itemList[index]['title']!,
                          index: index,
                          onSave: _onTitleSave,
                        ),
                        onLongPress: (int index) => _showOptionsDialog(
                          context: context,
                          currentItem: itemList[index]['subtitle'] ?? '',
                          index: index,
                          addSubtitle: _addSubtitle,
                        ),
                        iconPressed: (int index) => _onPickImage(index),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
