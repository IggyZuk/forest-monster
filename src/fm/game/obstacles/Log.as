package fm.game.obstacles {
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.particles.Smoke;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Log extends Obstacle {
		
		private var _log:Image;
		
		public function Log(game:GameState) {
			super(game, Art.ObstacleAtlas.getTexture("stomp"));
			
			_log = new Image(Art.ObstacleAtlas.getTexture("log"));
			game.backLayer.addChild(_log);
			
			SetUnitType(GROUND_UNIT);
			SetRadius(150);
			SetPosition(GameEngine.WIDTH + width, 500);
		}
		
		override protected function Init():void {
			super.Init();
			
			_log.pivotX = _log.width >> 1;
			_log.pivotY = _log.height >> 1;
			
			_log.x = x - 50;
			_log.y = y - 110;
			_log.rotation = deg2rad( -20);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			_log.removeFromParent(true);
		}
		
		override protected function Move(passedTime:Number):void {
			
			//Move
			x -= (game.monster.GetMoveSpeed() * 1.05)  * passedTime;
			_log.x -= game.monster.GetMoveSpeed() * passedTime;;
			
			//Explode!
			if (x <= GetCollisionPos()) {
				if (!isExploded){
					Explode();
					game.monster.Hurt(GetDamage());
				}
			}
		}
		
		override public function Remove():void {
			if (!isExploded) Explode();
		}
		
		override protected function Explode():void {
			super.Explode();
			
			game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), _log.x, _log.y);
			game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke_2"), _log.x, _log.y);
			
			game.particleManager.AddParticle(HeavyDebris, Art.ObstacleAtlas.getTexture("log_near_broke"), _log.x+50, _log.y-50);
			game.particleManager.AddParticle(HeavyDebris, Art.ObstacleAtlas.getTexture("log_far_broke"), _log.x - 50, _log.y + 50);
			
			//Chips
			for (var i:int = 0; i < 4; i++) {
				game.particleManager.AddParticle(Debris, Art.ObstacleAtlas.getTexture("chip_"+(i+6)), _log.x, _log.y);
			}
			for (var j:int = 0; j < Math.random()*30+15; j++) {
				game.particleManager.AddParticle(Debris, Art.ObstacleAtlas.getTexture(String("chip_"+int(Math.random()*5+1))), 
				_log.x+(Math.random()-Math.random())*50, _log.y+(Math.random()-Math.random())*50);
			}
			
			_log.removeFromParent(true);
			
			game.backgroundManager.AddShake(15);
		}
		
	}

}