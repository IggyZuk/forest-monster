package fm.game {
	import fm.engine.GameEngine;
	import fm.events.UpgradeEvent;
	
	import starling.events.EventDispatcher;
	
	import flash.geom.Point;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Buyable {
		
		private var _id:int;
		private var _title:String;
		private var _description:String;
		private var _cost:int;
		private var _icon:String;
		
		private var _position:Point;
		private var _isBought:Boolean;
		private var _parent:Buyable;
		
		private var _isNew:Boolean;
		
		public function Buyable(id:int, title:String, description:String, cost:int, icon:String, position:Point, isBought:Boolean = false, parent:Buyable = null) {
			this._id = id;
			this._title = title;
			this._description = description;
			this._cost = cost;
			this._icon = icon;
			
			this._position = position;
			this._isBought = isBought;
			this._parent = parent;
			this._isNew = true;
		}
		
		public function Buy(usingNormalCoins:Boolean):Boolean {
			if(usingNormalCoins){
				if (Tracker.instance.PayWithNormalCoins(cost)) {
					GameEngine.instance.upgradeManager.AddUpgrade(_id);
					_isBought = true;
				}
			} else {
				if (Tracker.instance.PayWithGoldenCoins(cost)) {
					GameEngine.instance.upgradeManager.AddUpgrade(_id);
					_isBought = true;
				}
			}
			
			//Send upgrade bought event
			var upEvent:UpgradeEvent = new UpgradeEvent(UpgradeEvent.BOUGHT);
			upEvent.message = String("Successfully bought " + title);
			GameEngine.instance.stage.dispatchEvent(upEvent);
			
			return _isBought;
		}
		
		public function IsNotNew():void { _isNew = false; }
		
		public function get id():int { return _id; }
		public function get title():String { return _title; }
		public function get description():String { return _description; }
		public function get cost():int { return _cost; }
		public function get icon():String { return _icon; }
		public function get position():Point { return _position; }
		public function get isBought():Boolean { return _isBought; }
		public function get parent():Buyable { return _parent; }
		public function get isNew():Boolean { return _isNew; }
		
	}

}