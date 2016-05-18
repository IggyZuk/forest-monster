package fm.utils {
	import flash.geom.Rectangle;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Collision {
		
		public static function RectToRect(a:Rectangle, b:Rectangle):Boolean {
			return 	(Math.abs(a.x - b.x) * 2 < (a.width + b.width)) &&
					(Math.abs(a.y - b.y) * 2 < (a.height + b.height));
		}
		
		public static function LineIntersectCircle(A : Point, B : Point, C : Point, r : Number = 1):Object {
			var result : Object = new Object ();
			result.inside = false;
			result.tangent = false;
			result.intersects = false;
			result.enter = null;
			result.exit = null;
			var a : Number = (B.x - A.x) * (B.x - A.x) + (B.y - A.y) * (B.y - A.y);
			var b : Number = 2 * ((B.x - A.x) * (A.x - C.x) +(B.y - A.y) * (A.y - C.y));
			var cc : Number = C.x * C.x + C.y * C.y + A.x * A.x + A.y * A.y - 2 * (C.x * A.x + C.y * A.y) - r * r;
			var deter : Number = b * b - 4 * a * cc;
			
			if (deter <= 0 ) {
				result.inside = false;
			} else {
				var e : Number = Math.sqrt (deter);
				var u1 : Number = ( - b + e ) / (2 * a );
				var u2 : Number = ( - b - e ) / (2 * a );
				if ((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1)) {
					if ((u1 < 0 && u2 < 0) || (u1 > 1 && u2 > 1)) {
						result.inside = false;
					} else {
						result.inside = true;
					}
				} else {
					if (0 <= u2 && u2 <= 1) {
						result.enter=Point.interpolate (A, B, 1 - u2);
					}
					if (0 <= u1 && u1 <= 1) {
						result.exit=Point.interpolate (A, B, 1 - u1);
					}
					result.intersects = true;
					if (result.exit != null && result.enter != null && result.exit.equals (result.enter)) {
						result.tangent = true;
					}	
				}
			}
			return result;
		}
		
	}

}