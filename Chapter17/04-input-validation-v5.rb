Fruit = Struct.new(:type, :color, :price)

FRUITS = {}
FRUITS[1] = Fruit.new('apple', 'red', 0.70)
FRUITS[2] = Fruit.new('pear', 'green', 1.23)
FRUITS[3] = Fruit.new('banana', 'yellow', 1.40)

Roda.route do |r|
  r.is "fruit", Integer, String do |fruit_id, field|
    r.get do
      next unless %w[type color price].include?(field)
      FRUITS[fruit_id].send(field).to_s
    end

    r.post do
      next unless %w[type color].include?(field)
      FRUITS[fruit_id].send("#{field}=",
                            r.params['value'].to_s)
      r.redirect
    end
  end
end
