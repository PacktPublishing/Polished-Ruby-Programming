class MultiInsert
  def initialize(table, rows)
    @table = table
    @rows = rows
  end
end

class MultiInsert::MultipleQueries < MultiInsert
  def format_sqls
    prefix = "INSERT INTO #{@table} VALUES ("
    @rows.map do |row|
      ["#{prefix}#{row.join(', ')})"]
    end
  end
end

class MultiInsert::SingleQuery < MultiInsert
  def format_sqls
    sql = "INSERT INTO #{@table} VALUES "
    first_row, *rows = @rows
    sql << "(#{first_row.join(', ')})"
    rows.each do |row|
      sql << ", (#{row.join(', ')})"
    end
    [sql]
  end
end

MultiInsert::MultipleQueries.new('a', [[1], [2]]).
  format_sqls
# => [["INSERT INTO a VALUES (1)"],
#     ["INSERT INTO a VALUES (2)"]]

MultiInsert::SingleQuery.new('a', [[1], [2]]).
  format_sqls
# => ["INSERT INTO a VALUES (1), (2)"]

