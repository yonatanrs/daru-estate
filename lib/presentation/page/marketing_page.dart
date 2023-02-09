import 'package:daru_estate/presentation/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/marketing_controller.dart';
import '../../domain/repository/source_repository.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/marketing_category_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';
import 'marketing_add_customer_page.dart';
import 'marketing_customer_detail_page.dart';

class MarketingPage extends RestorableGetxPage<_MarketingPageRestoration> {
  late final ControllerMember<MarketingController> _marketingController = ControllerMember<MarketingController>().addToControllerManager(controllerManager);

  MarketingPage({Key? key}) : super(key: key, pageRestorationId: () => "marketing-page");

  @override
  void onSetController() {
    _marketingController.controller = GetExtended.put<MarketingController>(
      MarketingController(controllerManager, Injector.locator<SourceRepository>()),
      tag: pageName
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _MarketingPageRestoration createPageRestoration() => _MarketingPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    _marketingController.controller.setOnClickCustomer(
      (customer) => PageRestorationHelper.toMarketingCustomerDetailPage(context, customer.id)
    );
    return RxConsumer<MarketingCategoryControllerState>(
      rxValue: _marketingController.controller.marketingCategoryControllerStateRx,
      onConsumeValue: (context, marketingCategoryControllerState) => Scaffold(
        appBar: ModifiedAppBar(
          title: Text("Marketing".tr),
          titleInterceptor: (context, title) => Row(
            children: [
              Expanded(
                child: title ?? Container()
              ),
              GestureDetector(
                onTap: () => _marketingController.controller.logout(() => PageRestorationHelper.toLoginPage(context)),
                child: const Icon(Icons.logout, color: Colors.black)
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RxConsumer<PagingControllerState<int, ListItemControllerState>>(
                  rxValue: _marketingController.controller.marketingListItemPagingControllerStateRx,
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
        floatingActionButton: marketingCategoryControllerState.marketingCategoryIndex == 0 ? FloatingActionButton(
          onPressed: () => PageRestorationHelper.toMarketingAddCustomerPage(context),
          child: const Icon(Icons.contact_mail)
        ) : null
      ),
    );
  }
}

class _MarketingPageRestoration extends MixableGetxPageRestoration with MarketingCustomerDetailPageRestorationMixin, MarketingAddCustomerPageRestorationMixin, LoginPageRestorationMixin {
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

class MarketingPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => MarketingPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(MarketingPage()));
}

mixin MarketingPageRestorationMixin on MixableGetxPageRestoration {
  late MarketingPageRestorableRouteFuture marketingPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    marketingPageRestorableRouteFuture = MarketingPageRestorableRouteFuture(restorationId: restorationIdWithPageName('marketing-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    marketingPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    marketingPageRestorableRouteFuture.dispose();
  }
}

class MarketingPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  MarketingPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    return GetExtended.toWithGetPageRouteReturnValue<void>(GetxPageBuilder.buildRestorableGetxPageBuilder(MarketingPageGetPageBuilderAssistant()));
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