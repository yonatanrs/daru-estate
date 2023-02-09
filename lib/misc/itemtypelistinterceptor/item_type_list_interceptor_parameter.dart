class ItemTypeListInterceptorParameter<ItemType> {
  bool hasAdditionalLoadingIndicator;
  List<ItemType> additionalItemTypeList;

  ItemTypeListInterceptorParameter({
    required this.hasAdditionalLoadingIndicator,
    required this.additionalItemTypeList
  });

  ItemTypeListInterceptorParameter<ItemType> copy({
    bool? hasAdditionalLoadingIndicator,
    List<ItemType>? additionalItemTypeList
  }) {
    return ItemTypeListInterceptorParameter(
      hasAdditionalLoadingIndicator: hasAdditionalLoadingIndicator ?? this.hasAdditionalLoadingIndicator,
      additionalItemTypeList: additionalItemTypeList ?? this.additionalItemTypeList
    );
  }
}