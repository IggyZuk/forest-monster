package fm.gui.map {
	import fm.states.MapState;
	import fm.game.Art;
	import fm.engine.GameEngine;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.core.Starling;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MapBird extends Sprite {
		
		private var map:MapState;
		private var life:int;
		
		private var body:MovieClip;
		private var direction:int;
		private var speed:Number;
		
		public function MapBird(map:MapState) {
			this.map = map;
			x = Math.random() * GameEngine.WIDTH;
			y = Math.random() * 300;
			
			touchable = false;
			
			life = Math.random() * 360;
			speed = Math.random() + 0.25;
			
			var frames:Vector.<Texture> = Art.EntityAtlas.getTextures("birdiefly");
			body = new MovieClip(frames, speed*10);
			addChild(body);
			Starling.juggler.add(body);
			
			if (Math.random() <= 0.5) direction = 1;
			else direction = -1;
			
			scaleX = direction;
		}
		
		
		public function Cleanup():void {
			body.removeFromParent(true);
			Starling.juggler.remove(body);
		}
		
		public function Update(passedTime:Number):void {
			life += passedTime;
			
			x += (direction * speed) * passedTime;
			y += Math.sin(life * 0.05) * ((speed * 0.75) * passedTime);
			
			//Limits
			if (x <= -width) {
				x = GameEngine.WIDTH + width;
				y = Math.random() * 300;
			} else if (x >= GameEngine.WIDTH + width) {
				x = -width;
				y = Math.random() * 300;
			}
		}
	}

}