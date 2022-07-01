import 'package:fw_manager/env.dart';

var apiVersion = environment['serverConfig']['apiVersion'];

class ApiMethods {
  // Check app version
  String appVersion(type) => "$apiVersion/application-information/$type";

  final String login = "site/manager/login";
  final String offers = "v3/offers";
  final String magicLink = "v3/login/magiclink/from/app";
  final String magicLinkVerify = "v3/login/magiclink";

  final String businessCategories = "site/manager/businessCategories";
  final String getVendors = "site/manager/getVendors";
  final String area = "site/manager/area";
  final String route = "site/manager/route";
  final String vendorOrders = "site/manager/vendorOrders";
  final String orders = "site/manager/orders";
  final String driverGetDetails = "web/vCodSettlement/drivers/getDetails";
  final String driversDetails = "web/vCodSettlement/drivers/driverDetails";
  final String vendorGetDetails = "web/vCodSettlement/vendors/getDetails";
  final String vendorDetails = "web/vCodSettlement/vendors/vendorDetails";
  final String b2bRoute = "web/getAreaByVendorId";
  final String getVendorInB2C = "web/fetchVendorByBusinessCategoryId";
  final String getVendorB2COrders = "web/vendorB2COrders";
  final String getGlobalAddressBySearch = "web/getGlobalAddressBySearch";
  final String vehiclesNames = "web/vehiclesNames";
  final String driversByVehicleName = "web/driversByVehicleName";
  final String calculateOrder = "web/calculateOrder";
  final String returnSettlement = "manager/vReturnSettlement/getDetails";
  final String sendOTP = "manager/vReturnSettlement/sendOTP";
  final String returnOrder = "vReturnSettlement/getDetails";
}
