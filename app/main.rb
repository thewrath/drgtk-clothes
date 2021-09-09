=begin
  Little program to simulate Rope/Cloth physics
  Algorithm comes from the following video : 
  https://www.youtube.com/watch?v=PGk0rnyTa1U 
=end
require 'app/vectormath.rb'

Width = 1280
Height = 720
DrawPoints = true
DrawLines = false

Down = {x: 0, y: -0.5}

class Point
  attr_accessor :position, :last_position, :size, :locked, :a_live, :is_dragged

  def initialize x, y, locked
    @position = Vec2.new(x, y)
    @last_position = @position
    @size = Vec2.new(10, 10)
    @locked = locked
    @a_live = true
    @is_dragged = false
  end

  def render args
    c = {r: 255, g: 0, b: 0}
    c = {r: 255, g: 255, b: 255} unless @locked 
    args.outputs.solids << [@position.x, @position.y, @size.x, @size.y, c.r, c.g, c.b]
  end
end

class Stick
  attr_accessor :pointA, :pointB, :initial_length

  def initialize pointA, pointB
    @pointA = pointA
    @pointB = pointB
    @initial_length = diff.length
  end

  def render args
    args.outputs.lines << [@pointA.position.x, @pointA.position.y, @pointB.position.x, @pointB.position.y, 255, 255, 255]
  end

  def a_live
    @pointA.a_live && @pointB.a_live 
  end

  def diff
    @pointA.position.sub(@pointB.position)
  end
end

# Program entry point
def tick args
  # State init
  init(args)

  once args do |args|
    # (0..2).each do |i|
      generate_ropes_col(args, 20, 10)
    # end
  end

  # Print FPS
  args.state.debug_labels << "Ctrl + left click to add dynamic linked point"
  args.state.debug_labels << "Ctrl + right click to add static linked point"
  args.state.debug_labels << "Space + left click to add dynamic point"
  args.state.debug_labels << "Space + right click to add static point"
  args.state.debug_labels << ""
  args.state.debug_labels << "FPS : #{args.gtk.current_framerate.round}"
  args.state.debug_labels << "Mouse : (#{args.inputs.mouse.x}, #{args.inputs.mouse.y})"
  args.state.debug_labels << "Number of points : #{args.state.points.length}"

  draw_debug_labels args

  draw_sticks args if DrawLines
  draw_points args if DrawPoints

  handle_click args

  args.state.play = !args.state.play if args.inputs.keyboard.a

  simulate args if args.state.play

  args.state.show_debug = !args.state.show_debug if args.inputs.keyboard.d 
end

def simulate args
  args.state.points.each do |p|
    # If point isn't lock => update it's position
    if !p.locked then
      before = Vec2.new().set_from!(p.position)

      p.position.add!(p.position.sub(p.last_position))

      # Apply gravity to the point
      p.position.add!(Down)    
      
      # Update last position
      p.last_position = before
    end

    # If point is out of screen we destroy it
    p.a_live = false if p.position.y < 0
  end

  (0..10).each do |i|
    args.state.sticks.each do |s|
      # Compute center of stick
      center = s.pointA.position.add(s.pointB.position).div_scalar(2)
      dir = s.diff.normalize
      
      # For each extrimity of the stick, we update its position if it is not fixed
      if !s.pointA.locked then
        s.pointA.position = center.add(dir.mul_scalar(s.initial_length).div_scalar(2))
      end

      if !s.pointB.locked then
        s.pointB.position = center.sub(dir.mul_scalar(s.initial_length).div_scalar(2))
      end
    end
  end

  args.state.sticks.select! {|s| s.a_live}
  args.state.points.select! {|p| p.a_live}
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

  # Ctrl (add point with stick) or Space (just add point)
  if (args.inputs.mouse.click) && (args.inputs.keyboard.space || args.inputs.keyboard.control) then
    mouse_position = args.inputs.mouse
    
    last_point = points.last

    locked = args.inputs.mouse.button_right 
    new_point = Point.new(mouse_position.x, mouse_position.y, locked)
    points << new_point

    if last_point && new_point && !args.inputs.keyboard.space then
      sticks << Stick.new(last_point, new_point)
    end
  end

  # Use mouse to drag point and move it in space
  if args.inputs.mouse.click then
    if !args.state.dragged_point then
      args.state.dragged_point = args.state.points.find do |p|
        args.inputs.mouse.inside_rect? [p.position.x, p.position.y, p.size.x, p.size.y]
      end
      args.state.dragged_point.is_dragged = true
    else
      args.state.dragged_point.is_dragged = false
      args.state.dragged_point = nil
    end
  end

  if args.state.dragged_point then
    args.state.dragged_point.position = Vec2.new(args.inputs.mouse.x, args.inputs.mouse.y)
    args.state.dragged_point.last_position = args.state.dragged_point.position
  end
end

def generate_ropes_col(args, w, h, global_offset=640)
  points = args.state.points
  sticks = args.state.sticks

  (0..h).each do |r|
    last_point = nil
    (0..w).each do |c|
      locked = !last_point
      x_offset = (100*c)
      x_offset = -x_offset if r.even? 
      new_point = Point.new(global_offset + x_offset, Height - 50 - (20 * r), locked)
      points << new_point

      if last_point && new_point then
        sticks << Stick.new(last_point, new_point)
      end

      last_point = new_point
    end
  end
end

def draw_debug_labels args
  # Is debug mode enable ?
  return if !args.state.show_debug

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
  args.state.dragged_point ||= nil

  args.state.once_init ||= false

  args.state.play ||= false

  args.state.show_debug ||= true
end

def once args
  if !args.state.once_init then
    args.state.once_init = true
    yield args
  end
end