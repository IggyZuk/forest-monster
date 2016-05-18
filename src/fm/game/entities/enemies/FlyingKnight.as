package fm.game.entities.enemies {
	import fm.states.GameState;
	import fm.game.particles.Feather;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	import fm.game.particles.Smoke;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class FlyingKnight extends StateEnemy {
		
		public static var s_speed:Number;
		
		private const FLY:int = 0;
		private const ATTACK:int = 1;
		
		private var _flyMovie:MovieClip;
		private var _attackMovie:MovieClip;
		private var _chickenBody:MovieClip;
		
		private var _featherTimer:int;
		
		private var _striked:Boolean;
		private var _strikeEnded:Boolean;
		
		public function FlyingKnight(game:GameState) {
			super(game, s_speed);
			
			//Properties
			SetUnitType(AIR_UNIT);
			
			ConstructVisuals();
			ChangeState(FLY);
			
			SetGroundPosition(0, - 75);
			y -= Math.random() * 125 + 50;
			
			SetCenter(0, -10);
			SetRadius(80);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			_chickenBody.removeFromParent(true);
			Starling.juggler.remove(_chickenBody);
		}
		
		override protected function Move(passedTime:Number):void {
			lifeTimer ++;
			
			velocity.y += Math.sin(lifeTimer * 0.4);
			body.y += velocity.y;
			
			x += velocity.x + (initSpeed - game.monster.GetMoveSpeed()) * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
			
			_chickenBody.rotation = Math.sin(lifeTimer * 0.2) * 0.15;
			
			//Add Feathers
			if (_featherTimer <= 0) {
				game.particleManager.AddParticle(Feather, Art.EntityAtlas.getTexture("chicken_feather"), x+25, y-50);
				_featherTimer = Math.random()*20+10;
			} else _featherTimer -= passedTime;
			
			Attack();
		}
		
		private function Attack():void {
			
			if (x <= GetCollisionPos()) {
				if (!_striked) {
					ChangeState(ATTACK);
					_striked = true;
				}
				if(!_strikeEnded) x = GetCollisionPos();
			}
			
			//Hurt Monster
			if (animationState == ATTACK && movieState.isComplete) {
				ChangeState(FLY);
				game.monster.Hurt();
				_strikeEnded = true;
			}
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(HeavyDebris, Art.EntityAtlas.getTexture("downed_knight"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("downed_chicken"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_helm"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_sword"), x, y);
			
			for (var i:int = 0; i < Math.random()*10+10; i++) game.particleManager.AddParticle(Feather, Art.EntityAtlas.getTexture("chicken_feather"), x + (Math.random() - Math.random()) * 50, y + (Math.random() - Math.random()) * 50 - 25);
			game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x, y);
		}
		
		override protected function GetCollisionPos():Number { return game.monster.GetBodyX() + GetRadius() + 50 }
		
		override protected function ConstructVisuals():void {
			
			//Add fly movieclip
			var fly_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("knight_flying");
			_flyMovie = new MovieClip(fly_frames, 24);
			
			//Add attack movieclip
			var attack_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("knight_fly_attack");
			_attackMovie = new MovieClip(attack_frames, 24);
			_attackMovie.loop = false;
			
			AddState(FLY, _flyMovie);
			AddState(ATTACK, _attackMovie);
			
			//Add chicken movieclip
			var chicken_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("chicken_fly");
			_chickenBody = new MovieClip(chicken_frames, 60);
			
			//Add movieclips
			body.addChild (_chickenBody);
			Starling.juggler.add(_chickenBody);
			
			//Position Chicken
			_chickenBody.pivotX = _chickenBody.width >> 1;
			_chickenBody.pivotY = _chickenBody.height;
			_chickenBody.x = 90;
			_chickenBody.y = 35;
			_chickenBody.scaleX = -1;
		}
		
	}

}