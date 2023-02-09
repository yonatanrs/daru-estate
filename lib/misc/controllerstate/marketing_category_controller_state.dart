class MarketingCategoryControllerState {
  int marketingCategoryIndex;

  MarketingCategoryControllerState({
    required this.marketingCategoryIndex
  });

  MarketingCategoryControllerState copy({
    int? marketingCategoryIndex,
  }) {
    return MarketingCategoryControllerState(
      marketingCategoryIndex: marketingCategoryIndex ?? this.marketingCategoryIndex
    );
  }
}