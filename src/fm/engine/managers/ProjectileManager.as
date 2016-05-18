package fm.engine.managers {
	import fm.states.GameState;
	import fm.game.projectiles.*;
	import fm.utils.Collision;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ProjectileManager implements IManager {
		
		private var game:GameState;
		
		private var projectileList:Vector.<Projectile> = new Vector.<Projectile>;
		
		public function ProjectileManager(game:GameState) {
			this.game = game;
		}
		
		public function Cleanup():void {
			for each(var p:Projectile in projectileList) {
				p.Cleanup();
				p.removeFromParent(true);
			}
			projectileList.length = 0;
		}
		
		public function Update(passedTime:Number):void {
			for (var i:int = 0; i < projectileList.length; i++) {
				var p:Projectile = projectileList[i];
				if(p.isActive) p.Update(passedTime);
				else {
					p.Cleanup();
					p.removeFromParent(true);
					projectileList.splice(i, 1);
					i--;
				}
			}
		}
		
		public function CheckCollision(startPos:Point, endPos:Point):void {
			for (var i:int = 0; i < projectileList.length; i++) {
				var p:Projectile = projectileList[i];
				if (!p.isActive) continue;
				
				var collisionResult:Object = Collision.LineIntersectCircle	(	
						startPos,
						endPos,
						new Point(p.x+p.GetCenter().x, p.y+p.GetCenter().y),
						p.GetRadius()
				);
				
				if (collisionResult.intersects) {
					p.Remove();
				}
			}
		}
		
		public function AddProjectile(ProjectileClass:Class, texture:String, px:Number, py:Number):void {
			var projectile:Projectile = new ProjectileClass(game, texture)
			projectile.x = px;
			projectile.y = py;
			game.extraLayer.addChild(projectile);
			projectileList.push(projectile);
		}
		
	}

}