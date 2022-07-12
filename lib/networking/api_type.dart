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
  final String getVendors = "manager/getVendors";
  final String area = "manager/area";
  final String route = "manager/route";
  final String vendorOrders = "manager/vendorOrders";
  final String orders = "manager/orders";
  final String driverGetDetails = "manager/vCodSettlement/drivers/getDetails";
  final String driversDetails = "manager/vCodSettlement/drivers/driverDetails";
  final String vendorGetDetails = "manager/vCodSettlement/vendors/getDetails";
  final String vendorDetails = "manager/vCodSettlement/vendors/vendorDetails";
  final String b2bRoute = "manager/getAreaByVendorId";
  final String getVendorInB2C = "manager/fetchVendorByBusinessCategoryId";
  final String getVendorB2COrders = "manager/vendorB2COrders";
  final String getGlobalAddressBySearch = "manager/getGlobalAddressBySearch";
  final String vehiclesNames = "manager/vehiclesNames";
  final String driversByVehicleName = "manager/driversByVehicleName";
  final String calculateOrder = "manager/calculateOrder";
  final String saveAdminOrder = "manager/saveAdminOrder";
  final String updateVendorOrders = "manager/updateVendorOrders";

  final String returnSettlement = "manager/vReturnSettlement/getDetails";
  final String vendorReturnSettlement = "manager/vReturnSettlement/getDetails/vendorIds";
  final String sendOTP = "manager/vReturnSettlement/sendOTP";
  final String returnOrderOtp = "manager/vReturnSettlement/settlement";
}
