package fm.game.entities.kings {
	import fm.game.entities.enemies.StateEnemy;
	import fm.states.GameState;
	import fm.game.particles.Debris;
	import fm.game.Art;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class King extends StateEnemy {
		
		public static var s_speed:Number;
		
		private var _speedFactor:Number;
		
		private const RUN:int = 0;
		private var _runMovie:MovieClip;
		
		public function King(game:GameState) {
			super(game, s_speed);
			
			SetUnitType(GROUND_UNIT);
			
			ConstructVisuals();
			ChangeState(RUN);
			
			SetGroundPosition();
			SetRadius(80);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
		}
		
		override protected function Move(passedTime:Number):void {
			
			lifeTimer += passedTime;
			
			//Gravity
			if (body.y + y < groundY) velocity.y += s_gravity * passedTime;
			else body.y = (groundY - y) + Math.sin(lifeTimer) * 5;
			
			body.y += velocity.y;
			
			x += velocity.x + ((s_speed + _speedFactor) - game.monster.GetMoveSpeed()) * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_helm"), x, y);
		}
		
		override protected function ConstructVisuals():void {
			var frames:Vector.<Texture> = Art.EntityAtlas.getTextures("king_run");
			_runMovie = new MovieClip(frames, 25);
			
			AddState(RUN, _runMovie);
		}
		
	}

}