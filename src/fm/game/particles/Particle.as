package fm.game.particles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.states.State;
	import fm.utils.Vec2;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Particle extends Sprite {
		
		public var isActive:Boolean = true;
		
		protected var state:State;
		
		protected var life:int;
		protected var velocity:Vec2;
		protected var body:Image;
		
		public function Particle(game:State, texture:Texture) {
			this.state = game;
			
			touchable = false;
			
			body = new Image(texture);
				body.pivotX = body.width >> 1;
				body.pivotY = body.height >> 1;
			addChild(body);
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
		
		public function Remove():void { isActive = false; }
		
		public function SetVelocity(v:Vec2):void  { velocity = v; }
	}

}