=begin
  Little program to simulate Rope/Cloth physics
  Algorithm comes from the following video : 
  https://www.youtube.com/watch?v=PGk0rnyTa1U 
=end


Width = 1280
Height = 720

Down = {x: 0, y: -1}
Gravity = 0.1

class Point
  attr_accessor :x, :y, :last_x, :last_y, :locked

  def initialize x, y, locked
    @x = x
    @y = y
    @last_x = x
    @last_y = y
    @locked = locked
  end

  def render args
    c = {r: 255, g: 0, b: 0}
    c = {r: 255, g: 255, b: 255} unless @locked 
    args.outputs.solids << [@x, @y, 10, 10, c.r, c.g, c.b]
  end
end

class Stick
  attr_accessor :pointA, :pointB, :initial_length

  def initialize pointA, pointB
    @pointA = pointA
    @pointB = pointB
    @initial_length = length
  end

  def a
    @pointA.x - @pointB.x
  end

  def b
    @pointA.y - @pointB.y
  end

  def length
    Math.sqrt(a**2 + b**2)
  end

  def render args
    args.outputs.lines << [@pointA.x, @pointA.y, @pointB.x, @pointB.y, 255, 255, 255]
  end

  def norm
    {x: a / length, y: b / length}
  end
end

# Program entry point
def tick args
  # State init
  init(args)

  # Print FPS
  args.state.debug_labels << "FPS : #{args.gtk.current_framerate.round}"
  args.state.debug_labels << "Mouse : (#{args.inputs.mouse.x}, #{args.inputs.mouse.y})"
  args.state.debug_labels << "Number of points : #{args.state.points.length}"

  draw_debug_labels args

  draw_sticks args
  draw_points args

  handle_click args

  args.state.play = !args.state.play if args.inputs.keyboard.a

  simulate args if args.state.play
end

def simulate args

  args.state.points.each do |p|
    if !p.locked then
      before = {x: p.x, y: p.y}

      p.x += p.x - p.last_x
      p.y += p.y - p.last_y
    
      p.x += Down.x * Gravity
      p.y += Down.y * Gravity
      
      p.last_x = before.x
      p.last_y = before.y
    end
  end

  (0..100).each do |i|
    args.state.sticks.each do |s|
      center = {x: (s.pointA.x + s.pointB.x) / 2, y: (s.pointA.y + s.pointB.y) / 2}
      dir = s.norm
      if !s.pointA.locked then
        s.pointA.x = center.x + dir.x * s.initial_length / 2
        s.pointA.y = center.y + dir.y * s.initial_length / 2
      end

      if !s.pointB.locked then
        s.pointB.x = center.x - dir.x * s.initial_length / 2
        s.pointB.y = center.y - dir.y * s.initial_length / 2
      end
    end
  end
end

def draw_points args
  args.state.points.each do |p|
    p.render args
  end
end

def draw_sticks args
  args.state.sticks.each do |s|
    s.render args
  end
end

def handle_click args
  points = args.state.points
  sticks = args.state.sticks

  if args.inputs.mouse.click then
    mouse_position = args.inputs.mouse
    
    last_point = points.last

    locked = args.inputs.keyboard.alt
    new_point = Point.new(mouse_position.x, mouse_position.y, locked)
    points << new_point

    if last_point && new_point && !args.inputs.keyboard.space then
      sticks << Stick.new(last_point, new_point)
    end
  end
end

def draw_debug_labels args
  args.state.debug_labels.each_with_index do |l, i|
    args.outputs.debug << [50, Height - (50 + (30*i)), l, 255, 0, 0].labels
  end

  args.state.debug_labels = []
end

def init args
  args.outputs.background_color = [0, 0, 0]

  args.state.debug_labels ||= []

  # Current program stuff
  args.state.points ||= []
  args.state.sticks ||= []

  args.state.play ||= false

end