import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controller/select_house_controller.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';

class SelectHousePage extends RestorableGetxPage<_SelectHousePageRestoration> {
  final String? selectedHouseJsonString;

  late final ControllerMember<SelectHouseController> _selectHouseController = ControllerMember<SelectHouseController>().addToControllerManager(controllerManager);

  SelectHousePage({
    Key? key,
    required this.selectedHouseJsonString
  }) : super(key: key, pageRestorationId: () => "select-house-page");

  @override
  void onSetController() {
    _selectHouseController.controller = GetExtended.put<SelectHouseController>(SelectHouseController(controllerManager, Injector.locator<SourceRepository>()), tag: pageName);
  }

  @override
  // ignore: library_private_types_in_public_api
  _SelectHousePageRestoration createPageRestoration() => _SelectHousePageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _selectHouseController.controller.initSelectHouse(selectedHouseJsonString);
    });
    return Scaffold(
      appBar: ModifiedAppBar(
        title: Text("Select House".tr),
        titleInterceptor: (context, title) => Row(
          children: [
            Expanded(
              child: title ?? Container()
            ),
            GestureDetector(
              onTap: () => _selectHouseController.controller.selectHouse(
                onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
                onShowSelectHouseRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
                onSelectHouseRequestProcessSuccessCallback: (house) async => Get.back(result: json.encode(<String, dynamic>{"id": house.id, "typeName": house.typeName})),
                onShowSelectHouseRequestProcessFailedCallback: (e) => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
                  context: context,
                  errorProvider: Injector.locator<ErrorProvider>(),
                  e: e
                )
              ),
              child: const Icon(Icons.check, color: Colors.black)
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RxConsumer<PagingControllerState<int, ListItemControllerState>>(
                rxValue: _selectHouseController.controller.selectHouseListItemPagingControllerStateRx,
                onConsumeValue: (context, value) => ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: value,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: false
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}

class SelectHousePageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String? selectedHouseJsonString;

  SelectHousePageGetPageBuilderAssistant({
    required this.selectedHouseJsonString
  });

  @override
  GetPageBuilder get pageBuilder => (() => SelectHousePage(selectedHouseJsonString: selectedHouseJsonString));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(SelectHousePage(selectedHouseJsonString: selectedHouseJsonString)));
}

class _SelectHousePageRestoration extends GetxPageRestoration {
  @override
  void initState() {

  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {

  }

  @override
  void dispose() {

  }
}

mixin SelectHousePageRestorationMixin on MixableGetxPageRestoration {
  RouteCompletionCallback<String?>? onCompleteSelectHouse;

  late SelectHousePageRestorableRouteFuture selectHousePageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    selectHousePageRestorableRouteFuture = SelectHousePageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('select-house-route'),
      onComplete: onCompleteSelectHouse
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    selectHousePageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    selectHousePageRestorableRouteFuture.dispose();
  }
}

class SelectHousePageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<String?>? onComplete;

  late RestorableRouteFuture<String?> _pageRoute;

  SelectHousePageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<String?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<String?>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(SelectHousePageGetPageBuilderAssistant(selectedHouseJsonString: arguments as String?))
    );
  }

  static Route<String?> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}