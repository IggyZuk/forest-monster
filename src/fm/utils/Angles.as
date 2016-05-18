package fm.utils {
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Angles {
		
		public static function GetDistance(a:Object, b:Object):Number {
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function GetAngle(a:Object, b:Object):Number {
			var dx:Number = a.x - b.x;
			var dy:Number = a.y - b.y;
			return Math.atan2(dy, dx) / (Math.PI / 180);
		}
		
	}

}