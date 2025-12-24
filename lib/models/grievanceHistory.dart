class GrievanceHistory {
  final String complainDate;
  final String trackingNumber;
  final String complainDetails;
  final String grievanceType;
  final String grievanceStatus;

  GrievanceHistory({
    required this.complainDate,
    required this.trackingNumber,
    required this.complainDetails,
    required this.grievanceType,
    required this.grievanceStatus,
  });

  factory GrievanceHistory.fromJson(Map<String, dynamic> json) {
    return GrievanceHistory(
        complainDate: json['complainDate'],
        trackingNumber: json['trackingNumber'],
        complainDetails: json['complainDetails'],
        grievanceType: json['grievanceType'],
        grievanceStatus: json['grievanceStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'complainDate': complainDate,
      'trackingNumber': trackingNumber,
      'complainDetails': complainDetails,
      'grievanceType': grievanceType,
      'grievanceStatus': grievanceStatus,
    };
  }
}