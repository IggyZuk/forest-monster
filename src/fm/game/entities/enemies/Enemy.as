package fm.game.entities.enemies {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.castle.CastleWall;
	import fm.game.obstacles.Log;
	import fm.game.obstacles.Obstacle;
	import fm.states.GameState;
	import fm.game.entities.Entity;
	import fm.game.IDestructible;
	import fm.utils.Collision;
	import fm.utils.Line;
	import fm.utils.Vec2;
	
	import starling.display.Image;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Enemy extends Entity implements IDestructible {
		
		public static var s_gravity:Number;
		public static var s_jump:Number;
		
		public static const GROUND_TOP:int = 410;
		public static const GROUND_BOTTOM:int = 510;
		
		public const GROUND_UNIT:int = 0;
		public const AIR_UNIT:int = 1;
		
		private var _unitType:int;
		private var _centerPoint:Point;
		private var _radius:Number;
		private var _coinTextureName:String;
		
		protected var velocity:Vec2;
		protected var initSpeed:Number;
		protected var lifeTimer:int;
		
		protected var body:Sprite;
		
		protected var yell:Image;
		private var yellTimer:Number;
		
		private var centerDebug:Sprite;
		
		private var _limitless:Boolean;
		
		public function Enemy(game:GameState, speed:Number) {
			super(game);
			
			velocity = new Vec2(0, 0);
			
			initSpeed = game.monster.GetMoveSpeed() - speed;
			lifeTimer = 0; //Math.random() * 360;
			yellTimer = 0;
			
			body = new Sprite();
			addChild(body);
			
			SetCenter();
		}
		
		override public function Cleanup():void {
			body.removeFromParent(true);
			if (yell) yell.removeFromParent(true);
			if (centerDebug) centerDebug.removeFromParent(true);
		}
		
		final protected function SetGroundPosition(offSetX:Number = 0, offSetY:Number = 0):void {
			var px:Number = (GameEngine.WIDTH + width) + Math.random()*width;
			var py:Number = Math.random() * (GROUND_BOTTOM - GROUND_TOP) + GROUND_TOP;
			
			pivotX = (width >> 1) + offSetX;
			pivotY = height + offSetY;
			
			x = px + offSetX;
			y = py + offSetY;
			
			groundY = y - offSetY;
		}
		
		override public function Update(passedTime:Number):void {
			Move(passedTime);
			
			//Ground Area
			if(_unitType == GROUND_UNIT){
				if (y <= GROUND_TOP) y = GROUND_TOP;
				else if (y >= GROUND_BOTTOM) y = GROUND_BOTTOM;
			}
			
			//Z sort
			for each(var e:Entity in game.entityManager.GetList()) {
				if (e == this) continue;
				if (!(e is Enemy && Enemy(e).GetUnitType() == GROUND_UNIT)) continue;
				Swap(this, e);
			}
			Swap(this, game.monster);
			
			//Collide with ground obstacles
			if (_unitType == GROUND_UNIT) {
				for each(var o:Obstacle in game.obstacleManager.GetList()) {
					if (o.GetUnitType() != GROUND_UNIT) continue;
					if (o.isExploded) continue;
					
					if (x >= (o.x - 25 - o.width * 0.5 ) && x <= (o.x + 25 + o.width * 0.5)) {
						if (x <= o.x) {
							velocity.x = -5;
							x = (o.x - 25 - o.width * 0.5)
						} else {
							x = (o.x - 25 + o.width * 0.5)
							velocity.x = 5;
						}
					}
				}
			}
			
			//Update Yell
			if (yell) {
				if (yell.visible && int(yellTimer) % 3 == 0) yell.visible = false;
				else if (!yell.visible && int(yellTimer) % 3 == 0) yell.visible = true;
				if (yellTimer >= 25) {
					yell.removeFromParent(true);
					yell = null;
				}
				else yellTimer += passedTime;
			}
			
			//Remove
			if(!limitless) {
				if (x <= -width || x >= GameEngine.WIDTH+width*2) isActive = false;
			}
			
			if (GameEngine.instance.debug) ShowCenter();
		}
		
		protected function Move(passedTime:Number):void { }
		
		public function Remove():void {
			isActive = false;
		}
		
		protected function ConstructVisuals():void { }
		
		protected function GetCollisionPos():Number { return game.monster.GetBodyX() + GetRadius() }
		
		private function Swap(a:Entity, b:Entity):void {
			if (a.groundY > b.groundY != a.parent.getChildIndex(a) > b.parent.getChildIndex(b)) {
				a.parent.swapChildren(a, b);
			}
		}
		
		final public function Jump():void {
			if(_unitType == GROUND_UNIT) velocity.y = - s_jump;
		}
		
		final public function SetUnitType(type:int):void { _unitType = type; }
		final public function GetUnitType():int { return _unitType; }
		
		final public function SetCenter(centerX:Number = 0, centeY:Number = 0):void { _centerPoint = new Point(centerX, centeY); }
		final public function GetCenter():Point { return _centerPoint; }
		
		final public function SetRadius(radius:Number):void { _radius = radius; }
		final public function GetRadius():Number { return _radius; }
		
		final protected function AddYell(px:int, py:int):void {
			if (yell) yell.removeFromParent(true);
			yell = null;
			
			yell = new Image(Art.EntityAtlas.getTexture("yell"));
			yell.pivotX = yell.width >> 1;
			yell.pivotY = yell.height >> 1;
			yell.x = px;
			yell.y = py;
			body.addChild(yell);
		}
		
		final protected function ShowCenter():void {
			if (centerDebug) {
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
		
		public function CanAddCoin():Boolean { return true; }
		
		final public function get coinTextureName():String { return _coinTextureName; }
		final public function set coinTextureName(t:String):void { _coinTextureName = t; }
		
		final public function get limitless():Boolean { return _limitless; }
		final public function set limitless(l:Boolean):void { _limitless = l; }
		
	}

}