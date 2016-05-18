package fm.game.particles {
	import fm.utils.Vec2;
	import starling.filters.ColorMatrixFilter;
	import fm.states.GameState;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class WhiteLife extends Particle {
		
		public static var s_gravity:Number;
		public static var s_velocityX:Number;
		public static var s_velocityY:Number;
		
		private var colorFilter:ColorMatrixFilter;
		
		public function WhiteLife(game:GameState, texture:Texture) {
			super(game, texture);
			
			life = Math.random() * 50 + 50;
			velocity = new Vec2((Math.random() - Math.random()) * s_velocityX, (Math.random() - Math.random()) * s_velocityY);
			
			colorFilter = new ColorMatrixFilter();
			colorFilter.adjustBrightness(life / 1000);
			
			body.filter = colorFilter;
		}
		
		override protected function Move(passedTime:Number):void { 
			colorFilter.adjustBrightness(life / 1000);
			
			//Position
			x += (velocity.x - GameState(state).monster.GetMoveSpeed()) * passedTime;
			y += (velocity.y + s_gravity) * passedTime;
			
			//Vector slowdown
			var len:Number = velocity.length();
			var speed:Number = (len * 0.1) * passedTime;
			var normal:Vec2 = velocity.normalized();
			
			var force:Number = len - speed;
			
			velocity.x = (normal.x * force);
			velocity.y = (normal.y * force);
		}
	}

}