package fm.game.particles {
	import fm.states.GameState;
	import fm.states.State;
	import fm.game.Art;
	import fm.utils.Vec2;
	
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class SmokeDebris extends Debris {
		
		static public var s_smokeAddSpeed:int;
		static public var s_smokeAddRandom:int;
		
		private var _smokeAdd:int;
		
		public function SmokeDebris(state:State, texture:Texture) {
			super(state, texture);
			
			_smokeAdd = Math.random() * s_smokeAddRandom + s_smokeAddSpeed;
		}
			
		override protected function Move(passedTime:Number):void {
				
			//Movement
			if (_movement <= 0) _movement = 0;
			else _movement -= passedTime;
			
			//Gravity
			if (y < _groundY) {
				velocity.y += _gravity * passedTime;
			} else {
				_gravity = s_gravity
				y = _groundY;
				velocity.y = -(_movement * 0.5);
			}
			
			//Position
			x += (velocity.x - GameState(state).monster.GetMoveSpeed()) * passedTime;
			y += velocity.y * passedTime;
			
			//Vector slowdown
			var len:Number = velocity.length();
			var speed:Number = (len * 0.1) * passedTime;
			var normal:Vec2 = velocity.normalized();
			
			var force:Number = len - speed;
			
			velocity.x = (normal.x * force);
			velocity.y = (normal.y * force);
			
			//Angle
			_angle = (_angleStart + velocity.x) * _angleAdd;
			rotation = deg2rad(_angle);
			
			if (_movement > 0 && life % _smokeAdd == 0) GameState(state).particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture(String("pipesmoke_"+int(Math.random()+1))), x, y);
		}
		
	}

}