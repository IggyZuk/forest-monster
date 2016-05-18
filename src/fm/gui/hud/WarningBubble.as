package fm.gui.hud {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.obstacles.Obstacle;
	import fm.states.GameState;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class WarningBubble extends Sprite {
		
		private var game:GameState;
		
		public var isActive:Boolean = true;
		
		private var obstacleClass:Class;
		private var body:Image;
		
		private var startSpeed:int;
		private var addTimer:int;
		private var isObstacleAdded:Boolean;
		private var isRemoving:Boolean;
		
		public function WarningBubble(game:GameState, obstacleClass:Class, texture:String, py:Number) {
			this.game = game;
			this.obstacleClass = obstacleClass;
			
			startSpeed = game.monster.speed*4;
			addTimer = startSpeed;
			
			body = new Image(Art.GuiAtlas.getTexture(texture));
				body.pivotX = body.width;
				body.pivotY = body.height >> 1;
			addChild(body);
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			x = GameEngine.WIDTH;
			y = py;
			
			scaleX = scaleY = 0;
			
			//Bubble tween
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT_ELASTIC);
			tween.scaleTo(1.25);
			Starling.juggler.add(tween);
		}
		
		public function Cleanup():void {
			body.removeFromParent(true);
			Starling.juggler.removeTweens(this);
		}
		
		public function Update(passedTime:Number):void {
			
			body.y = Math.sin(addTimer * 0.25) * 5;
			body.scaleX = body.scaleY = 1 - (addTimer / startSpeed) + 0.5;
			
			//Remove Tween
			if (!isRemoving) {
				
				if(addTimer <= 16){
					if (alpha == 0.5 && addTimer % 3 == 0) alpha = 1;
					else if (alpha == 1 && addTimer % 3 == 0) alpha = 0.5;
				}
				if (addTimer <= 0) {
					
					game.obstacleManager.AddObstacle(obstacleClass);
					
					var tween:Tween = new Tween(this, 0.25, Transitions.EASE_OUT);
					tween.scaleTo(0);
					tween.onComplete = function ():void {
						isActive = false;
					};
					Starling.juggler.add(tween);
					
					isRemoving = true;
				} else addTimer -= passedTime;
			}
		}
		
	}

}