package fm.game.obstacles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	import starling.display.Image;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class SpikeShrub extends Obstacle {
		
		private var _spikeshrub:Image;
		
		public function SpikeShrub(game:GameState) {
			super(game, Art.ObstacleAtlas.getTexture("spikeshrub_3"));
			
			_spikeshrub = new Image(Art.ObstacleAtlas.getTexture("spikeshrub_2"));
				_spikeshrub.x -= 30;
				_spikeshrub.y = -30;
			addChild(_spikeshrub);
			
			SetUnitType(GROUND_UNIT);
			SetRadius(100);
			SetPosition(GameEngine.WIDTH + width, 400);
		}
		
		override protected function Move(passedTime:Number):void {
			x -= game.monster.GetMoveSpeed() * passedTime;
			_spikeshrub.x -= (game.monster.GetMoveSpeed() * 0.05) * passedTime;;
			
			if (x <= GetCollisionPos()) {
				if(!isExploded){
					Remove();
					game.monster.Hurt(GetDamage());
				}
			}
		}
		
		override protected function Explode():void {
			super.Explode();
			game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x, y);
			
			//Chips
			for (var i:int = 0; i < Math.random()*10+5; i++) {
				game.particleManager.AddParticle(Debris, Art.ObstacleAtlas.getTexture(String("shrub_chunk_"+((i%8)+1))), 
				x+(Math.random()-Math.random())*50, y+(Math.random()-Math.random())*50);
			}
		}
		
	}

}