class Report {
  final String description;
  final String reportType;

  Report({
    required this.description,
    required this.reportType,
  });

  factory Report.fromFirestore(Map<String, dynamic> data)
  {
    return Report(
      description: data['description'] ?? '',
      reportType: data['report_type'] ?? '',
    );
  }
}