package vault;

typedef Point_ = {
  var x: Int;
  var y: Int;
}

typedef PointDir_ = {>Point_,
  var angle: Float;
};

abstract Point(Point_) from Point_ to Point_ {
  public inline function new (x: Int, y:Int) {
    this = {x: x, y: y};
  }

  @:op(A + B) static public function add(lhs:Point, rhs:Point):Point
  {
    return new Point(lhs.x+rhs.x,lhs.y+rhs.y);
  }
  @:op(A == B) static public function equals(lhs:Point, rhs:Point):Bool
  {
    return lhs.x == rhs.x && lhs.y == rhs.y;
  } // != doesn't seem to work? make sure to use !(a == b)

  public function toString() 
  {
    return 'Point($x,$y)';
  }

  public var x(get,set):Int;
  inline function get_x() return this.x;
  inline function set_x(x:Int) return this.x = x;

  public var y(get,set):Int;
  inline function get_y() return this.y;
  inline function set_y(y:Int) return this.y = y;

  public inline function make(x:Int, y:Int): Point {
    return new Point(x, y);
  }

  public inline function copy(): Point {
    return new Point(x, y);
  }

  public inline function vec2(): Vec2 {
    return new Vec2(x, y);
  }

  public inline function fromVec2(v: Vec2): Point {
    return new Point(Std.int(v.x), Std.int(v.y));
  }
}

