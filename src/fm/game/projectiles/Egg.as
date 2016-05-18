package fm.game.projectiles {
	import fm.game.Art;
	import fm.game.entities.enemies.Enemy;
	import fm.game.particles.Debris;
	import fm.states.GameState;
	import fm.utils.Vec2;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Egg extends Projectile {
		
		public function Egg(game:GameState, textureName:String) {
			super(game, Art.EntityAtlas.getTexture(textureName));
			velocity = new Vec2( -5, 0.1);
			
			life = int.MAX_VALUE;
			SetRadius(80);
		}
		
		override protected function Move(passedTime:Number):void {
			
			velocity.x -= 0.025 * passedTime;
			velocity.y += 0.075 * passedTime;
			
			x += velocity.x * passedTime;
			y += velocity.y * passedTime;
			
			rotation += 0.01;
			
			if (x <= game.monster.GetBodyX() + GetRadius()) {
				game.monster.Hurt();
				Remove();
			}
			
			if (y >= Enemy.GROUND_BOTTOM - 50) Remove();
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("goldegg"), x, y);
		}
		
	}

}