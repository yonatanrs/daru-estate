import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/marketing_customer_detail_controller.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';

class MarketingCustomerDetailPage extends RestorableGetxPage<_MarketingCustomerDetailPageRestoration> {
  late final ControllerMember<MarketingCustomerDetailController> _marketingCustomerDetailController = ControllerMember<MarketingCustomerDetailController>().addToControllerManager(controllerManager);

  final String customerId;

  MarketingCustomerDetailPage({Key? key, required this.customerId}) : super(key: key, pageRestorationId: () => "marketing-customer-detail-page");

  @override
  void onSetController() {
    _marketingCustomerDetailController.controller = GetExtended.put<MarketingCustomerDetailController>(
      MarketingCustomerDetailController(controllerManager, Injector.locator<SourceRepository>(), customerId),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _MarketingCustomerDetailPageRestoration createPageRestoration() => _MarketingCustomerDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        title: Text("Customer Detail".tr),
        titleInterceptor: (context, title) => Row(
          children: [
            Expanded(
              child: title ?? Container()
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RxConsumer<PagingControllerState<int, ListItemControllerState>>(
                rxValue: _marketingCustomerDetailController.controller.marketingCustomerDetailListItemPagingControllerStateRx,
                onConsumeValue: (context, value) => ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: value,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}

class _MarketingCustomerDetailPageRestoration extends MixableGetxPageRestoration {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class MarketingCustomerDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String customerId;

  MarketingCustomerDetailPageGetPageBuilderAssistant({
    required this.customerId
  });

  @override
  GetPageBuilder get pageBuilder => (() => MarketingCustomerDetailPage(customerId: customerId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(MarketingCustomerDetailPage(customerId: customerId)));
}

mixin MarketingCustomerDetailPageRestorationMixin on MixableGetxPageRestoration {
  late MarketingCustomerDetailPageRestorableRouteFuture marketingCustomerDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    marketingCustomerDetailPageRestorableRouteFuture = MarketingCustomerDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('marketing-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    marketingCustomerDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    marketingCustomerDetailPageRestorableRouteFuture.dispose();
  }
}

class MarketingCustomerDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  MarketingCustomerDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        if (arguments is String) {
          if (arguments == Constant.restorableRouteFuturePushAndRemoveUntil) {
            return navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments);
          } else {
            return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
          }
        } else {
          return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
        }
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(title: "Arguments must be a string");
    }
    return GetExtended.toWithGetPageRouteReturnValue<void>(GetxPageBuilder.buildRestorableGetxPageBuilder(MarketingCustomerDetailPageGetPageBuilderAssistant(customerId: arguments)));
  }

  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
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