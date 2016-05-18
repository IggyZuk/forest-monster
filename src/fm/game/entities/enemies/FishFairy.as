package fm.game.entities.enemies {
	import fm.engine.GameEngine;
	import fm.game.particles.WhiteLife;
	import fm.states.GameState;
	import fm.utils.Vec2;
	import fm.game.Art;
	import fm.game.particles.Debris;
	import fm.game.particles.HeavyDebris;
	import fm.game.particles.Smoke;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class FishFairy extends StateEnemy {
		
		public static var s_speed:Number;
		
		private const FLY:int = 0;
		private var flyMovie:MovieClip;
		private var fishCan:Image;
		
		private var sinSpeed:Number;
		
		public function FishFairy(game:GameState) {
			super(game, s_speed);
			
			//Properties
			SetUnitType(AIR_UNIT);
			
			ConstructVisuals();
			ChangeState(FLY);
			
			SetGroundPosition(0, - 75);
			y -= Math.random() * 50 + 150;
			
			SetCenter(5, 45);
			SetRadius(75);
			
			sinSpeed = Math.random() * 0.2 + 0.1;
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			flyMovie.removeFromParent(true);
			fishCan.removeFromParent(true);
		}
		
		override protected function Move(passedTime:Number):void {
			lifeTimer ++;
			
			velocity.y += Math.sin(lifeTimer * sinSpeed);
			y += velocity.y;
			
			x += velocity.x + (initSpeed - game.monster.GetMoveSpeed()) * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
			
			fishCan.rotation = Math.sin(lifeTimer * 0.2) * 0.15;
			
			if (lifeTimer % 7 == 0) game.particleManager.AddParticle(WhiteLife, Art.EntityAtlas.getTexture("can_sparkle"), x+GetCenter().x, y+GetCenter().y);
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(HeavyDebris, Art.EntityAtlas.getTexture("fish_can_down"), x, y);
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("fishfairy_down"), x, y);
			
			game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x, y);
			game.monster.AddHealth(4);
		}
		
		override protected function ConstructVisuals():void {
			
			//Add fly movieclip
			var fly_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("fishfairy_fly");
			flyMovie = new MovieClip(fly_frames, 24);
			
			AddState(FLY, flyMovie);
			
			//Add chicken movieclip
			fishCan = new Image(Art.EntityAtlas.getTexture("fish_can"));
			body.addChild (fishCan);
			
			//Position Chicken
			fishCan.pivotX = fishCan.width >> 1;
			fishCan.x = 40;
			fishCan.y = 50;
		}
	}

}