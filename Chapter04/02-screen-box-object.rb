Box = Struct.new(:x1, :y1, :x2, :y2)

class Screen
  def draw_box(box)
  end
end
screen.draw_box(Box.new(0, 0, 10, 20))

box = Box.new
box.x1 = 0
box.x2 = 10
box.y1 = 0
box.y2 = 20
screen.draw_box(box)
