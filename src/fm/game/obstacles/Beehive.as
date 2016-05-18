package fm.game.obstacles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	import fm.game.Art;
	
	import starling.display.Image;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Beehive extends Obstacle {
		
		private var _branch:Image;
		
		public function Beehive(game:GameState) {
			super(game, Art.ObstacleAtlas.getTexture("beehive_normal"));
			
			_branch = new Image(Art.ObstacleAtlas.getTexture("beehive_branch"));
				_branch.x -= 20;
				_branch.y -= 60;
			addChild(_branch);
			
			SetUnitType(AIR_UNIT);
			SetRadius(100);
			SetPosition(GameEngine.WIDTH + width, 145);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			_branch.removeFromParent(true);
		}
		
		override protected function Move(passedTime:Number):void {
			
			//Move
			x -= (game.monster.GetMoveSpeed() * 0.75) * passedTime;;
			_branch.x -= (game.monster.GetMoveSpeed() * 0.02) * passedTime;;
			
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
			game.particleManager.AddParticle(Debris, Art.ObstacleAtlas.getTexture("beehive_branch"), x , y);
			
			//Chunks
			for (var i:int = 0; i < 5; i++) {
				game.particleManager.AddParticle(HeavyDebris, Art.ObstacleAtlas.getTexture(String("chunk_"+(i+1))), 
				x+(Math.random()-Math.random())*25, y+(Math.random()-Math.random())*25);
			}
			for (var j:int = 0; j < Math.random()*5+5; j++) {
				game.particleManager.AddParticle(Debris, Art.ObstacleAtlas.getTexture(String("chunk_"+int(Math.random()*2+4))), 
				x+(Math.random()-Math.random())*25, y+(Math.random()-Math.random())*25);
			}
		}
		
	}

}