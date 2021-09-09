=begin
  Class for 2D vector manipulation in Ruby.
  The source code comes from : https://github.com/xenobrain/ruby_vectormath/blob/main/vectormath.rb
=end

DEG2RAD = Math::PI / 180.0

class Vec2
  attr_accessor(:x, :y)

  def initialize(x = 0.0, y = 0.0)
    @x = x
    @y = y
  end

  def to_a
    [@x, @y]
  end

  def set!(x, y)
    @x = x
    @y = y
    self
  end

  def set_from!(vec2_other)
    @x = vec2_other.x
    @y = vec2_other.y
    self
  end

  def add!(vec2_rhs)
    @x += vec2_rhs.x
    @y += vec2_rhs.y
    self
  end

  def add_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x + vec2_rhs.x
    @y = vec2_lhs.y + vec2_rhs.y
    self
  end

  def add(vec2_rhs)
    dup.add!(vec2_rhs)
  end

  def add_scalar!(scalar_lhs)
    @x += scalar_lhs
    @y += scalar_lhs
    self
  end

  def add_scalar_from!(vec2_rhs, scalar_lhs)
    @x = vec2_rhs.x + scalar_lhs
    @y = vec2_rhs.y + scalar_lhs
    self
  end

  def add_scalar(scalar_lhs)
    dup.add_scalar!(scalar_lhs)
  end

  def sub!(vec2_rhs)
    @x -= vec2_rhs.x
    @y -= vec2_rhs.y
    self
  end

  def sub_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x - vec2_rhs.x
    @y = vec2_lhs.y - vec2_lhs.y
    self
  end

  def sub(vec2_rhs)
    dup.sub!(vec2_rhs)
  end

  def sub_scalar!(scalar_lhs)
    @x -= scalar_lhs
    @y -= scalar_lhs
    self
  end

  def sub_scalar_from!(vec2_rhs, scalar_lhs)
    @x = vec2_rhs.x - scalar_lhs
    @y = vec2_rhs.y - scalar_lhs
    self
  end

  def sub_scalar(scalar_lhs)
    dup.sub_scalar!(scalar_lhs)
  end

  def mul_scalar!(scalar_rhs)
    @x *= scalar_rhs
    @y *= scalar_rhs
    self
  end

  def mul_scalar_from!(vec2_lhs, scalar_rhs)
    @x = vec2_lhs.x * scalar_rhs
    @y = vec2_lhs.y * scalar_rhs
    self
  end

  def mul_scalar(scalar_rhs)
    dup.mul_scalar!(scalar_rhs)
  end

  def mul!(vec2_rhs)
    @x *= vec2_rhs.x
    @y *= vec2_rhs.y
    self
  end

  def mul_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x * vec2_rhs.x
    @y = vec2_lhs.y * vec2_rhs.y
    self
  end

  def mul(vec2_rhs)
    dup.mul!(vec2_rhs)
  end

  def div!(vec2_rhs)
    @x /= vec2_rhs.x
    @y /= vec2_rhs.y
    self
  end

  def div_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x / vec2_rhs.x
    @y = vec2_lhs.y / vec2_rhs.y
    self
  end

  def div(vec2_rhs)
    dup.div!(vec2_rhs)
  end

  def div_scalar!(scalar_rhs)
    @x /= scalar_rhs
    @y /= scalar_rhs
    self
  end

  def div_scalar_from!(vec2_lhs, scalar_rhs)
    @x = vec2_lhs.x / scalar_rhs
    @y = vec2_lhs.y / scalar_rhs
    self
  end

  def div_scalar(scalar_rhs)
    dup.div_scalar!(scalar_rhs)
  end

  def dot(vec2_rhs)
    @x * vec2_rhs.x + @y * vec2_rhs.y
  end

  def cross(vec2_rhs)
    @x * vec2_rhs.y - @y * vec2_rhs.x
  end

  def cross_scalar!(scalar_lhs)
    @x = @y * -scalar_lhs
    @y = @x *  scalar_lhs
    self
  end

  def cross_scalar_from!(vec2_rhs, scalar_lhs)
    @x = vec2_rhs.y * -scalar_lhs
    @y = vec2_rhs.x *  scalar_lhs
    self
  end

  def cross_scalar(scalar_lhs)
    dup.cross_scalar!(scalar_lhs)
  end

  def min!(vec2_rhs)
    @x = @x < vec2_rhs.x ? @x : vec2_rhs.x
    @y = @y < vec2_rhs.y ? @y : vec2_rhs.y
    self
  end

  def min_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x < vec2_rhs.x ? vec2_lhs.x : vec2_rhs.x
    @y = vec2_lhs.y < vec2_rhs.y ? vec2_lhs.y : vec2_rhs.y
    self
  end

  def min(vec2_rhs)
    dup.min!(vec2_rhs)
  end

  def max!(vec2_rhs)
    @x = @x > vec2_rhs.x ? @x : vec2_rhs.x
    @y = @y > vec2_rhs.y ? @y : vec2_rhs.y
    self
  end

  def max_from!(vec2_lhs, vec2_rhs)
    @x = vec2_lhs.x > vec2_rhs.x ? vec2_lhs.x : vec2_rhs.x
    @y = vec2_lhs.y > vec2_rhs.y ? vec2_lhs.y : vec2_rhs.y
    self
  end

  def max(vec2_rhs)
    dup.max!(vec2_rhs)
  end

  def abs!
    @x = @x.abs
    @y = @y.abs
    self
  end

  def abs_from!(vec2_other)
    @x = vec2_other.x.abs
    @y = vec2_other.y.abs
    self
  end

  def abs
    dup.abs!
  end

  def invert!
    @x = -@x
    @y = -@y
    self
  end

  def invert_from!(vec2_other)
    @x = -vec2_other.x
    @y = -vec2_other.y
    self
  end

  def invert
    dup.invert!
  end

  def eq?(other)
    @x == other.x && @y == other.y
  end

  def neq?(other)
    @x != other.x || @y != other.y
  end

  def angle
    Math.atan2(@y, @x)
  end

  def angle_to(vec2_rhs)
    inverse_length_lhs = 1.0 / Math.sqrt(@x * @x + @y * @y)
    lhs_x = @x * inverse_length_lhs
    lhs_y = @y * inverse_length_lhs

    inverse_length_rhs = 1.0 / Math.sqrt(vec2_rhs.x * vec2_rhs.x + vec2_rhs.y * vec2_rhs.y)
    rhs_x = vec2_rhs.x * inverse_length_rhs
    rhs_y = vec2_rhs.y * inverse_length_rhs

    angle = Math.atan2((lhs_x * rhs_y - lhs_y * rhs_x), (lhs_x * rhs_x + lhs_y * rhs_y))
    angle.abs < Float::EPSILON ? 0.0 : angle
  end

  def lerp!(vec2_rhs, scalar_t)
    @x += scalar_t * (vec2_rhs.x - @x)
    @y += scalar_t * (vec2_rhs.y - @y)
    self
  end

  def lerp_from!(vec2_lhs, vec2_rhs, scalar_t)
    @x = vec2_lhs.x + scalar_t * (vec2_rhs.x - vec2_lhs.x)
    @y = vec2_lhs.y + scalar_t * (vec2_rhs.y - vec2_lhs.y)
    self
  end

  def lerp(vec2_rhs, scalar_t)
    dup.lerp!(vec2_rhs, scalar_t)
  end

  def length_sq
    @x * @x + @y * @y
  end

  def length
    Math.sqrt(@x * @x + @y * @y)
  end

  def distance_sq(vec2_rhs)
    (@x * @x + @y * @y) - (vec2_rhs.x * vec2_rhs.x + vec2_rhs.y * vec2_rhs.y)
  end

  def distance(vec2_rhs)
    Math.sqrt(@x * @x + @y * @y) - Math.sqrt(vec2_rhs.x * vec2_rhs.x + vec2_rhs.y * vec2_rhs.y)
  end

  def normalize!
    length_sq = @x * @x + @y * @y
    return self if length_sq == 0

    inverse_length = 1.0 / Math.sqrt(length_sq)

    @x *= inverse_length
    @y *= inverse_length
    self
  end

  def normalize_from!(vec2_other)
    length_sq = vec2_other.x * vec2_other.x + vec2_other.y * vec2_other.y
    if length_sq == 0
      @x = vec2_other.x
      @y = vec2_other.y
      return self
    end

    inverse_length = 1.0 / Math.sqrt(vec2_other.x * vec2_other.x + vec2_other.y * vec2_other.y)

    @x = vec2_other.x * inverse_length
    @y = vec2_other.y * inverse_length
    self
  end

  def normalize
    dup.normalize!
  end

  def rotate!(vec2_center, scalar_degrees)
    radians = scalar_degrees * DEG2RAD
    cos = Math.cos(radians)
    sin = Math.sin(radians)

    @x -= vec2_center.x
    @y -= vec2_center.y
    @x = (@x * cos - @y * sin) + vec2_center.x
    @y = (@x * sin + @y * cos) + vec2_center.y
    self
  end

  def rotate_from!(vec2_other, vec2_center, scalar_degrees)
    radians = scalar_degrees * DEG2RAD
    cos = Math.cos(radians)
    sin = Math.sin(radians)

    @x = vec2_other.x - vec2_center.x
    @y = vec2_other.x - vec2_center.y
    @x = (vec2_other.x * cos - vec2_other.y * sin) + vec2_center.x
    @y = (vec2_other.x * sin + vec2_other.y * cos) + vec2_center.y
    self
  end

  def rotate(vec2_center, scalar_degrees)
    dup.rotate!(vec2_center, scalar_degrees)
  end

  alias + add
  alias - sub
  alias * mul
  alias / div
  alias == eq?
  alias != neq?

  alias scale mul_scalar
  alias scale! mul_scalar!
  alias scale_from! mul_scalar_from!

  alias negate invert
  alias negate! invert!

  alias magnitude length
  alias magnitude_sq length_sq
end