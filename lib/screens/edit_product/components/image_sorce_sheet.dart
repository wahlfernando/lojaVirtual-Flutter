import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSoucesheet extends StatelessWidget {
  ImageSoucesheet({this.onImageSelected});

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  Future<void> editImage(String path, BuildContext context) async{
    final File croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar Imagem',
        toolbarColor: Theme.of(context).primaryColor,
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Editar Imagem',
        cancelButtonTitle: 'Cancelar',
        doneButtonTitle: 'Concluir',
      ),
    );
    if(croppedFile != null){
      onImageSelected(croppedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlatButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.camera);
                editImage(file.path, context);
              },
              child: const Text(
                'Câmera',
                style: TextStyle(fontSize: 18),
              ),
            ),
            FlatButton(
              onPressed: () async {
                final PickedFile file =
                    await picker.getImage(source: ImageSource.gallery);
                editImage(file.path, context);
              },
              child: const Text(
                'Galeria',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o Item'),
        message: const Text('Escolha a origem da foto.'),
        cancelButton: CupertinoActionSheetAction(
            child:  Text('Cancelar'), onPressed: Navigator.of(context).pop),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () async {
              final PickedFile file =
                  await picker.getImage(source: ImageSource.camera);
              editImage(file.path, context);
            },
            child: const Text('Câmera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final PickedFile file =
                  await picker.getImage(source: ImageSource.gallery);
              editImage(file.path, context);
            },
            child: const Text('Galeria'),
          ),
        ],
      );
    }
  }
}
