package fm.game.projectiles {
	import fm.engine.GameEngine;
	import fm.game.IDestructible;
	import fm.states.GameState;
	import fm.utils.Vec2;
	
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Projectile extends Sprite implements IDestructible {
		
		public var isActive:Boolean = true;
		
		protected var game:GameState;
		
		protected var life:int;
		protected var velocity:Vec2;
		protected var body:Image;
		
		private var _centerPoint:Point;
		private var _radius:Number;
		
		public function Projectile(game:GameState, texture:Texture) {
			this.game = game;
			
			body = new Image(texture);
				body.pivotX = body.width >> 1;
				body.pivotY = body.height >> 1;
			addChild(body);
			
			SetCenter();
		}
		
		public function Cleanup():void {
			body.removeFromParent(true);
		}
		
		final public function Update(passedTime:Number):void {
			Move(passedTime);
			
			life -= passedTime;
			if (life <= 0 || x <= -width || x >= GameEngine.WIDTH + width) Remove();
		}
		
		protected function Move(passedTime:Number):void { }
		
		public function Remove():void {
			isActive = false;
		}
		
		public function SetCenter(centerX:Number = 0, centeY:Number = 0):void { _centerPoint = new Point(centerX, centeY); }
		public function GetCenter():Point { return _centerPoint; }
		
		public function SetRadius(radius:Number):void { _radius = radius; }
		public function GetRadius():Number { return _radius; }
		
	}

}