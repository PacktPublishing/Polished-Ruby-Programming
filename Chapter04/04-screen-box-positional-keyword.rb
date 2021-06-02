class Screen
  def draw_box(_x1=nil, _y1=nil, _x2=nil, _y2=nil,
               x1:_x1, y1:_y1, x2:_x2, y2:_y2)
    raise ArgumentError unless x1 && x2 && y1 && y2
  end
end

screen.draw_box(0, 10, 0, 20)
screen.draw_box(x1: 0, x2: 0, y1: 0, y2: 20)

screen.draw_box(5, 30, 15, 40,
                x1: 0, x2: 0, y1: 0, y2: 20)
