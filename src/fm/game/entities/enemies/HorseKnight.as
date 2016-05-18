package fm.game.entities.enemies {
	import fm.states.GameState;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class HorseKnight extends StateEnemy {
		
		public static var s_speed:Number;
		
		private const RUN:int = 0;
		private const ATTACK:int = 1;
		
		private var _runMovie:MovieClip;
		private var _attackMovie:MovieClip;
		private var _horseBody:MovieClip;
		
		//Movement variables
		private var _striked:Boolean;
		private var _jumped:Boolean;
		private var _strikePosX:int;
		private var _strikeTimer:int;
		
		private var _strikeEnded:Boolean;
		
		public function HorseKnight(game:GameState) {
			super(game, s_speed);
			
			_strikePosX = Math.random() * 350 + 150;
			
			SetUnitType(GROUND_UNIT);
			
			ConstructVisuals();
			ChangeState(RUN);
			
			SetGroundPosition(0, -15);
			SetRadius(100);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			_horseBody.removeFromParent(true);
			Starling.juggler.remove(_horseBody);
		}
		
		override protected function Move(passedTime:Number):void {
			lifeTimer++;
			
			//Gravity
			if (body.y + y < groundY) velocity.y += s_gravity * passedTime;
			else {
				body.y = (groundY - y) + Math.sin(lifeTimer * 0.5) * 5;
				if (lifeTimer % 4 == 0) game.particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("horse_smoke"), x, groundY); //Add Smoke
			}
			
			x += (velocity.x + initSpeed - game.monster.GetMoveSpeed()) * passedTime;
			body.y += velocity.y * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
			
			Attack();
		}
		
		private function Attack():void {
			
			//Movement process
			if (x <= GetCollisionPos() + _strikePosX && !_jumped) {
				_jumped = true;
				_strikeTimer = 55;
				velocity.y = -15;
				AddYell(60,20);
			} else if (_strikeTimer > 0) {
				_strikeTimer--;
				if (_strikeTimer <= 40) velocity.x += _strikeTimer * 0.035;
			} else if (_strikeTimer == 0 && _jumped && animationState == RUN) {
				velocity.x -= 0.8;
			}
			
			if (x <= GetCollisionPos()) {
				if(!_striked){
					ChangeState(ATTACK);
					_striked = true;
					velocity.x = 0;
				}
				if(!_strikeEnded) x = GetCollisionPos();
			}
			
			//Hurt Monster
			if (animationState == ATTACK && movieState.isComplete) {
				ChangeState(RUN);
				game.monster.Hurt();
				_strikeEnded = true;
			}
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_helm"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_sword"), x, y);
		}
		
		override protected function ConstructVisuals():void {
			
			//Add ride movieclip
			var run_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("knight_ride");
			_runMovie = new MovieClip(run_frames, 36);
			
			//Add attack movieclip
			var attack_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("knight_attack");
			_attackMovie = new MovieClip(attack_frames, 36);
			_attackMovie.loop = false;
			
			AddState(RUN, _runMovie);
			AddState(ATTACK, _attackMovie);
			
			//Add horse movieclip
			var horse_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("horse_run");
			_horseBody = new MovieClip(horse_frames, 60);
			
			//Add movieclips
			body.addChild (_horseBody);
			Starling.juggler.add(_horseBody);
			
			_horseBody.x = 10;
			_horseBody.y = 50;
		}
		
	}

}