abstract class ReportEvent {}

class FetchReports extends ReportEvent {}

class FetchReportDetails extends ReportEvent {
  final String reportId;

  FetchReportDetails({required this.reportId});
}
