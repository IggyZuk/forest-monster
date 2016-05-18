package fm.game.backgrounds {
	import fm.engine.GameEngine;
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
	public class Background extends Sprite {
		
		public var isActive:Boolean = true;
		private var isRemove:Boolean;
		
		private var game:GameState;
		
		private var distance:int;
		private var isItem:Boolean;
		
		private var backgroundImage:Image;
		
		public function Background(game:GameState, texture:Texture, distance:Number, isItem:Boolean) {
			this.game = game;
			this.distance = distance;
			this.isItem = isItem;
			
			//Add Image with Texture
			backgroundImage = new Image(texture);
			if(!isItem) backgroundImage.scaleX = 1.001; //Connection between backgrounds fix
			addChild(backgroundImage);
		}
		
		public function Cleanup():void {
			backgroundImage.removeFromParent(true);
		}
		
		public function Update(passedTime:Number):void {
			x -= (game.monster.speed / distance) * passedTime; //Move dependant on distance
			
			//Restart position dependant on type
			if (!isItem) {
				if (x <= -width) {
					if (isRemove) isActive = false;
					else x += width << 1;
				}
			} else {
				if (x <= -width) {
					if (isRemove || (game.backgroundManager.GetCastle() && distance == 1)) isActive = false;
					else x += (GameEngine.WIDTH + width) + Math.floor(Math.random()*250);
				}
			}
		}
		
		public function SetRemove():void {
			isRemove = true;
		}
	}

}