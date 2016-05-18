package fm.game.obstacles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Chandelier extends Obstacle {
		
		public function Chandelier(game:GameState) {
			super(game, Art.ObstacleAtlas.getTexture("chandelier"));
			
			SetUnitType(AIR_UNIT);
			SetRadius(100);
			SetPosition(GameEngine.WIDTH + width, 145);
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