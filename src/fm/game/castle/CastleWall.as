package fm.game.castle {
	import flash.geom.Point;
	import fm.engine.GameEngine;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.obstacles.Obstacle;
	import fm.game.particles.Smoke;
	import fm.game.particles.SmokeDebris;
	import fm.game.particles.HeavyDebris;
	import starling.display.Image;
	
	import starling.events.Event;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class CastleWall extends Obstacle {
		
		protected var isAddingBackgrounds:Boolean;
		
		private var normalBody:Image;
		
		private var backBody:Image;
		private var offSet:Point;
		
		private var startingX:int;
		
		public function CastleWall(game:GameState) {
			super(game, Art.ObstacleAtlas.getTexture("wall_broke_1"));
			
			isAddingBackgrounds = true;
			
			offSet = new Point(-146, -285);
			
			//Properties
			SetUnitType(GROUND_UNIT);
			SetRadius(150);
			SetCenter(0, 0);
		}
		
		override protected function Init():void {
			SetPosition(startingX ? startingX : (GameEngine.WIDTH + width), 288);
			super.Init();
			
			//Graphics
			normalBody = new Image(Art.ObstacleAtlas.getTexture("wall_normal"));
				normalBody.x = x + offSet.x;
				normalBody.y = y + offSet.y;
			game.backLayer.addChild(normalBody);
			
			backBody = new Image(Art.ObstacleAtlas.getTexture("wall_broke_2"));
				backBody.x = x + offSet.x;
				backBody.y = y + (offSet.y - 25);
			game.backLayer.addChild(backBody);
			
			visible = false;
			backBody.visible = false;
			
			if(isAddingBackgrounds) game.backgroundManager.GetCastle().AddBackgrounds(x);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			backBody.removeFromParent(true);
			normalBody.removeFromParent(true);
		}
		
		override protected function Move(passedTime:Number):void {
			
			//Move
			x -= game.monster.GetMoveSpeed() * passedTime;
			normalBody.x = backBody.x = x + offSet.x;
			
			//Explode!
			if (x <= GetCollisionPos()) {
				if (!isExploded){
					Explode();
					game.monster.Hurt(4);
				}
			}
		}
		
		override public function Remove():void {
			if (!isExploded) Explode();
		}
		
		override protected function Explode():void {
			isExploded = true;
			
			visible = true;
			backBody.visible = true;
			
			normalBody.removeFromParent(true);
			
			for (var k:int = 0; k < Math.random() * 5 + 5; k++) game.particleManager.AddParticle(Smoke, Art.ObstacleAtlas.getTexture("log_smoke"), x+(Math.random()-Math.random())*150, y+(Math.random()-Math.random())*150);
			
			//Chunks
			for (var i:int = 0; i < 5; i++) {
				game.particleManager.AddParticle(HeavyDebris, Art.ObstacleAtlas.getTexture(String("wallchunk_"+(i+1))), 
				x+(Math.random()-Math.random())*25, y+(Math.random()-Math.random())*100);
			}
			for (var j:int = 0; j < Math.random()*5+5; j++) {
				game.particleManager.AddParticle(SmokeDebris, Art.ObstacleAtlas.getTexture(String("wallchunk_"+int(Math.random()*2+4))), 
				x+(Math.random()-Math.random())*25, y+(Math.random()-Math.random())*100);
			}
			
			game.backgroundManager.AddShake(15);
		}
		
		protected function SetStartX(px:Number):void { startingX = px; }
		
	}

}