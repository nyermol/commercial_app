// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously, always_specify_types

import 'dart:html' as html;
import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;

class RemarksList extends StatefulWidget {
  final String title;
  final String itemsKey;
  final bool isListEmpty;
  const RemarksList({
    super.key,
    required this.title,
    required this.itemsKey,
    this.isListEmpty = false,
  });
  @override
  State<RemarksList> createState() => _RemarksListState();
}

class _RemarksListState extends State<RemarksList> {
  final List<Remark> _itemsList = <Remark>[];
  final TextEditingController _listController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RemarksCubit>().loadDataList(widget.itemsKey).then((_) {
        if (!mounted) return;
        setState(() {
          List<Remark> items =
              context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
          _itemsList.clear();
          _itemsList.addAll(items);
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
    _itemsList[index] = Remark(
      title: title,
      subtitle: _itemsList[index].subtitle,
      gost: _itemsList[index].gost,
      images: _itemsList[index].images,
    );
    context.read<RemarksCubit>().saveDataList(widget.itemsKey, _itemsList);
  }

  void _addSubtitle(String subtitle, int index) {
    _itemsList[index] = Remark(
      title: _itemsList[index].title,
      subtitle: subtitle,
      gost: _itemsList[index].gost,
      images: _itemsList[index].images,
    );
    context.read<RemarksCubit>().saveDataList(widget.itemsKey, _itemsList);
  }

  void _addItem() {
    String newItem = _listController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        _itemsList.add(
          Remark(
            title: newItem,
            subtitle: '',
            gost: '',
            images: [],
          ),
        );
      });
      _listController.clear();
      context.read<RemarksCubit>().saveDataList(widget.itemsKey, _itemsList);
      _setRoom(_itemsList.length - 1);
    }
  }

  void _addRemark(String remarkText, String gost) {
    setState(() {
      _itemsList.add(
        Remark(
          title: remarkText,
          subtitle: '',
          gost: gost,
          images: [],
        ),
      );
    });
    _listController.clear();
    context.read<RemarksCubit>().saveDataList(widget.itemsKey, _itemsList);
    _setRoom(_itemsList.length - 1);
  }

  void _setRoom(int index) {
    _showOptionsDialog(
      context: context,
      currentItem: _itemsList[index].subtitle,
      index: index,
      addSubtitle: _addSubtitle,
    );
  }

  void _deleteItem(int index) {
    setState(() {
      _itemsList.removeAt(index);
    });
    context.read<RemarksCubit>().deleteRemark(widget.itemsKey, index);
  }

