import 'package:commercial_app/core/styles/styles_export.dart';
import 'package:commercial_app/core/utils/utils_export.dart';
import 'package:commercial_app/data/models/models_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/generated/l10n.dart';
import 'package:commercial_app/services/service_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class PhotoGallery {
  static Future<void> showImagesGridDialog(
    BuildContext context,
    String remarkKey,
    int remarkIndex,
  ) async {
    return showCustomDialog(
      context: context,
      title: S.of(context).photoPreviewForRemark,
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: BlocBuilder<RemarksCubit, Map<String, List<Remark>>>(
            builder: (BuildContext context, Map<String, List<Remark>> state) {
              final List<Remark> currentList = state[remarkKey] ?? <Remark>[];
              if (remarkIndex >= currentList.length) return const SizedBox();
              final Remark remark = currentList[remarkIndex];
              final List<String> images = remark.images;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    remark.title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: textFontSize,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 8),
                  if (images.isEmpty)
                    Center(
                      child: Text(S.of(context).photosNotAdded),
                    )
                  else if (images.length == 1)
                    Center(
                      child: _buildGridItem(
                        context,
                        images.first,
                        remarkKey,
                        remarkIndex,
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildGridItem(
                          context,
                          images[index],
                          remarkKey,
                          remarkIndex,
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
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
          },
        ),
      ],
    );
  }

  static Widget _buildGridItem(
    BuildContext context,
    String imagePath,
    String remarkKey,
    int remarkIndex,
  ) {
    final Box<Uint8List> imagesBox = Hive.box<Uint8List>('imagesBox');
    Uint8List? imageData = imagesBox.get(imagePath);
    return GestureDetector(
      onTap: () {
        if (imageData != null) {
          showImagePreview(
            context,
            imageData,
            imagePath,
            remarkKey,
            remarkIndex,
          );
        }
      },
      child: Hero(
        tag: imagePath,
        child: imageData != null
            ? Image.memory(
                imageData,
                fit: BoxFit.cover,
              )
            : const SizedBox(),
      ),
    );
  }

  static Future<void> showImagePreview(
    BuildContext context,
    Uint8List imageData,
    String imageName,
    String remarkKey,
    int remarkIndex,
  ) async {
    return showCustomDialog(
      context: context,
      title: S.of(context).imagePreview,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Hero(
            tag: imageName,
            child: Image.memory(imageData),
          ),
          Text(
            imageName,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
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
          onPressed: () async {
            Navigator.of(context).pop();
            // Демонстрации диалогового окна для подтверждения удаления элемента
            showDeleteConfirmationDialog(
              context: context,
              index: remarkIndex,
              currentItem: imageName,
              onDelete: (_) async {
                await context
                    .read<RemarksCubit>()
                    .removeImage(remarkKey, remarkIndex, imageName);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              onSave: (_, __) {},
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        TextButton(
          child: Text(
            S.of(context).leave,
            style: TextStyle(
              fontSize: mainFontSize,
              color: mainColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
