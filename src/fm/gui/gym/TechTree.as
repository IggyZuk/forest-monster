package fm.gui.gym {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.Buyable;
	import fm.states.GymState;
	import fm.utils.Line;
	
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class TechTree extends Sprite {
		
		private var gym:GymState;
		private var data:XML;
		
		private var nodeLayer:Sprite;
		private var connectionLayer:Sprite;
		
		private var nodeList:Vector.<TechNode> = new Vector.<TechNode>;
		private var nodeConnectionList:Vector.<Vector.<TechNode>> = new Vector.<Vector.<TechNode>>;
		private var lineList:Vector.<Line> = new Vector.<Line>;
		
		public function TechTree(gym:GymState) {
			this.gym = gym;
			
			data = Art.GymXML;
			
			//Init Layerts
			addChild(connectionLayer = new Sprite);
			addChild(nodeLayer = new Sprite);
			
			AddNodes();
			CheckAllIsBuyable();
		}
		
		public function Cleanup():void {
			//Cleanup vectors
			for each(var n:TechNode in nodeList) {
				n.Cleanup();
				n.removeFromParent(true);
			}
			nodeList.length = 0;
			nodeConnectionList.length = 0;
			
			//Remove layers
			nodeLayer.removeFromParent(true);
			connectionLayer.removeFromParent(true);
		}
		
		public function Update():void {
			for each(var n:TechNode in nodeList) n.Update();
			RenderConnections();
		}
		
		public function CheckAllIsBuyable():void { 
			for each(var node:TechNode in nodeList) node.CheckIsBuyable();
		}
		
		private function AddNodes():void {
			
			//Off set the node layer
			nodeLayer.x = connectionLayer.x = data.@x;
			nodeLayer.y = connectionLayer.y = data.@y;
			
			//Add all nodes from buyables in upgrade manager
			for each(var buyable:Buyable in GameEngine.instance.upgradeManager.gymBuyableList) {
				var parentNode:TechNode = GetParentNode(buyable);
				var newNode:TechNode = AddNode(buyable, parentNode);
				AddConnection(newNode, parentNode);
			}
			
			ConnectWithLines(); //Finally connect the dots
		}
		
		private function GetParentNode(buyable:Buyable):TechNode {
			for each(var node:TechNode in nodeList) if (buyable.parent && buyable.parent.id == node.id) return node;
			return null;
		}
		
		private function ConnectWithLines():void {
			for (var i:int = 0; i < nodeConnectionList.length; i++) {
				var l:Line = new Line();
				l.color = data.@color;
				l.thickness = data.@thickness;
				l.moveTo(TechNode(nodeConnectionList[i][0]).position.x, TechNode(nodeConnectionList[i][0]).position.y);
				l.lineTo(TechNode(nodeConnectionList[i][1]).position.x, TechNode(nodeConnectionList[i][1]).position.y);
				connectionLayer.addChild(l);
				lineList.push(l);
			}
		}
		
		private function RenderConnections():void {
			for (var i:int = 0; i < lineList.length; i++) {
				lineList[i].moveTo(TechNode(nodeConnectionList[i][0]).position.x, TechNode(nodeConnectionList[i][0]).position.y);
				lineList[i].lineTo(TechNode(nodeConnectionList[i][1]).position.x, TechNode(nodeConnectionList[i][1]).position.y);
			}
		}
		
		private function AddNode(buyable:Buyable, parentNode:TechNode):TechNode {
			if (!buyable) return null;
			var n:TechNode = new TechNode(gym, buyable, parentNode);
			nodeList.push(n);
			nodeLayer.addChild(n);
			return n;
		}
		
		private function AddConnection(a:TechNode, b:TechNode):void {
			if (b == null) return; //If the parent node is null we skip it
			
			var v:Vector.<TechNode> = new Vector.<TechNode>;
			v.push(a);
			v.push(b);
			nodeConnectionList.push(v);
		}
		
	}

}