package fm.utils {
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * The amazing Vector 2D Class
	 * @author Ignatus Zuk
	 */
	
	public class Vec2 {
		
		public var x:Number;
		public var y:Number;
		
		/** Return new Vector from the passed Point
		 * @param	pt Point from which to create the Vector */
		public static function fromPoint(pt:Point):Vec2 {
			return new Vec2(pt.x, pt.y);
		}
		/** Return new Vector from passed angle and length values
		 * @param	angle Angle of the Vector (in radians)
		 * @param	length Length of the Vector */
		public static function polar(angle:Number, length:Number = 1):Vec2 {
			return new Vec2(Math.cos(angle) * length, Math.sin(angle) * length);
		}
		
		/** Return new Vector from passed angle and length values
		 * @param	angleDegrees Angle of the Vector (in degrees)
		 * @param	length Length of the Vector */
		public static function polarDegrees(angleDegrees:Number, length:Number = 1):Vec2 {
			return polar(angleDegrees * Math.PI / 180, length);
		}
		
		/** Create a new vector with given coordinates
		 * @param	nx X of the Vector
		 * @param	ny Y of the Vector */
		public function Vec2(nx:Number = 0, ny:Number = 0) {
			x = nx;
			y = ny;
		}
		
		/** Convert Vector to a Point and return it */
		public function toPoint():Point {
			return new Point(x, y);
		}
		
		/** Return the translation matrix of the Vector */
		public function toTranslationMatrix():Matrix {
			return new Matrix(1, 0, 0, 1, x, y);
		}
		
		/** Add Vector with the passed Vector
		 * @param	b Vector to add */
		public function add(b:Vec2):Vec2 {
			return new Vec2(x + b.x, y + b.y);
		}
		
		/** Subtract Vector with the passed Vector
		 * @param	b Vector to subtract */
		public function subtract(b:Vec2):Vec2 {
			return new Vec2(x - b.x, y - b.y);
		}
		
		/** Multiply the Vector by the passed scalar value
		 * @param	s Scalar by which to multiply the Vector */
		public function multiply(s:Number):Vec2 {
			return new Vec2(x * s, y * s);
		}
		
		/** Add Vectors x and y with passed x and y values
		 * @param	bx X value to add
		 * @param	by Y value to add */
		public function add2(bx:Number, by:Number):Vec2 {
			return new Vec2(x + bx, y + by);
		}
		
		/** Subtract Vectors x and y with passed x and y values
		 * @param	bx X value to subtract
		 * @param	by Y value to subtract */
		public function subtract2(bx:Number, by:Number):Vec2 {
			return new Vec2(x - bx, y - by);
		}
		
		/** Return the actual length of the Vector with "Pythagorean Theorem" */
		public function length():Number {
			return Math.sqrt((x * x) + (y * y));
		}
		
		/** Returns the squared length of the Vector */
		public function lengthSquared():Number {
			return (x * x) + (y * y);
		}
		
		/** Check if the length of the Vector is less than the passed length value
		 * @param	len Length to check the difference with */
		public function lengthLessThan(len:Number):Boolean {
			if (lengthSquared() < len * len ) return true; else return false;
		}
		
		/** Checks if the length of the Vector is more than the passed length value
		 * @param	len Length to check the difference with */
		public function lengthMoreThan(len:Number):Boolean {
			if (lengthSquared() > len * len ) return true; else return false;
		}
		
		/** Return Vector as a Unit Vector (Vector with a length of 1) */
		public function normalized():Vec2 {
			var l:Number = length();
			return new Vec2(x / l, y / l);
		}
		
		/** Return Vector that is turned 90 degrees to the left */
		public function left90():Vec2 {
			return new Vec2(y, -x);
		}
		
		/** Return Vector that is turned 90 degrees to the right */
		public function right90():Vec2 {
			return new Vec2(-y, x);
		}
		
		/** Return the angle of the Vector in radians */
		public function atan2():Number {
			return Math.atan2(y, x);
		}
		
		/** Return the angle of the Vector in degrees */
		public function atan2InDegrees():Number {
			return Math.atan2(y, x) * 180 / Math.PI;
		}
		
		/** Return the dot product between this and passed Vector
		 * @param	b Vector with which to check for dot product */
		public function dot(b:Vec2):Number {
			return (x * b.x) + (y * b.y);
		}
		
		/** Project this Vector onto another Vector and return that Vector
		 * @param	b Vector to project upon */
		public function projection(b:Vec2):Vec2 {
			var dotProduct:Number = dot(b);
			var bl:Number = b.lengthSquared();
			var px:Number = (dotProduct / bl) * b.x;
			var py:Number = (dotProduct / bl) * b.y;
			return new Vec2(px, py);
		}
	}
	
}