  void _onPickImage(int index) async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.setAttribute(
      'capture',
      'camera',
    );
    uploadInput.click();
    uploadInput.onChange.listen((
      html.Event event,
    ) async {
      showCustomDialog(
        context: context,
        title: '',
        barrierDismissible: false,
        content: SizedBox(
          height: SizeConfig.screenHeight * 0.12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).photoWait,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.01,
              ),
              const CircularProgressIndicator(
                color: Color(0xFF24555E),
              ),
            ],
          ),
        ),
      );
      final List<html.File>? files = uploadInput.files;
      if (files!.isNotEmpty) {
        final html.FileReader reader = html.FileReader();
        reader.readAsArrayBuffer(
          files[0],
        );
        reader.onLoadEnd.listen((
          html.ProgressEvent event,
        ) async {
          Uint8List imageData = reader.result as Uint8List;
          img.Image? originalImage = img.decodeImage(imageData);
          if (originalImage != null) {
            img.Image croppedImage = cropImage(originalImage);
            Uint8List croppedImageData = Uint8List.fromList(
              img.encodeJpg(croppedImage),
            );
            String shortName =
                'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
            await imagesBox.put(shortName, croppedImageData);
            setState(() {
              _itemsList[index] = Remark(
                title: _itemsList[index].title,
                subtitle: _itemsList[index].subtitle,
                gost: _itemsList[index].gost,
                images: [..._itemsList[index].images, shortName],
              );
            });
            Navigator.of(context).pop();
            context
                .read<RemarksCubit>()
                .saveDataList(widget.itemsKey, _itemsList);
            setState(() {});
          }
        });
      }
    });
  }

  img.Image cropImage(img.Image originalImage) {
    int width = originalImage.width;
    int height = originalImage.height;
    int size = width < height ? width : height;
    int xOffset = (width - size) ~/ 2;
    int yOffset = (height - size) ~/ 2;
    return img.copyCrop(
      originalImage,
      x: xOffset,
      y: yOffset,
      width: size,
      height: size,
    );
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required String currentItem,
    required int index,
    required Function(String, int) onSave,
    required Function(int) onDelete,
  }) async {
    final TextEditingController editItemController = TextEditingController(
      text: currentItem,
    );
    return showCustomDialog(
      context: context,
      title: S.of(context).remarksEdit,
      content: TextField(
        cursorColor: const Color(0xFF24555E),
        style: const TextStyle(
          fontSize: mainFontSize,
        ),
        controller: editItemController,
        textInputAction: TextInputAction.done,
        onSubmitted: (String value) {
          onSave(editItemController.text, index);
          Navigator.of(context).pop();
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
            textRegExp,
          ),
        ],
        minLines: 1,
        maxLines: 5,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF24555E),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).delete,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _showDeleteConfirmationDialog(
              context: context,
              index: index,
              onDelete: onDelete,
              currentItem: currentItem,
              onSave: onSave,
            );
          },
        ),
        TextButton(
          child: Text(
            S.of(context).save,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Color(0xFF24555E),
            ),
          ),
          onPressed: () {
            onSave(
              editItemController.text,
              index,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> _showOptionsDialog({
    required BuildContext context,
    required String? currentItem,
    required int index,
    required Function(String, int) addSubtitle,
  }) async {
    return showCustomDialog(
      context: context,
      title: S.of(context).specifyRoom,
      content: BlocBuilder<RoomCubit, Map<String, List<Room>>>(
        builder: (BuildContext context, Map<String, List<Room>> state) {
          final List<Room> selectedRooms = state['selectedRooms'] ?? <Room>[];
          if (selectedRooms.isEmpty) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    S.of(context).roomsNotSelected,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListBody(
                children: List.generate(
                  selectedRooms.length,
                  (int i) => ListTile(
                    title: Text(
                      selectedRooms[i].name,
                      style: const TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    onTap: () {
                      addSubtitle(
                        selectedRooms[i].name,
                        index,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog({
    required BuildContext context,
    required int index,
    required Function(int) onDelete,
    required String currentItem,
    required Function(String, int) onSave,
  }) async {
    return showCustomDialog(
      context: context,
      title: S.of(context).removeRemark,
      content: const SizedBox.shrink(),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).yes,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onDelete(index);
          },
        ),
        TextButton(
          child: Text(
            S.of(context).no,
            style: const TextStyle(
              fontSize: mainFontSize,
              color: Color(0xFF24555E),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _showEditDialog(
              context: context,
              currentItem: currentItem,
              index: index,
              onSave: onSave,
              onDelete: onDelete,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemarksCubit, Map<String, List<Remark>>>(
      builder: (BuildContext context, Map<String, List<Remark>> state) {
        List<Remark> itemList = state[widget.itemsKey] ?? <Remark>[];
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
                  onSuggestionSelected: (
                    String remarkText,
                    String gost,
                  ) {
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
                            style: const TextStyle(
                              fontSize: textFontSize,
                            ),
                          ),
                        ),
                      )
                    : RemarksListDisplay(
                        items: itemList,
                        onTap: (int index) => _showEditDialog(
                          context: context,
                          currentItem: itemList[index].title,
                          index: index,
                          onSave: _onTitleSave,
                          onDelete: (int index) {
                            _deleteItem(index);
                          },
                        ),
                        onLongPress: (int index) => _setRoom(index),
                        iconPressed: (int index) => _onPickImage(index),
                        itemsKey: widget.itemsKey,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
