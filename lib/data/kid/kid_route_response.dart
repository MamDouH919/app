class KidRouteResponse {
  String kidMessage;
  String sign;
  String busPaid;
  String paymentString;
  String currentPeriod;
  String routePeriod;
  String rideNumber;
  String renwalDate;
  String endDate;
  String kidRouteId;
  String routeId;
  String branch;

  KidRouteResponse(
      {required this.kidMessage,
      required this.sign,
      required this.busPaid,
      required this.paymentString,
      required this.currentPeriod,
      required this.routePeriod,
      required this.rideNumber,
      required this.renwalDate,
      required this.endDate,
      required this.kidRouteId,
      required this.routeId,
      required this.branch});

  factory KidRouteResponse.fromJson(Map<String, dynamic> json) {
    return KidRouteResponse(
      kidMessage: json['kid_message']!.toString(),
      sign: json['sign']!.toString(),
      busPaid: json['bus_paid']!.toString(),
      paymentString: json['payment_string']!.toString(),
      currentPeriod: json['current_period']!.toString(),
      routePeriod: json['route_period']!.toString(),
      rideNumber: json['till_ride_number']!.toString(),
      renwalDate: json['renewal_date']!.toString(),
      endDate: json['bus_enddate']!.toString(),
      kidRouteId: json['kr_id']!.toString(),
      routeId: json['route_id']!.toString(),
      branch: json['branch']!.toString(),
    );
  }
}
