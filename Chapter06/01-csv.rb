CSV.new(data,
        nil_value: "",
        strip: true,
        skip_lines: /foo/)
# or
CSV.new(data,
        col_sep: "\t",
        row_sep: "\0",
        quote_char: "|")

options = CSV::Options.new
options.nil_value = ""
options.strip = true
options.skip_lines = true
CSV.new(data, options)
# or
options = CSV::Options.new
options.col_sep = "\t"
options.row_sep = "\0"
options.quote_char = "|"
CSV.new(data, options)

options = CSV::Options.new
options.nil_value = ""
options.strip = true
options.skip_lines = true
csv1 = CSV.new(data1, options)
csv2 = CSV.new(data2, options)

options = {nil_value: "", strip: true, skip_lines: /foo/}
csv1 = CSV.new(data1, **options)
csv2 = CSV.new(data2, **options)
