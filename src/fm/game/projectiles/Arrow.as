package fm.game.projectiles {
	import fm.game.entities.enemies.Enemy;
	import fm.states.GameState;
	import fm.game.Art;
	import fm.game.particles.Debris;
	import fm.game.particles.Smoke;
	import fm.utils.Vec2
	
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Arrow extends Projectile {
		
		public static var s_gravity:Number;
		public static var s_startAngle:Number;
		public static var s_startSpeed:Number;
		public static var s_slowFactor:Number;
		
		public function Arrow(game:GameState, texture:String) {
			super(game, Art.EntityAtlas.getTexture(texture));
			
			velocity = new Vec2();
			
			//ar.myAngle = Math.atan2((mouseY-(dis/2)) - (ob.y-22), (mouseX-(Math.random()-Math.random())*50) - ob.x)/myAlpha;
			var startAngle:Number = s_startAngle;
			var startSpeed:Number = s_startSpeed;
			
			velocity.x = startSpeed * Math.cos(startAngle * (Math.PI / 180));
			velocity.y = startSpeed * Math.sin(startAngle * (Math.PI / 180));
			
			life = int.MAX_VALUE;
			
			SetRadius(80);
		}
		
		override protected function Move(passedTime:Number):void {
			velocity.y += s_gravity * passedTime;
			
			x += (velocity.x * s_slowFactor) * passedTime;
			y += (velocity.y * s_slowFactor) * passedTime;
			
			//x -= game.monster.GetMoveSpeed();
			
			rotation = Math.atan2(velocity.y, velocity.x) + deg2rad(180);
			
			if (x <= game.monster.GetBodyX() + GetRadius() || y >= Enemy.GROUND_BOTTOM - 50) {
				game.monster.Hurt();
				Remove();
			}
		}
		
		override public function Remove():void {
			super.Remove();
			game.particleManager.AddParticle(Debris, Art.EntityAtlas.getTexture("broken_arrow"), x, y);
			game.particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("pipesmoke_1"), x, y);
			game.particleManager.AddParticle(Smoke, Art.EntityAtlas.getTexture("pipesmoke_2"), x, y);
			
		}
		
	}

}