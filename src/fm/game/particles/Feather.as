package fm.game.particles {
	import fm.states.GameState;
	import fm.game.Art;
	
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Feather extends Particle {
		
		private var _initSpeed:Number;
		private var _moveTimer:Number;
		private var _gravity:Number;
		private var _groundHit:int;
		
		public static var s_gravity:Number;
		public static var s_velocityX:Number;
		public static var s_angleSpeed:Number;
		public static var s_slowFactor:Number;
		
		public function Feather(game:GameState, texture:Texture) {
			
			super(game, texture);
			
			life = int.MAX_VALUE;
			_initSpeed = game.monster.GetMoveSpeed();
			_moveTimer = Math.random() * 100;
			_gravity = Math.random() * s_gravity + 0.5;
			_groundHit = Math.random() * 110 + 390;
			
			Move(1);
		}
		
		override protected function Move(passedTime:Number):void {
			
			_moveTimer += s_velocityX;
			
			x += (Math.sin(_moveTimer * s_angleSpeed) - _initSpeed / s_slowFactor) * passedTime;
			y += _gravity * passedTime;
			
			rotation = (Math.sin(_moveTimer) - 3.1) * 0.5;
			
			if (y >= _groundHit) Remove();
		}
		
	}

}