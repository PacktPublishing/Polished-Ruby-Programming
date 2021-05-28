class Database
  private def execute(sql)
    checkout do |conn|
      conn.execute(sql)
    end
  end

  def insert(*args)
    execute(insert_sql(*args))
  end

  def update(*args)
    execute(update_sql(*args))
  end

  def delete(*args)
    execute(delete_sql(*args))
  end
end
