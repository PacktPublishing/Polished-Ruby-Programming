class Adapter
  def initialize(conn)
    @conn = conn
  end
end

class Adapter::M < Adapter
  def execute(sql)
    @conn.exec(sql)
  end
end
class Adapter::P < Adapter
  def execute(sql)
    @conn.execute_query(sql)
  end
end
class Adapter::S < Adapter
  def execute(sql)
    @conn.exec_sql(sql)
  end
end
