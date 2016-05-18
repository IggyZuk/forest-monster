package fm.game {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public interface IDestructible {
		
		function SetCenter(centerX:Number = 0, centeY:Number = 0):void;
		function GetCenter():Point;
		
		function SetRadius(radius:Number):void;
		function GetRadius():Number;
		
	}

}