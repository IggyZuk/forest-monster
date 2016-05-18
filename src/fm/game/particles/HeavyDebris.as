package fm.game.particles {
	import fm.states.State;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.utils.Vec2;
	import fm.game.entities.enemies.Enemy;
	
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class HeavyDebris extends Particle {
		
		private var _gravity:Number;
		private var _groundY:Number;
		private var _angle:Number;
		private var _angleAdd:Number;
		private var _movement:Number;
		
		public static var s_movement:Number;
		public static var s_movementRandom:Number;
		public static var s_gravity:Number;
		public static var s_velocityX:Number;
		public static var s_velocityY:Number;
		public static var s_angleAdd:Number;
		
		public function HeavyDebris(game:State, texture:Texture) {
			super(game, texture);
			
			life = int.MAX_VALUE;
			
			velocity = new Vec2((Math.random()-Math.random())*s_velocityX+10, (Math.random()-Math.random())*s_velocityY+10);
			_gravity = s_gravity;
			_groundY = Enemy.GROUND_BOTTOM - Math.random()*30; //Math.random() * (Enemy.GROUND_BOTTOM - Enemy.GROUND_TOP) + Enemy.GROUND_TOP - 15;
			_movement = Math.random() * s_movementRandom + s_movement;
			
			_angle = Math.random()*360;
			_angleAdd = (Math.random() - Math.random()) * s_angleAdd;
			
			Move(1);
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
			_angle = velocity.x * _angleAdd;
			rotation = deg2rad(_angle);
		}
		
	}

}