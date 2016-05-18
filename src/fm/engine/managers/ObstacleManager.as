package fm.engine.managers {
	import fm.game.backgrounds.SceneryFactory;
	import fm.states.GameState;
	import fm.game.obstacles.*;
	import fm.utils.Collision;
	import fm.gui.hud.WarningBubble;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ObstacleManager implements IManager  {
		
		private var game:GameState;
		
		private var _obstacleList:Vector.<Obstacle> = new Vector.<Obstacle>;
		private var _bubbleList:Vector.<WarningBubble> = new Vector.<WarningBubble>;
		private var _addTimer:int;
		private var _addCastleTimer:int;
		
		private var addingCastle:Boolean = false;
		
		public function ObstacleManager(game:GameState) {
			this.game = game;
			
			_addTimer = Math.random() * 200 + 300;
			_addCastleTimer = Math.random() * 200 + 1200;
		}
		
		public function Cleanup():void {
			for each(var o:Obstacle in _obstacleList) {
				o.Cleanup();
				o.removeFromParent(true);
			}
			for each(var b:WarningBubble in _bubbleList) {
				b.Cleanup();
				b.removeFromParent(true);
			}
			_obstacleList.length = 0;
			_bubbleList.length = 0;
		}
		
		public function Update(passedTime:Number):void {
			
			//Add castle when no obstacles are in the way
			if (addingCastle) {
				trace("O:", _obstacleList.length);
				if (_obstacleList.length <= 0) {
					game.backgroundManager.ExitCastle();
					game.backgroundManager.EnterCastle();
					addingCastle = false;
				}
			}
			
			//Update Obstacles
			for (var i:int = 0; i < _obstacleList.length; i++) {
				var o:Obstacle = _obstacleList[i];
				if(o.isActive) o.Update(passedTime);
				else {
					o.Cleanup();
					o.removeFromParent(true);
					_obstacleList.splice(i, 1);
					i--;
				}
			}
			//Update Bubbles
			for (var j:int = 0; j < _bubbleList.length; j++) {
				var b:WarningBubble = _bubbleList[j];
				if (b.isActive) b.Update(passedTime);
				else {
					b.Cleanup();
					b.removeFromParent(true);
					_bubbleList.splice(j, 1);
					j--;
				}
			}
			
			if (addingCastle) return; //DO NOT ADD NEW OBSTACLES WHEN CASTLE IS COMMING!
			
			//Add Obstacles
			if (_addTimer <= 0) {
				var chance:Number = Math.random();
				
				if(!game.backgroundManager.IsAddingCaslte()){
					
					/*//Castle Item
					if (game.backgroundManager.GetCastle()) {
						AddBubble(Chandelier, "warning_shrub", 145);
					} else {*/
					
					if(game.backgroundManager.GetCurrentScenery() == SceneryFactory.FOREST){
						if (chance <= 0.5) AddBubble(Log, "warning_log", 390);
						else if (chance > 0.5) AddBubble(Beehive, "warning_beehive", 145);
					} else if (game.backgroundManager.GetCurrentScenery() == SceneryFactory.SWAMP) {
						//if (chance <= 0.5) 
						AddBubble(SpikeShrub, "warning_shrub", 390);
						//else if (chance > 0.5) AddBubble(Chandelier, "warning_shrub", 145);
					}
				}
				
				_addTimer = Math.random() * 200 + 300;
			} else _addTimer -= game.monster.GetSpeedTick() * passedTime;
			
			//Add Castle
			if (_addCastleTimer <= 0) {
				
				_addCastleTimer = Math.random() * 200 + 1200;
				
				addingCastle = true;
				
			} else _addCastleTimer -= game.monster.GetSpeedTick() * passedTime;
		}
		
		public function CheckCollision(startPos:Point, endPos:Point):void {
			for (var i:int = 0; i < _obstacleList.length; i++) {
				var o:Obstacle = _obstacleList[i];
				if (!o.isActive) continue;
				
				var collisionResult:Object = Collision.LineIntersectCircle	(	
						startPos,
						endPos,
						new Point(o.x+o.GetCenter().x, o.y+o.GetCenter().y),
						o.GetRadius()
				);
				
				if (collisionResult.intersects) {
					o.Remove();
				}
			}
		}
		
		public function AddObstacle(ObstacleClass:Class):void {
			var obstacle:Obstacle = new ObstacleClass(game)
			game.frontLayer.addChildAt(obstacle, 0);
			_obstacleList.push(obstacle);
		}
		
		public function AddBubble(obstacleClass:Class, texture:String, py:int):void {
			var bubble:WarningBubble = new WarningBubble(game, obstacleClass, texture, py);
			_bubbleList.push(bubble);
			game.hud.addChild(bubble);
		}
		
		public function GetList():Vector.<Obstacle> { return _obstacleList }
		
	}

}