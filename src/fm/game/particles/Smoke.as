package fm.game.particles {
	import fm.states.GameState;
	import fm.states.MapState;
	import fm.states.State;
	import fm.game.Art;
	import starling.textures.Texture;
	
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Smoke extends Particle {
		
		private var _angle:Number;
		private var _scale:Number;
		private var _scaleAdd:Number;
		private var _angleAdd:Number;
		
		public static var s_life:Number;
		public static var s_lifeRandom:Number;
		public static var s_angleStart:Number;
		public static var s_angleAdd:Number;
		public static var s_scaleStart:Number;
		public static var s_scaleAdd:Number;
		
		public function Smoke(state:State, texture:Texture) {
			
			super(state, texture);
			
			life = Math.random()*s_lifeRandom + s_life;
			alpha = Math.random()+0.5;
			_angle = (Math.random()-Math.random())*s_angleStart;
			_scale = Math.random()*s_scaleStart+0.5;
			_scaleAdd = Math.random() * s_scaleAdd + 0.01;
			_angleAdd = (Math.random()-Math.random())*s_angleAdd;
			
			Move(1);
		}
		
		override protected function Move(passedTime:Number):void {
			_angle += _angleAdd * passedTime;
			_scale += _scaleAdd * passedTime;
			alpha = life * 0.025;
			
			if(state is GameState) x -= GameState(state).monster.GetMoveSpeed() * passedTime;
			if (state is MapState) {
				x += MapState(state).wind * passedTime;
				y += -1.15 * passedTime;
			}
			
			scaleX = scaleY = _scale;
			rotation = deg2rad(_angle);
		}
		
	}

}