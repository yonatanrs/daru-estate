import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../misc/dialog_helper.dart';

typedef OnFileCallbackSelected = void Function(FileSelected fileSelected);
typedef OnMultipleFileCallbackSelected = void Function(List<FileSelected> fileSelectedList);

class AttachmentFile extends StatelessWidget {
  final FileSelected? fileSelected;
  final OnFileCallbackSelected? onFileCallbackSelected;
  final OnMultipleFileCallbackSelected? onMultipleFileCallbackSelected;
  final String? selectFileButtonText;

  const AttachmentFile({
    Key? key,
    this.fileSelected,
    this.onFileCallbackSelected,
    this.onMultipleFileCallbackSelected,
    this.selectFileButtonText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 37, right: 37, top: 23, bottom: 25),
        child: Builder(
          builder: (context) {
            List<Widget> widget = <Widget>[
              Center(
                child: InkWell(
                  onTap: () async {
                    FilePickerResult? filePickerResult = await DialogHelper.showChooseFileOrTakePhoto(
                      allowMultipleSelectFiles: onMultipleFileCallbackSelected != null
                    );
                    if (filePickerResult != null) {
                      if (onMultipleFileCallbackSelected != null) {
                        List<FileSelected> fileSelectedList = <FileSelected>[];
                        for (var selectedFile in filePickerResult.files) {
                          String? path = selectedFile.path;
                          if (path != null) {
                            fileSelectedList.add(
                              FileSelected(
                                filePickerResult: filePickerResult,
                                file: selectedFile
                              )
                            );
                          }
                        }
                        onMultipleFileCallbackSelected!(fileSelectedList);
                      } else if (onFileCallbackSelected != null) {
                        String? path = filePickerResult.files.single.path;
                        if (path != null) {
                          onFileCallbackSelected!(
                            FileSelected(
                              filePickerResult: filePickerResult,
                              file: filePickerResult.files.single
                            )
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    width: 257,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                    ),
                    child: Center(
                      child: Text(
                        selectFileButtonText ?? "Select File",
                        style: const TextStyle(color: Colors.white)
                      )
                    ),
                  ),
                )
              )
            ];
            if (fileSelected != null) {
              widget.addAll(<Widget>[
                SizedBox(height: 2.h),
                Text(fileSelected!.filePickerResult.names.single ?? "(Unknown)")
              ]);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget
            );
          }
        )
      ),
    );
  }
}

class PhotoAttachmentFile extends StatelessWidget {
  final String? fileSelected;
  final String? selectFileButtonText;
  final void Function(String)? onImageSelectedWithoutCropping;

  const PhotoAttachmentFile({
    Key? key,
    this.fileSelected,
    this.selectFileButtonText,
    this.onImageSelectedWithoutCropping
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 37, right: 37, top: 23, bottom: 25),
        child: Builder(
          builder: (context) {
            List<Widget> widget = <Widget>[
              Center(
                child: InkWell(
                  onTap: () async {
                    DialogHelper.showSelectingImageDialog(context, onImageSelectedWithoutCropping: onImageSelectedWithoutCropping);
                    return;
                  },
                  child: Container(
                    width: 257,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey
                    ),
                    child: Center(
                      child: Text(
                        selectFileButtonText ?? "Select File",
                        style: const TextStyle(color: Colors.white)
                      )
                    ),
                  ),
                )
              )
            ];
            if (fileSelected != null) {
              widget.addAll(<Widget>[
                SizedBox(height: 2.h),
                Image.file(File(fileSelected!), height: 100)
              ]);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget
            );
          }
        )
      ),
    );
  }
}

class FileSelected {
  FilePickerResult filePickerResult;
  NonNullPathPlatformFile file;

  FileSelected({required this.filePickerResult, required PlatformFile file}) : file = NonNullPathPlatformFile(file);
}

class NonNullPathPlatformFile {
  final PlatformFile originalPlatformFile;

  String get path => originalPlatformFile.path ?? "";

  NonNullPathPlatformFile(PlatformFile file) : originalPlatformFile = file;
}