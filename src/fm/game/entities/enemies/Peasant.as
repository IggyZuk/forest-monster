package fm.game.entities.enemies {
	import fm.states.GameState;
	import fm.game.particles.Debris;
	import fm.game.Art;
	import fm.utils.Vec2;
	import starling.core.Starling;
	
	import starling.display.MovieClip;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Peasant extends Enemy {
		
		public static var s_speed:Number;
		
		private var _speedFactor:Number;
		
		private var headClip:MovieClip;
		private var bodyClip:MovieClip;
		
		private var type:int;
		private var face:int;
		
		public function Peasant(game:GameState) {
			super(game, s_speed);
			
			//Random peasant visuals
			type = Math.random() * 3 + 1;
			if (Math.random() <= 0.05) face = 3;
			else face = Math.random() * 2 + 1;
			
			//Properties
			_speedFactor = Math.random() * 2;
			coinTextureName = String("peasant_"+type+"_coin");
			SetUnitType(GROUND_UNIT);
			
			ConstructVisuals();
			
			SetGroundPosition(0, -10);
			SetRadius(80);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			headClip.removeFromParent(true);
			bodyClip.removeFromParent(true);
		}
		
		override protected function Move(passedTime:Number):void {
			
			lifeTimer ++;
			
			//Gravity
			if (body.y + y < groundY) velocity.y += s_gravity * passedTime;
			else body.y = (groundY - y) + Math.sin(lifeTimer) * 5;
			
			body.y += velocity.y;
			headClip.x = Math.cos(lifeTimer) * 2.5 + (bodyClip.width >> 1) + 7.5;
			
			x += velocity.x + ((s_speed + _speedFactor) - game.monster.GetMoveSpeed()) * passedTime;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
		}
		
		override public function Remove():void {
			super.Remove();
			
			//Add debris
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("peasant_" + type + "_debris_1"), x, y);
			for (var i:int = 0; i < 2; i++) game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("peasant_" + type + "_debris_2"), x, y);
			if(type == 1) game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("peasant_" + type + "_debris_3"), x, y);
		}
		
		override protected function ConstructVisuals():void {
			var body_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("peasant_"+type+"_body_");
			bodyClip = new MovieClip(body_frames, 25);
			body.addChild(bodyClip);
			Starling.juggler.add(bodyClip);
			
			var head_frames:Vector.<Texture> = Art.EntityAtlas.getTextures("peasant_"+type+"_head_"+face+"_");
			headClip = new MovieClip(head_frames, 12);
			headClip.pivotX = bodyClip.width >> 1;
			headClip.pivotY = headClip.height;
			headClip.x = 8+(bodyClip.width >> 1);
			headClip.y = 15;
			body.addChild(headClip);
			Starling.juggler.add(headClip);
		}
	}

}