// ignore_for_file: use_build_context_synchronously, always_specify_types

import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/injection_container.dart';
import 'package:commercial_app/presentation/screens/remarks/components/remarks_export.dart';
import 'package:commercial_app/services/service_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart' as img;

class RemarksList extends StatefulWidget {
  final String title;
  final String itemsKey;
  const RemarksList({
    super.key,
    required this.title,
    required this.itemsKey,
  });
  @override
  State<RemarksList> createState() => _RemarksListState();
}

class _RemarksListState extends State<RemarksList> {
  final TextEditingController _listController = TextEditingController();
  final ImagePickerService _imagePickerService = sl<ImagePickerService>();

  // Инициализация значений
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RemarksCubit>().loadDataList(widget.itemsKey);
    });
  }

  // Освобождение памяти
  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  // Метод для сохранения изменений в записи замечаний
  void _onTitleSave(String title, int index) {
    // Если значение пустое, то в локальное хранилище передается знак "-"
    final String updatedTitle = (title.isEmpty || title == '-') ? '-' : title;
    final List<Remark> currentList =
        context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
    if (index < currentList.length) {
      final Remark updatedRemark =
          currentList[index].copyWith(title: updatedTitle);
      final List<Remark> updatedList = List<Remark>.from(currentList);
      updatedList[index] = updatedRemark;
      context.read<RemarksCubit>().saveDataList(widget.itemsKey, updatedList);
    }
  }

  // Метод добавления наименования помещений в качестве subtitle к замечанию
  void _addSubtitle(String subtitle, bool isGeneralRemark, int index) {
    final List<Remark> currentList =
        context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
    if (index < currentList.length) {
      final Remark updatedRemark = currentList[index].copyWith(
        subtitle: subtitle,
        isGeneralRemark: isGeneralRemark,
      );
      final List<Remark> updatedList = List<Remark>.from(currentList);
      updatedList[index] = updatedRemark;
      context.read<RemarksCubit>().saveDataList(widget.itemsKey, updatedList);
    }
  }

  // Метод добавления нового замечания
  void _addItem() {
    String newItem = _listController.text.trim();
    if (newItem.isNotEmpty) {
      final List<Remark> currentList =
          context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
      final List<Remark> updatedList = List<Remark>.from(currentList)
        ..add(
          Remark(
            title: newItem,
            subtitle: '',
            gost: '',
            images: <String>[],
          ),
        );
      _listController.clear();
      context.read<RemarksCubit>().saveDataList(widget.itemsKey, updatedList);
      _setRoom(updatedList.length - 1);
    }
  }

  // Метод добавления замечания из Firebase Firestore
  void _addRemark(String remarkText, String gost) {
    final List<Remark> currentList =
        context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
    final List<Remark> updatedList = List<Remark>.from(currentList)
      ..add(
        Remark(
          title: remarkText,
          subtitle: '',
          gost: gost,
          images: <String>[],
        ),
      );
    _listController.clear();
    context.read<RemarksCubit>().saveDataList(widget.itemsKey, updatedList);
    _setRoom(updatedList.length - 1);
  }

  // Метод демонстрации диалогового окна для выбора помещения сразу после добавления замечания
  void _setRoom(int index) {
    final List<Remark> currentList =
        context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
    final String currentSubtitle =
        (index < currentList.length) ? currentList[index].subtitle : '';
    _showOptionsDialog(
      context: context,
      currentItem: currentSubtitle,
      index: index,
    );
  }

  // Метод удаления замечания по индексу
  void _deleteItem(int index) {
    context.read<RemarksCubit>().deleteRemark(widget.itemsKey, index);
  }

  // Метод добавления изображения к замечанию
  void _onPickImage(int index) async {
    final Uint8List? rawImage = await _imagePickerService.pickImage();
    if (rawImage == null) {
      return;
    }
    final GlobalKey<ProgressDialogState> progressKey = GlobalKey();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProgressDialog(
        key: progressKey,
        message: S.of(context).photoWait,
      ),
    );
    try {
      final Uint8List cropped = await processImageWithProgress(
        rawImage,
        (double newProgress) =>
            progressKey.currentState?.updateProgress(newProgress),
      );
      String shortName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
      await imagesBox.put(shortName, cropped);
      final String itemsKey = widget.itemsKey;
      final List<Remark> currentList =
          context.read<RemarksCubit>().state[itemsKey] ?? <Remark>[];
      if (index < currentList.length) {
        final Remark updated = currentList[index].copyWith(
          images: <String>[...currentList[index].images, shortName],
        );
        final List<Remark> newList = List<Remark>.from(currentList)
          ..[index] = updated;
        await context.read<RemarksCubit>().saveDataList(itemsKey, newList);
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      showCustomDialog(
        context: context,
        title: S.of(context).errorProcessingImage,
        content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              S.of(context).ok,
            ),
          ),
        ],
      );
    } finally {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  // Метод обрезки изображения до квадрата по наименьшей стороне
  Future<Uint8List> processImageWithProgress(
    Uint8List imageData,
    Function(double) updateProgress,
  ) async {
    updateProgress(0.2);
    final img.Image? originalImage = img.decodeImage(imageData);
    if (originalImage == null) return imageData;
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.4);
    int width = originalImage.width;
    int height = originalImage.height;
    int size = width < height ? width : height;
    int xOffset = (width - size) ~/ 2;
    int yOffset = (height - size) ~/ 2;
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.6);
    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: xOffset,
      y: yOffset,
      width: size,
      height: size,
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(0.8);
    final Uint8List encoded = Uint8List.fromList(
      img.encodeJpg(croppedImage),
    );
    await Future.delayed(
      const Duration(milliseconds: 50),
    );
    updateProgress(1);
    return encoded;
  }

  // Метод демонстрации диалогового окна для редактирования замечания
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
        cursorColor: mainColor,
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
          FilteringTextInputFormatter.allow(textRegExp),
        ],
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: mainColor),
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
            // Демонстрации диалогового окна для подтверждения удаления элемента
            showDeleteConfirmationDialog(
              context: context,
              index: index,
              onDelete: onDelete,
              currentItem: currentItem,
              onSave: onSave,
              onCancel: () {
                Navigator.of(context).pop();
                _showEditDialog(
                  context: context,
                  currentItem: currentItem,
                  index: index,
                  onSave: onSave,
                  onDelete: onDelete,
                );
              },
            );
          },
        ),
        TextButton(
          child: Text(
            S.of(context).save,
            style: TextStyle(
              fontSize: mainFontSize,
              color: mainColor,
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

  // Метод демонстрации диалогового окна для выбора помещения
  Future<void> _showOptionsDialog({
    required BuildContext context,
    required String? currentItem,
    required int index,
  }) async {
    return showCustomDialog(
      barrierDismissible: true,
      context: context,
      title: S.of(context).specifyRoom,
      content: BlocBuilder<RoomCubit, Map<String, List<Room>>>(
        builder: (BuildContext context, Map<String, List<Room>> state) {
          final List<Room> selectedRooms = state['selectedRooms'] ?? <Room>[];
          if (selectedRooms.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    S.of(context).roomsNotSelected,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Общее замечание',
                      style: TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    onTap: () {
                      _addSubtitle('', true, index);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...selectedRooms.map(
                  (room) => ListTile(
                    title: Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    onTap: () {
                      _addSubtitle(room.name, false, index);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Общее замечание',
                    style: TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                  onTap: () {
                    _addSubtitle('', true, index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Метод демонстрации диалогового окна с вариантами при долгом нажатии
  Future<void> _showRemarkOptionsDialog(int index) async {
    final RoomCubit roomCubit = context.read<RoomCubit>();
    final List<Room> selectedRooms = roomCubit.selectedRooms;
    final bool roomsSelected = selectedRooms.isNotEmpty;
    final List<Remark> currentList =
        context.read<RemarksCubit>().state[widget.itemsKey] ?? <Remark>[];
    final Remark remark = currentList[index];
    final bool hasImages = remark.images.isNotEmpty;
    return showCustomDialog(
      barrierDismissible: true,
      context: context,
      title: S.of(context).chooseAction,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: roomsSelected
                ? () async {
                    Navigator.of(context).pop();
                    await _showOptionsDialogWithBack(index);
                  }
                : null,
            child: Text(
              roomsSelected
                  ? S.of(context).changeRoom
                  : S.of(context).roomsNotSelected,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: mainFontSize,
                color: roomsSelected ? mainColor : Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight * 0.03,
          ),
          GestureDetector(
            onTap: hasImages
                ? () async {
                    Navigator.of(context).pop();
                    await _showImagesGridDialog(index);
                  }
                : null,
            child: Text(
              hasImages
                  ? S.of(context).photoPreviewForRemark
                  : S.of(context).photosNotAdded,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: mainFontSize,
                color: hasImages ? mainColor : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Метод выбора помещения с кнопкой "Назад"
  Future<void> _showOptionsDialogWithBack(int index) async {
    return showCustomDialog(
      context: context,
      title: S.of(context).specifyRoom,
      content: BlocBuilder<RoomCubit, Map<String, List<Room>>>(
        builder: (BuildContext context, Map<String, List<Room>> state) {
          final List<Room> selectedRooms = state['selectedRooms'] ?? <Room>[];
          if (selectedRooms.isEmpty) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    S.of(context).roomsNotSelected,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Общее замечание',
                      style: TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    onTap: () {
                      _addSubtitle('', true, index);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...selectedRooms.map(
                  (room) => ListTile(
                    title: Text(
                      room.name,
                      style: const TextStyle(
                        fontSize: mainFontSize,
                      ),
                    ),
                    onTap: () {
                      _addSubtitle(room.name, false, index);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Общее замечание',
                    style: TextStyle(
                      fontSize: mainFontSize,
                    ),
                  ),
                  onTap: () {
                    _addSubtitle('', true, index);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            S.of(context).back,
            style: TextStyle(
              fontSize: mainFontSize,
              color: mainColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _showRemarkOptionsDialog(index);
          },
        ),
      ],
    );
  }

  // Метод демонстрации фотографий к замечанию списком
  Future<void> _showImagesGridDialog(int index) async {
    await PhotoGallery.showImagesGridDialog(
      context,
      widget.itemsKey,
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemarksCubit, Map<String, List<Remark>>>(
      builder: (BuildContext context, Map<String, List<Remark>> state) {
        final List<Remark> itemList = state[widget.itemsKey] ?? <Remark>[];
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
                // Поле ввода замечания
                RemarksListTextField(
                  controller: _listController,
                  onAdd: _addItem,
                  onSuggestionSelected: (
                    String remarkText,
                    String gost,
                  ) {
                    _addRemark(remarkText, gost);
                  },
                ),
                itemList.isEmpty
                    // Если замечаний нет, то указать, что список пуст
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
                    // Если замечания есть, то отобразить список
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
                        onLongPress: (int index) =>
                            _showRemarkOptionsDialog(index),
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
