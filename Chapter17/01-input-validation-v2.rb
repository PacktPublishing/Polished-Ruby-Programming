Fruit = Struct.new(:type, :color, :price)

FRUITS = {}
FRUITS[1] = Fruit.new('apple', 'red', 0.70)
FRUITS[2] = Fruit.new('pear', 'green', 1.23)
FRUITS[3] = Fruit.new('banana', 'yellow', 1.40)

Roda.route do |r|
  r.get "fruit", Integer, String do |fruit_id, field|
    next if field == "exit"
    FRUITS[fruit_id].send(field).to_s
  end
end

# GET /fruit/1/exit!
