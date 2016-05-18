package fm.engine.managers {
	import flash.geom.Point;
	import fm.game.Art;
	import fm.game.Buyable;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class UpgradeManager {
		
		private var _shopBuyableList:Vector.<Buyable> = new Vector.<Buyable>;
		private var _gymBuyableList:Vector.<Buyable> = new Vector.<Buyable>;
		
		private var _upgradedList:Vector.<int> = new Vector.<int>;
		
		public function UpgradeManager() {
			
			//Add all shop buyables
			var list:XMLList = Art.ShopXML.buyable;
			for (var i:int = 0; i < list.length(); i++) {
				AddBuyable(
					shopBuyableList,
					int(list[i].@id),
					String(list[i].@title),
					String(list[i].@desc),
					int(list[i].@cost),
					String(list[i].@icon),
					new Point(int(list[i].@x),
					int(list[i].@y))
				);
			}
			
			//Add all gym buyables
			var processList:Vector.<XMLList> = new Vector.<XMLList>;
			for each(var startNode:XML in Art.GymXML.node) processList.push(XMLList(startNode));
			
			while (processList.length > 0) {
				var nodeList:XMLList = processList.shift();
				for each(var node:XML in nodeList) {
					AddBuyable(
						gymBuyableList,
						int(node.@id),
						String(node.@title), String(node.@desc),
						int(node.@cost), String(node.@icon),
						new Point(int(node.@x), int(node.@y)),
						false,
						GetParentBuyable(int(node.parent().@id))
					);
				}
				if (nodeList.hasComplexContent()) processList.push(nodeList.node); //More nodes?
			}
		}
		
		private function AddBuyable(list:Vector.<Buyable>, id:int, title:String, description:String, cost:int, icon:String, position:Point, isBought:Boolean = false, parent:Buyable = null):void {
			list.push(new Buyable(id, title, description, cost, icon, position, isBought, parent));
		}
		
		private function GetParentBuyable(id:int):Buyable {
			for each(var buyable:Buyable in gymBuyableList) if (buyable.id == id) return buyable;
			return null;
		}
		
		public function AddUpgrade(id:int):void { 
			trace("Item Upgraded: " + id);
			_upgradedList.push(id); 
		}
		public function IsUpgraded(id:int):Boolean {
			for each(var up:int in _upgradedList) {
				if (up == id) return true;
			}
			return false;
		}
		
		public function get upgradedList():Vector.<int> { return _upgradedList; }
		public function get shopBuyableList():Vector.<Buyable> { return _shopBuyableList; }
		public function get gymBuyableList():Vector.<Buyable> { return _gymBuyableList; }
		
		
	}

}