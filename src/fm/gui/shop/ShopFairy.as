package fm.gui.shop {
	import fm.engine.GameEngine;
	import fm.states.ShopState;
	import fm.game.Art;
	import fm.utils.Angles;
	import fm.utils.Vec2;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ShopFairy extends Sprite {
		
		private var shop:ShopState;
		
		private const FLYING:int = 0;
		private const FLY_TO_POT:int = 1;
		private const COOKING:int = 2;
		
		private var state:int;
		
		private var _body:MovieClip;
		private var _lifeTimer:int;
		private var _posTimer:int;
		private var _rotateTimer:int;
		private var itemOffSet:Point;
		
		private var position:Point;
		private var velocity:Vec2;
		private var speed:Number;
		private var rotateVelocity:Number;
		
		private var holdItem:MovieClip;
		
		private var isBlue:Boolean;
		private var isHoldingArrow:Boolean;
		
		private var ladleDirection:int;
		
		public function ShopFairy(shop:ShopState, texture:String, isBlue:Boolean) {
			this.shop = shop;
			this.isBlue = isBlue;
			
			position = new Point(x, y);
			velocity = new Vec2(0, 0);
			speed = 0.15;
			rotateVelocity = 0;
			
			//Set arrow position
			if (isBlue) itemOffSet = new Point(-25,-5);
			else itemOffSet = new Point(25,-5);
			
			_lifeTimer = Math.random() * 360;
			_rotateTimer = Math.random() * 1000 + 1000;
			
			var frames:Vector.<Texture> = Art.EntityAtlas.getTextures(texture);
			_body = new MovieClip(frames, 24);
			_body.pivotX = _body.width >> 1;
			_body.pivotY = _body.height >> 1;
			addChild(_body);
			Starling.juggler.add(_body);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function Cleanup():void {
			_body.removeFromParent(true);
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function Update(passedTime:Number):void {
			Move(passedTime);
			
			//Reposition
			if (_posTimer <= 0) {
				
				if (!IsHoldingArrow() && Math.random() < 0.25) {
					ChangeState(FLY_TO_POT);
					ChangePosition(shop.potPosition.x, shop.potPosition.y);
					_posTimer = Math.random() * 500 + 500;
				} else {
					ChangeState(FLYING);
					ChangePosition(Math.random() * (GameEngine.WIDTH - 200) + 100, Math.random() * (GameEngine.HEIGHT - 200) + 100);
					if (IsHoldingArrow()) _posTimer = Math.random() * 300 + 150;
					else _posTimer = Math.random() * 100 + 50;
				}
				
			} else _posTimer -= passedTime;
			
			//Move arrow
			if (holdItem) {
				
				holdItem.x = x + itemOffSet.x;
				holdItem.y = y + itemOffSet.y;
				
				if (state == FLYING) {
					
					//Random rotation
					_rotateTimer -= passedTime;
					if (_rotateTimer <= 0) {
						_rotateTimer = Math.random() * 1000 + 1000;
						rotateVelocity = 100;
					}
				}
				
				//Fly to pot
				else if (state == FLY_TO_POT) {
					if (!IsHoldingArrow()) {
						if (Angles.GetDistance(this, new Point(shop.potPosition.x, shop.potPosition.y)) < 10) {
							ChangeState(COOKING);
						}
					}
				}
				
				//Cooking
				else if (state == COOKING) {
					if (isHoldingArrow) {
						ChangeState(FLYING);
						return;
					}
					
					if (ladleDirection == 0) velocity.x -= speed * 2.2;
					else if (ladleDirection == 1) velocity.x += speed * 2.2;
					y -= Math.sin(_lifeTimer * 0.08) * 2;
					
					if (holdItem.x <= 338) {
						holdItem.x = 338;
						ladleDirection = 1;
					} else if (holdItem.x >= 430) {
						holdItem.x = 430;
						ladleDirection = 0;
					}
					holdItem.rotation = deg2rad(velocity.x);
					holdItem.y = 68;
					holdItem.currentFrame = 1;
				}
			}
		}
		
		private function Move(passedTime:Number):void {
			_lifeTimer ++;
			
			y += Math.sin(_lifeTimer * 0.08) * 2;
			rotation = deg2rad((Math.sin(_lifeTimer * 0.15) + rotateVelocity) * 10);
			
			if (x <= position.x) velocity.x += speed;
			else if (x >= position.x) velocity.x -= speed;
			if (y <= position.y) velocity.y += speed;
			else if (y >= position.y) velocity.y -= speed;
			
			x += velocity.x * passedTime;
			y += velocity.y * passedTime;
			
			velocity.x *= 0.95;
			velocity.y *= 0.95;
			rotateVelocity *= 0.9;
		}
		
		private function ChangeState(s:int):void {
			this.state = s;
			holdItem.currentFrame = 0;
		}
		
		//Hold Items
		public function HoldItem(a:MovieClip, isArrow:Boolean):void { 
			holdItem = a;
			isHoldingArrow = isArrow;
			if (isHoldingArrow) itemOffSet.y = -5;
			else itemOffSet.y = -35;
			_posTimer = 0;
		}
		public function IsHoldingArrow():Boolean { return isHoldingArrow; }
		
		public function ChangePosition(px:int, py:int):void {
			position.x = px;
			position.y = py;
			_posTimer = 500;
		}
		
		private function onTouch(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch) DoSpin();
		}
		
		private function DoSpin():void {
			ChangeState(FLYING);
			ChangePosition(Math.random() * (GameEngine.WIDTH - 200) + 100, Math.random() * (GameEngine.HEIGHT - 200) + 100);
			velocity.x = (Math.random() - Math.random()) * 10;
			velocity.y = (Math.random() - Math.random()) * 10;
			rotateVelocity = 100;
			_rotateTimer = 0;
		}
		
	}

}