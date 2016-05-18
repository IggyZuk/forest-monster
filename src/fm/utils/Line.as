package fm.utils {
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class Line extends Sprite {
		
		private var startPos:Point;
		private var baseQuad:Quad;
		private var _thickness:Number = 1;
		private var _color:uint = 0x000000;
		
		public function Line(toX:int = 0, toY:int = 0, color:uint = 0x000000) {
			_color = color;
			touchable = false;
			
			baseQuad = new Quad(1, _thickness, _color);
			addChild(baseQuad);
			
			moveTo(toX, toY);
		}
		
		public function moveTo(toX:int, toY:int):void {
			baseQuad.x = 0;
			baseQuad.y = 0;
			baseQuad.rotation = 0;
			
			startPos = new Point(toX, toY);
			x = toX;
			y = toY;
		}
		
		public function lineTo(toX:int, toY:int):void {
			var dx:Number = toX - startPos.x;
			var dy:Number = toY - startPos.y;
			baseQuad.width = Math.round(Math.sqrt((dx*dx)+(dy*dy)));
			baseQuad.rotation = Math.atan2(dy, dx);
		}
		
		public function set thickness(t:Number):void {
			var currentRotation:Number = baseQuad.rotation;
			baseQuad.rotation = 0;
			baseQuad.height = _thickness = t;
			baseQuad.rotation = currentRotation;
		}
		
		public function get thickness():Number { return _thickness; }
		public function set color(c:uint):void { baseQuad.color = _color = c; }
		public function get color():uint { return _color; }
	}

}
