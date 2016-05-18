package fm.game {
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Tracker {
		
		private static var _instance:Tracker;
		
		public static const DEATH_NONE:int = 0;
		public static const DEATH_SPEED:int = 1;
		public static const DEATH_HEALTH:int = 2;
		public static const DEATH_WALL:int = 3;
		
		private var _coinNormalTotal:int = 999;
		private var _coinGoldTotal:int = 15;
		private var _coinNormalCount:int;
		private var _coinGoldCount:int;
		private var _speedCount:int;
		private var _distanceCount:Number;
		private var _deathReason:int;
		
		public static function get instance():Tracker {
			if (_instance == null) _instance = new Tracker();
			return _instance;
		}
		
		//Reset counting properties at the start of a new level
		public function ResetCounters():void {
			_coinNormalCount = _coinGoldCount = _speedCount = _distanceCount = 0;
			deathReason = DEATH_NONE;
		}
		
		//Adding coins
		public function AddNormalCoin():void { _coinNormalCount++; }
		public function AddGoldenCoin():void { _coinGoldCount++; }
		
		//Paying from store and gym
		public function PayWithNormalCoins(amount:int):Boolean { 
			if (_coinNormalTotal >= amount) {
				_coinNormalTotal -= amount; 
				return true;
			}
			return false;
		}
		public function PayWithGoldenCoins(amount:int):Boolean { 
			if (_coinGoldTotal >= amount) {
				_coinGoldTotal -= amount; 
				return true;
			}
			return false;
		}
		
		
		
		
		//Coin getters & setters
		public function get coinNormalTotal():int { return _coinNormalTotal; }
		public function get coinGoldTotal():int { return _coinGoldTotal; }
		public function get coinNormalCount():int { return _coinNormalCount; }
		public function get coinGoldCount():int { return _coinGoldCount; }
		
		//Speed & Distance getters & setters
		public function get speedCount():int { return _speedCount; }
		public function get distanceCount():Number { return _distanceCount; }
		public function set speedCount(speed:int):void { _speedCount = speed; }
		public function set distanceCount(distance:Number):void { _distanceCount = distance; }
		
		//Death reason
		public function get deathReason():int { return _deathReason; }
		public function set deathReason(reason:int):void { _deathReason = reason; }
		
	}

}