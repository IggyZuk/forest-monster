package fm.engine.managers {
	import fm.states.GameState;
	import fm.game.entities.enemies.*;
	import fm.game.entities.kings.*;
	import fm.game.entities.Entity;
	import fm.game.entities.Coin;
	import fm.utils.Collision;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class EntityManager implements IManager  {
		
		private var game:GameState;
		
		private var entityList:Vector.<Entity> = new Vector.<Entity>;
		
		private var enemyAddTimer:Number;
		private var peasantAddTimer:Number;
		
		private var enemyChance:int;
		private var peasantChance:int;
		
		private var debug:Boolean;
		
		public function EntityManager(game:GameState) {
			this.game = game;	
			
			SetEnemyChance(1);
			SetPeasantChance(1);
			
			enemyAddTimer = Math.random() * 50 + 25;
			peasantAddTimer = 0;
		}
		
		public function Cleanup():void {
			for each(var e:Entity in entityList) {
				e.Cleanup();
				e.removeFromParent(true);
			}
			entityList.length = 0;
		}
		
		public function Update(passedTime:Number):void {
			
			if (!debug) {
				AddEntity(ChickenKing);
				debug = true;
			}
			
			//Update all entities
			for (var i:int = 0; i < entityList.length; i++) {
				var e:Entity = entityList[i];
				if (e.isActive) e.Update(passedTime);
				else {
					e.Cleanup();
					e.removeFromParent(true);
					entityList.splice(i, 1);
					i--;
				}
			}
			
			var change:Number;
			
			//Add Enemies
			if (enemyAddTimer <= 0) {
				change = Math.random();
				
				if (change >= 0 && change <= 0.3) AddEntity(FlyingKnight);
				else if (change >= 0.3 && change <= 0.6) AddEntity(HorseKnight);
				else if (change >= 0.6 && change <= 1) AddEntity(HorseArcher);
				
				enemyAddTimer = Math.random() * 50 + 25;
			} else {
				enemyAddTimer -= game.monster.GetSpeedTick() * passedTime;
			}
			
			//Add Peasants
			if(!game.backgroundManager.GetCastle()){
				if (peasantAddTimer <= 0) {
					var amount:Number = Math.random() * 3;
					for (var a:int = 0; a < amount; a++) AddEntity(Peasant);
					
					change = Math.random();
					if (change <= 0.01) AddEntity(FishFairy);
					
					peasantAddTimer = (1 / game.monster.GetSpeedTick()) * (Math.random() + 1);
				} else peasantAddTimer -= game.monster.GetSpeedTick() * passedTime;
			}
		}
		
		//Create new Peasant
		public function AddEntity(EntityClass:Class):Entity {
			var entity:Entity = new EntityClass(game);
			entityList.push(entity);
			game.middleLayer.addChild(entity);
			return entity;
		}
		
		public function CheckCollision(startPos:Point, endPos:Point, isHitGround:Boolean):void {
			
			for (var i:int = 0; i < entityList.length; i++) {
				if (!(entityList[i] is Enemy)) continue;
				
				var e:Enemy = Enemy(entityList[i]);
				if (!e.isActive) continue;
				
				if(isHitGround) e.Jump(); //All ground entities Jump!
				
				var collisionResult:Object = Collision.LineIntersectCircle	(	
						startPos,
						endPos,
						new Point(e.x+e.GetCenter().x, e.y+e.GetCenter().y),
						e.GetRadius()
				);
				
				if (collisionResult.intersects) {
					e.Remove();
					if (!(e is FishFairy)) {
						if(e.CanAddCoin()) AddCoin(e.x, e.y, e.coinTextureName);
					}
				}
			}
			
			//Check other collisions
			game.projectileManager.CheckCollision(startPos, endPos);
			game.obstacleManager.CheckCollision(startPos, endPos);
		}
		
		public function AddCoin(px:int, py:int, textureName:String):void {
			var c:Coin = new Coin(game, textureName);
			c.x = px;
			c.y = py;
			game.hudLayer.addChild(c);
			entityList.push(c);
		}
		
		public function GetList():Vector.<Entity> { return entityList }
		
		public function SetEnemyChance(chance:Number):void { enemyChance = chance; }
		public function SetPeasantChance(chance:Number):void { peasantChance = chance; }
	}

}