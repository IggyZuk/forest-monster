package fm.game.obstacles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.IDestructible;
	import fm.utils.Line;
	import fm.utils.Vec2;
	
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.events.Event;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Obstacle extends Sprite implements IDestructible {
		
		protected var game:GameState;
		
		public const GROUND_UNIT:int = 0;
		public const AIR_UNIT:int = 1;
		
		public var isActive:Boolean = true;
		public var isExploded:Boolean;
		
		protected var body:Image;
		
		private var _unitType:int;
		private var _centerPoint:Point;
		private var _radius:Number;
		private var _position:Point;
		private var _damage:int;
		
		private var centerDebug:Sprite;
		
		public function Obstacle(game:GameState, texture:Texture) {
			this.game = game;
			
			body = new Image(texture);
				body.pivotX = body.width >> 1;
				body.pivotY = body.height >> 1;
			addChild(body);
			
			SetCenter();
			SetDamage(2);
			
			addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		protected function Init():void {
			removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			x = GetPosition().x;
			y = GetPosition().y;
		}
		
		public function Cleanup():void {
			body.removeFromParent(true);
			if (centerDebug) centerDebug.removeFromParent(true);
		}
		
		final public function Update(passedTime:Number):void {
			Move(passedTime);
			
			if (x <= -width) isActive = false;
			if (GameEngine.instance.debug) ShowCenter();
		}
		
		protected function Move(passedTime:Number):void {
			x -= game.monster.GetMoveSpeed() * passedTime;
			
			if (x <= GetCollisionPos()) {
				if(!isExploded){
					Remove();
					game.monster.Hurt(GetDamage());
				}
			} 
		}
		
		public function Remove():void {
			isActive = false;
			if (!isExploded) Explode();
		}
		
		protected function Explode():void {
			isExploded = true;
		}
		
		protected function SetPosition(px:Number, py:Number):void { _position = new Point(px, py); }
		protected function GetPosition():Point { return _position; }
		
		protected function GetCollisionPos():Number { return game.monster.GetBodyX() + GetRadius() }
		
		public function SetUnitType(type:int):void { _unitType = type; }
		public function GetUnitType():int { return _unitType; }
		
		public function SetCenter(centerX:Number = 0, centeY:Number = 0):void { _centerPoint = new Point(centerX, centeY); }
		public function GetCenter():Point { return _centerPoint; }
		
		public function SetRadius(radius:Number):void { _radius = radius; }
		public function GetRadius():Number { return _radius; }
		
		protected function SetDamage(d:int):void { _damage = d; }
		protected function GetDamage():int { return _damage; }
		
		//Debug Center
		final protected function ShowCenter():void {
			if (centerDebug != null) {
				centerDebug.removeFromParent(true);
				centerDebug = null;
			}
			centerDebug = new Sprite();
				var l:Line = new Line(x+GetCenter().x - 5, y+GetCenter().y, 0xFF0000);
				l.lineTo(x+GetCenter().x + 5, y+GetCenter().y);
				var l2:Line = new Line(x+GetCenter().x, y+GetCenter().y - 5, 0xFF0000);
				l2.lineTo(x+GetCenter().x, y+GetCenter().y + 5);
				centerDebug.addChild(l);
				centerDebug.addChild(l2);
			game.frontLayer.addChild(centerDebug);
		}
		
	}

}