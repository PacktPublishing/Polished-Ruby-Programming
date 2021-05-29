class Database
  def insert(*args)
    conn = checkout_connection
    conn.execute(insert_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end

  def update(*args)
    conn = checkout_connection
    conn.execute(update_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end

  def delete(*args)
    conn = checkout_connection
    conn.execute(delete_sql(*args))
  ensure
    checkin_connection(conn) if conn
  end
end
