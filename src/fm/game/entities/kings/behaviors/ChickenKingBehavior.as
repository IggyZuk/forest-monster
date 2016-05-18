package fm.game.entities.kings.behaviors {
	import fm.game.entities.kings.Chicken;
	import fm.game.entities.kings.ChickenKing;
	import fm.utils.Vec2;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ChickenKingBehavior implements IChickenBehavior {
		
		private var chicken:Chicken;
		private var king:ChickenKing;
		private var offSetPoint:Point;
		
		private var life:int;
		private var velocity:Vec2;
		
		public function ChickenKingBehavior(chicken:Chicken, king:ChickenKing, offSetPoint:Point) {
			this.chicken = chicken;
			this.king = king;
			this.offSetPoint = offSetPoint;
			
			life = Math.random() * 360;
			velocity = new Vec2();
			chicken.scaleX = Math.random() > 0.5 ? -1 : 1;
			
			chicken.x = king.x + offSetPoint.x;
			chicken.y = king.y + offSetPoint.y;
		}
		
		public function Move(passedTime:Number):void {
			
			life ++;
			
			var speed:Number = 0.35; //Math.abs(king.x - x)/50;
			if (king.x + offSetPoint.x <= chicken.x) velocity.x -= speed;
			else if (king.x + offSetPoint.x >= chicken.x) velocity.x += speed;
			if (king.y + offSetPoint.y <= chicken.y) velocity.y -= speed;
			else if (king.y + offSetPoint.y >= chicken.y) velocity.y += speed;
			
			chicken.x += (velocity.x) + Math.cos(life * 0.05) * 3;
			chicken.y += (velocity.y) + Math.sin(life * 0.1) * 2.5;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
		}
		
		public function Remove():void {
			trace(king);
			velocity.x += Math.random() * 25;
			velocity.y += (Math.random() - Math.random()) * 25;
		}
		
	}

}