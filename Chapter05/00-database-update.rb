def update(pk, column, value)
  database.run_update(<<-SQL)
    UPDATE table
    SET #{column} = #{database.literal(value)}
    WHERE id = #{database.literal(pk)}
  SQL
end

update(self.id, :name, 'New Name')
