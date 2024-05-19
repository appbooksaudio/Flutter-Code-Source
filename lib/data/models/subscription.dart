class Subscription {
  final String sb_ID;
  final String sb_Name;
  final String sb_Name_Ar;
  final String sb_Code;
  final String sb_Desc;
  final String sb_Desc_Ar;
  final int? index;

  final int sb_Price;
  final String sb_DiscountDesc;
  final String sb_DiscountDesc_Ar;
  final bool sb_Active;

  const Subscription({
    required this.sb_ID,
    required this.sb_Name,
    required this.sb_Name_Ar,
    required this.sb_Code,
    required this.sb_Desc,
    required this.sb_Desc_Ar,
    required this.sb_Price,
    required this.sb_DiscountDesc,
    required this.sb_DiscountDesc_Ar,
    required this.sb_Active,
    this.index,
  });
}

List<Subscription> SubscriptionList = [];
