class Database
  private def checkout
    conn = checkout_connection
    yield conn
  ensure
    checkin_connection(conn) if conn
  end

  def insert(*args)
    checkout do |conn|
      conn.execute(insert_sql(*args))
    end
  end
  def update(*args)
    checkout do |conn|
      conn.execute(update_sql(*args))
    end
  end
  def delete(*args)
    checkout do |conn|
      conn.execute(delete_sql(*args))
    end
  end
end
