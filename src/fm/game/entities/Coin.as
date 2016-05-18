package fm.game.entities {
	import fm.game.Tracker;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.utils.Vec2;
	import starling.display.Image;
	
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Coin extends Entity {
		
		private var targetPos:Point;
		private var velocity:Vec2;
		private var speed:Number;
		
		private var body:Image;
		
		private var lifeTimer:int;
		
		public function Coin(game:GameState, textureName:String) {
			super(game);
			
			//Properties
			targetPos = new Point(40, 550);
			velocity = new Vec2((Math.random() - Math.random()) * 40 + 10, - Math.random() * 60 + 10);
			speed = Math.random() + 0.25;
			
			if (!Art.EntityAtlas.getTexture(textureName)) textureName = "peasant_1_coin";
			addChild (body = new Image(Art.EntityAtlas.getTexture(textureName)));
			
			//Position
			pivotX = width >> 1;
			pivotY = height >> 1;
		}
		
		override public function Cleanup():void {
			body.removeFromParent(true);
		}
		
		override public function Update(passedTime:Number):void {
			Move(passedTime);
		}
		
		private function Move(passedTime:Number):void {
			
			lifeTimer += passedTime;
			
			//Move to target
			if (x < targetPos.x) velocity.x += speed;
			else  velocity.x -= speed;
			if (y < targetPos.y) velocity.y += speed;
			else  velocity.y -= speed;
			
			x += velocity.x*passedTime;
			y += velocity.y*passedTime;
			
			velocity.x *= 0.95;
			velocity.y *= 0.95;
			
			//Remove if on target
			if (x >= targetPos.x - 5 && x <= targetPos.x + 5 && y >= targetPos.y - 5 && y <= targetPos.y + 5) {
				Remove();
			}
		}
		
		private function Remove():void {
			Tracker.instance.AddNormalCoin();
			isActive = false;
		}
		
	}

}