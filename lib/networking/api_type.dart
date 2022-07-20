import 'package:fw_manager/env.dart';

var apiVersion = environment['serverConfig']['apiVersion'];

class ApiMethods {
  // Check app version
  String appVersion(type) => "$apiVersion/application-information/$type";

  final String login = "manager/login";
  final String offers = "v3/offers";
  final String magicLink = "v3/login/magiclink/from/app";
  final String magicLinkVerify = "v3/login/magiclink";

  final String businessCategories = "manager/businessCategories";

  ///one
  final String getVendors = "manager/getVendors"; //add
  final String area = "manager/area";
  final String route = "manager/route";
  final String vendorOrders = "manager/vendorOrders"; // not use
  final String orders = "manager/orders";
  final String driverGetDetails = "manager/vCodSettlement/drivers/getDetails";
  final String driversDetails = "manager/vCodSettlement/drivers/driverDetails";
  final String vendorGetDetails = "manager/vCodSettlement/vendors/getDetails";
  final String vendorDetails = "manager/vCodSettlement/vendors/vendorDetails";
  final String b2bRoute = "manager/getAreaByVendorId";
  final String fetchVendorByBusinessCategoryId = "manager/fetchVendorByBusinessCategoryId"; /////
  final String getVendorB2COrders = "manager/vendorB2COrders";
  final String getGlobalAddressBySearch = "manager/getGlobalAddressBySearch";
  final String vehiclesNames = "manager/vehiclesNames";
  final String driversByVehicleName = "manager/driversByVehicleName";
  final String calculateOrder = "manager/calculateOrder";
  final String saveAdminOrder = "manager/saveAdminOrder";
  final String updateVendorOrders = "manager/updateVendorOrders";
  final String returnSettlement = "manager/vReturnSettlement/getDetails";
  final String vendorReturnSettlement = "manager/vReturnSettlement/getDetails/vendorIds";
  final String sendOTPReturnOrderSettlement = "manager/vReturnSettlement/sendOTP";
  final String verifyOTPByReturnSettlement = "manager/vReturnSettlement/settlement";
  final String sendOTPVendorCashSettlement = "manager/vCodSettlement/vendor/sendOTP";
  final String verifyOTPVendorCashSettlement = "manager/vCodSettlement/vendor/verify";
  final String updateVendorPackageDetails = "manager/updateVendorPackageDetails";

  // Order Apis.......//
  final String orderDataUpdate = "manager/orderDataUpdate"; //ok
  final String vendorOrderMergeByBusinessCategoryId = "manager/vendorOrderMergeByBusinessCategoryId"; // pending vendor seletion "vendorId","orderType","BisnessId....."ok
  final String getRoutesDetails = "manager/getRoutesDetails"; //new add use..... ok
  final String getAllGlobalAddressByRoute = "manager/getAllGlobalAddressByRoute"; // new add orderdetails........ok

  //selection data vendor add ....   json add order add.....
  //vendor selection
  final String shiftVendorOrderLocationsToPending = "manager/shiftVendorOrderLocationsToPending";

  final String addNewLocationDetailsInVendorStatus = "manager/addNewLocationDetailsInVendorStatus"; // "vendorId","orderType","BisnessId....."  new add use.....
  final String getVendorLastorder = "manager/getVendorLastOrderDetails"; // "vendorId","orderType",""  new add use.....

  // COD Settlement Apis.......//
  final String vCodSettlementgetDetails = "manager/vCodSettlement/getDetails";
  final String vCodSettlementsendOTP = "manager/vCodSettlement/sendOTP";
  final String vCodSettlementverify = "manager/vCodSettlement/verify";

  // nayan@gmail.com
  // nayan@2020
}
