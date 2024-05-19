class BannerIm {
  final String? bnid;
  final String? mdid;
  final String? blID;
  final String? grID;
  final String? bnTitle;
  final String? bnTitleAr;
  final String? bnDesc;
  final String? bnDescAr;
  final String? bnPublishFrom;
  final String? bnPublishTill;
  final String? bnGroupTitle;
  final String? bnGroupTitleAr;
  final String? bnBannerLocationTitle;
  final String? bnBannerLocationTitleAr;

  final bool? bnActive;
  final String? bnCreatedOn;
  final String? bnCreator;
  final String? bnModifyOn;
  final String? bnModifier;
  final String? imagePath;

  BannerIm({
    this.bnid,
    this.mdid,
    this.blID,
    this.grID,
    this.bnTitle,
    this.bnTitleAr,
    this.bnDesc,
    this.bnDescAr,
    this.bnPublishFrom,
    this.bnPublishTill,
    this.bnGroupTitle,
    this.bnGroupTitleAr,
    this.bnBannerLocationTitle,
    this.bnBannerLocationTitleAr,
    this.bnActive,
    this.bnCreatedOn,
    this.bnCreator,
    this.bnModifyOn,
    this.bnModifier,
    this.imagePath,
  });
}

List<BannerIm> getbannerList = [];
