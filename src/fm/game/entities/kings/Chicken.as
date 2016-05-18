package fm.game.entities.kings {
	import fm.game.entities.enemies.Enemy;
	import fm.game.entities.kings.behaviors.*;
	import fm.game.Art;
	import fm.game.particles.Debris;
	import fm.game.particles.Feather;
	import fm.game.particles.Smoke;
	import fm.game.projectiles.Egg;
	import fm.states.GameState;
	import fm.utils.Vec2;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Chicken extends Enemy {
		
		public static var s_speed:Number;
		
		private var isWhite:Boolean;
		private var behavior:IChickenBehavior;
		
		private var featherTimer:int;
		
		public function Chicken(game:GameState) {
			super(game, s_speed);
			
			isWhite = Boolean(Math.round(Math.random()));
			
			SetUnitType(AIR_UNIT);
			ConstructVisuals();
			
			SetGroundPosition(0, -75);
			y -= Math.random() * 125 + 50;
			scaleX = 1;
			
			behavior = new ChickenEggBehavior(this, game, body);
			
			SetCenter(0, 25);
			SetRadius(80);
		}
		
		public function SetPosition(px:int, py:int):void {
			x = px;
			y = py;
		}
		
		public function SetKingBehavior(king:ChickenKing, px:int, py:int):void {
			limitless = true;
			behavior = new ChickenKingBehavior(this, king, new Point(px, py));
		}
		
		override public function Cleanup():void {
			super.Cleanup();
		}
		
		override protected function Move(passedTime:Number):void {
			behavior.Move(passedTime);
			
			if(featherTimer <= 0){
				var featherString:String = isWhite ? "chicken_feather" : "brownfeather";
				game.particleManager.AddParticle(Feather, Art.EntityAtlas.getTexture(featherString), x, y);
				featherTimer = Math.random() * 100 + 50;
			} else featherTimer--;
		}
		
		override public function Remove():void {
			behavior.Remove();
		}
		
		public function Kill():void {
			var chickenString:String = isWhite ? "white_chicken_fly_5" : "brown_chicken_fly_5";
			
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture(chickenString), x, y);
			super.Remove();
		}
		
		override protected function ConstructVisuals():void {
			
			var chickenString:String = isWhite ? "white_chicken_fly" : "brown_chicken_fly";
			
			var fly_frames:Vector.<Texture> = Art.EntityAtlas.getTextures(chickenString);
			var flyMovie:MovieClip = new MovieClip(fly_frames, 25);
			body.addChild(flyMovie);
			Starling.juggler.add(flyMovie);
		}
		
		override public function CanAddCoin():Boolean { return false; }
		
	}

}