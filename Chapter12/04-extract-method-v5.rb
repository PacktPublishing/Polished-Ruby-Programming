class Database
  private def execute(sql)
    conn = checkout_connection
    conn.execute(sql)
  ensure
    checkin_connection(conn) if conn
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

