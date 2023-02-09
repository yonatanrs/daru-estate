import 'package:daru_estate/misc/page_restoration_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daru_estate/misc/ext/get_ext.dart';
import 'package:daru_estate/misc/typedef.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../presentation/page/getx_page.dart';
import '../presentation/page/modaldialogpage/modal_dialog_page.dart';
import '../presentation/widget/modified_loading_indicator.dart';
import '../presentation/widget/profile_menu_item.dart';
import 'errorprovider/error_provider.dart';
import 'widget_helper.dart';

typedef WidgetBuilderWithPromptCallback = Widget Function(BuildContext context, VoidCallbackWithBuildContextParameter? callback);

typedef ModalDialogPageBuilder<T extends ModalDialogPage, P> = T Function(
  BuildContext context,
  P? parameter
);

class _DialogHelperImpl {
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Loading..."),
                    SizedBox(height: 12.0),
                    ModifiedLoadingIndicator()
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  void showPromptYesNoDialog({
    required BuildContext context,
    required WidgetBuilder prompt,
    WidgetBuilderWithPromptCallback? yesPromptButton,
    WidgetBuilderWithPromptCallback? noPromptButton,
    VoidCallbackWithBuildContextParameter? onYesPromptButtonTap,
    VoidCallbackWithBuildContextParameter? onNoPromptButtonTap,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prompt(context),
                    const SizedBox(height: 12.0),
                    Builder(
                      builder: (BuildContext context) {
                        Widget buildDefaultYesPromptButtonWidget(Widget textWidget) {
                          return SizedBox(
                            height: 5.h,
                            child: TextButton(
                              onPressed: onYesPromptButtonTap != null ? () => onYesPromptButtonTap(context) : null,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)
                                ),
                                foregroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              child: textWidget,
                            )
                          );
                        }
                        Widget buildDefaultNoPromptButtonWidget(Widget textWidget) {
                          return SizedBox(
                            height: 5.h,
                            child: TextButton(
                              onPressed: onNoPromptButtonTap != null ? () => onNoPromptButtonTap(context) : null,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              child: textWidget,
                            )
                          );
                        }
                        Widget? yesPromptButtonWidget = yesPromptButton != null ? yesPromptButton(context, onYesPromptButtonTap) : null;
                        Widget? noPromptButtonWidget = noPromptButton != null ? noPromptButton(context, onNoPromptButtonTap) : null;
                        if (yesPromptButtonWidget is Text) {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(yesPromptButtonWidget);
                        } else {
                          yesPromptButtonWidget = buildDefaultYesPromptButtonWidget(Text("Yes".tr));
                        }
                        if (noPromptButtonWidget is Text) {
                          noPromptButtonWidget = buildDefaultNoPromptButtonWidget(noPromptButtonWidget);
                        } else {
                          noPromptButtonWidget = buildDefaultNoPromptButtonWidget(Text("No".tr));
                        }
                        return Row(
                          children: [
                            Expanded(child: yesPromptButtonWidget),
                            SizedBox(width: 2.w),
                            Expanded(child: noPromptButtonWidget)
                          ]
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Future<T?> showModalBottomSheetPage<T>({
    required BuildContext context,
    Color? backgroundColor = Colors.transparent,
    required WidgetBuilder builder,
    bool enableDrag = false
  }) async {
    return Get.bottomSheetOriginalMethod<T>(
      context,
      builder(context),
      ignoreSafeArea: false,
      isScrollControlled: true,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
    );
  }

  _showRawPromptModalBottomDialog({
    required BuildContext context,
    required WidgetBuilder builder
  }) {
    return showModalBottomSheetPage(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.all(4.w),
        child: builder(context)
      )
    );
  }

  Future<T?> showModalBottomDialogPage<T, P>({
    required BuildContext context,
    required ModalDialogPageBuilder<dynamic, P> modalDialogPageBuilder,
    P? parameter,
    bool enableDrag = false
  }) async {
    dynamic result = await showModalBottomSheetPage(
      context: context,
      backgroundColor: Theme.of(context).canvasColor,
      builder: (context) => GetxPageBuilder.buildDefaultGetxPage(modalDialogPageBuilder(context, parameter)),
      enableDrag: enableDrag
    );
    return result is T ? result : null;
  }

  showFailedModalBottomDialog({
    required BuildContext context,
    String? buttonText,
    Image? image,
    String? promptTitleText = "Success",
    String? promptText = "This process has been success...",
    void Function()? onPressed
  }) {
    return _showRawPromptModalBottomDialog(
      context: context,
      builder: (context) => WidgetHelper.buildFailedPromptIndicator(
        context: context,
        image: image,
        promptText: promptText,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Get.back(result: true)
      )
    );
  }

  showFailedModalBottomDialogFromErrorProvider({
    required BuildContext context,
    required ErrorProvider errorProvider,
    required dynamic e,
    String? buttonText,
    void Function()? onPressed
  }) {
    return _showRawPromptModalBottomDialog(
      context: context,
      builder: (context) => WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
        context: context,
        errorProvider: errorProvider,
        e: e,
        buttonText: buttonText,
        onPressed: onPressed ?? () => Get.back(result: true)
      )
    );
  }

  void showSelectingImageDialog(BuildContext context, {void Function(String)? onImageSelectedWithoutCropping}) {
    showDialog(
      context: context,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => true,
          child: Dialog(
            insetPadding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text("Select Image With".tr, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ),
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    DialogHelper.showLoadingDialog(context);
                    ImagePicker imagePicker = ImagePicker();
                    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
                    if (pickedImage != null) {
                      if (onImageSelectedWithoutCropping != null) {
                        onImageSelectedWithoutCropping(pickedImage.path);
                        Get.back();
                      } else {
                        // ignore: use_build_context_synchronously
                        PageRestorationHelper.toCropPicturePage(context, pickedImage.path);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  icon: (BuildContext context) => const Icon(Icons.image),
                  title: 'Gallery'.tr,
                ),
                ProfileMenuItem(
                  onTap: () async {
                    Get.back();
                    DialogHelper.showLoadingDialog(context);
                    ImagePicker imagePicker = ImagePicker();
                    XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
                    if (pickedImage != null) {
                      if (onImageSelectedWithoutCropping != null) {
                        onImageSelectedWithoutCropping(pickedImage.path);
                        Get.back();
                      } else {
                        // ignore: use_build_context_synchronously
                        PageRestorationHelper.toCropPicturePage(context, pickedImage.path);
                      }
                    } else {
                      Get.back();
                    }
                  },
                  icon: (BuildContext context) => const Icon(Icons.camera),
                  title: 'Camera'.tr,
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Future<FilePickerResult?> showChooseFileOrTakePhoto({bool allowMultipleSelectFiles = false}) async {
    return await FilePicker.platform.pickFiles(
      allowMultiple: allowMultipleSelectFiles
    );
  }
}

// ignore: non_constant_identifier_names
final DialogHelper = _DialogHelperImpl();