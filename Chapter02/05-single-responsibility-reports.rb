report = Report.new(data)
puts report.format

report_content = ReportContent.new(data)
report_formatter = ReportFormatter.new
puts report_formatter.format(report_content)

report_content = ReportContent.new(data)
report_formatter = ReportFormatter.
  for_type(report_type).new
puts report_formatter.format(report_content)
