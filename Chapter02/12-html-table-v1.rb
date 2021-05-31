require 'cgi/escape'

class HTMLTable
  def initialize(rows)
    @rows = rows
  end

  def to_s
    html = String.new
    html << "<table><tbody>"
    @rows.each do |row|
      html << "<tr>"
      row.each do |cell|
        html << "<td>" << CGI.escapeHTML(cell.to_s) << "</td>"
      end
      html << "</tr>"
    end
    html << "</tbody></table>"
  end
end
