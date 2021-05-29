DB[:table].where(Sequel[:column] > 11)
# generates SQL: SELECT * FROM table WHERE (column > 11)

DB[:table].where{column > 11}

@some_var = 10
DB[:table].where{column > @some_var}

@some_var = 10
DB[:table].where{|o| o.column > @some_var}

class Sequel::Dataset
  def where(&block)
    cond = if block.arity == 1
      yield Sequel::VIRTUAL_ROW
    else
      Sequel::VIRTUAL_ROW.instance_exec(&block)
    end

    add_where(cond)
  end
end

Sequel::VIRTUAL_ROW = Class.new(BasicObject) do
  def method_missing(meth)
    Sequel::SQL::Identifier.new(meth)
  end
end.new
