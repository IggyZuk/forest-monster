package fm.game.entities.enemies {
	import fm.states.GameState;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.projectiles.Arrow;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class HorseArcher extends StateEnemy {
		
		public static var s_speed:Number;
		
		private const RUN:int = 0;
		private const ATTACK:int = 1;
		
		private var _runMovie:MovieClip;
		private var _attackMovie:MovieClip;
		private var _horseBody:MovieClip;
		
		private var _striked:Boolean;
		private var _strikeTimer:int;
		private var _alarmed:Boolean;
		
		public function HorseArcher(game:GameState) {
			super(game, s_speed);
			
			_striked = false;
			_strikeTimer = 35;
			SetUnitType(GROUND_UNIT);
			
			ConstructVisuals();
			ChangeState(RUN);
			
			SetGroundPosition(-30, -15);
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
			
			//DrawQuad(x, y);
		}
		
		private function Attack():void {
			
			//Attack
			if (x <= GetCollisionPos()+350 && !_alarmed) {
				AddYell(8, 8);
				_alarmed = true;
				//velocity.y = -15;
			}
			if (!yell && _alarmed && !_striked) {
				if (animationState != ATTACK) {
					ChangeState(ATTACK);
					AddArrow(x,y-50);
				}
			}
			//When attacking is complete, go back to riding
			if (animationState == ATTACK && movieState.isComplete) {
				ChangeState(RUN);
				_striked = true;
				velocity.y -= 10;
			}
			
			//Speed up and exit the scree
			if (_striked) velocity.x -= 0.6;
		}
		
		private function AddArrow(px:Number, py:Number):void {
			game.projectileManager.AddProjectile(Arrow, "arrow", px, py);
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_helm"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_bow"), x, y);
		}
		
		override protected function ConstructVisuals():void {
			
			//Add ride movieclip
			var run_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("archer_ride");
			_runMovie = new MovieClip(run_frames, 36);
			
			//Add attack movieclip
			var attack_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("archer_attack");
			_attackMovie = new MovieClip(attack_frames, 24);
			_attackMovie.loop = false;
			
			AddState(RUN, _runMovie);
			AddState(ATTACK, _attackMovie);
			
			//Add horse movieclip
			var horse_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("horse_run");
			_horseBody = new MovieClip(horse_frames, 60);
			
			//Add movieclips
			body.addChild (_horseBody);
			Starling.juggler.add(_horseBody);
			
			_horseBody.x = -25;
			_horseBody.y = 50;
		}
		
	}

}