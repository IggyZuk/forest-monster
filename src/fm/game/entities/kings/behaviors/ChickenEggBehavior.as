package fm.game.entities.kings.behaviors {
	import fm.game.entities.kings.Chicken;
	import fm.game.Art;
	import fm.game.particles.Smoke;
	import fm.game.projectiles.Egg;
	import fm.states.GameState;
	import fm.utils.Vec2;
	
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ChickenEggBehavior implements IChickenBehavior {
		
		private var chicken:Chicken;
		private var game:GameState;
		private var body:Sprite;
		
		private var life:int;
		private var velocity:Vec2;
		
		private var isEgged:Boolean;
		
		public function ChickenEggBehavior(chicken:Chicken, game:GameState, body:Sprite) {
			this.chicken = chicken;
			this.game = game
			this.body = body;
			
			life = Math.random() * 360;
			velocity = new Vec2();
		}
		
		public function Move(passedTime:Number):void {
			
			life++;
			
			velocity.y += Math.sin(Number(life * 0.4));
			body.y += velocity.y;
			
			chicken.x += velocity.x * passedTime;
			
			if (!isEgged) {
				
				velocity.x = -2.5;
				
				if (chicken.x <= 500) {
					game.projectileManager.AddProjectile(Egg, "goldegg", chicken.x - 10, chicken.y + 25);
					game.particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("pipesmoke_1"), chicken.x - 10, chicken.y + 25);
					isEgged = true;
				}
			} else velocity.x += 0.25;
			
			velocity.x *= 0.9;
			velocity.y *= 0.9;
		}
		
		public function Remove():void {
			chicken.Kill();
		}
		
	}

}