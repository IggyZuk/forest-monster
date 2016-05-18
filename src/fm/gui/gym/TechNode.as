package fm.gui.gym {
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import fm.game.Buyable;
	import fm.game.Tracker;
	import fm.gui.buttons.CustomButton;
	import fm.game.Art;
	import fm.states.GymState;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	import starling.filters.BlurFilter;
	import starling.filters.GrayscaleFilter;
	import starling.filters.ColorMatrixFilter;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class TechNode extends CustomButton {
		
		private var gym:GymState;
		
		private var buyable:Buyable;
		private var _parentNode:TechNode;
		private var isBuyable:Boolean;
		
		private var speed:Number;
		private var bounce:Number;
		
		private var _life:int;
		private var _tween:Tween;
		
		public function TechNode(gym:GymState, buyable:Buyable, parentNode:TechNode) {
			super(buyable.icon);
			
			this.gym = gym;
			this.buyable = buyable;
			this._parentNode = parentNode;
			
			speed = Art.GymXML.@speed;
			bounce = Art.GymXML.@bounce;
			
			bodyClip.pivotX = bodyClip.width >> 1;
			bodyClip.pivotY = bodyClip.height >> 1;
			
			x = buyable.position.x;
			y = buyable.position.y;
			
			_life = Math.random() * 360;
			_tween = new Tween(bodyClip, 0.5);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			Starling.juggler.removeTweens(this);
		}
		
		public function Update():void {
			_life++;
			bodyClip.y = Math.sin(_life * speed) * bounce;
			bodyClip.rotation = Math.cos(_life * speed) * 0.05;
		}
		
		override protected function Down():void {
			if (!isBuyable) return;
			gym.OpenScroll(buyable);
		}
		
		override protected function Hover():void {
			if (!isBuyable) return;
			_tween.reset(bodyClip, 0.25, Transitions.EASE_OUT);
			_tween.scaleTo(1.5);
			Starling.juggler.add(_tween);
			parent.setChildIndex(this, parent.numChildren - 1);
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		override protected function Out():void {
			_tween.reset(bodyClip, 0.25, Transitions.EASE_OUT);
			_tween.scaleTo(1);
			Starling.juggler.add(_tween);
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		public function CheckIsBuyable():void {
			
			if (buyable.isBought) {
				body.filter = BlurFilter.createGlow(0xFFFF22, 3, 1, 0.5);
				body.alpha = 0.65;
				isBuyable = true;
				return;
			}
			
			//Is there a parent node?
			if(parentNode) {
				if (parentNode.buyable.isBought) {
					if (Tracker.instance.coinGoldTotal >= buyable.cost) isBuyable = true;
				} else isBuyable = false;
			} else {
				if (Tracker.instance.coinGoldTotal >= buyable.cost) isBuyable = true;
				else isBuyable = false;
			}
			
			//Colorize
			if (isBuyable) {
				body.filter = null;
				var pos:Point = new Point(Art.GymXML.@x, Art.GymXML.@y);
				gym.AddNewSign(buyable, pos.x+x, pos.y+y); //Add new sign if the node is NEW!
			} else body.filter = new GrayscaleFilter();
		}
		
		public function get id():int { return buyable != null ? buyable.id : 0; }
		public function get position():Point { return new Point(x + bodyClip.x, y + bodyClip.y) }
		public function get parentNode():TechNode { return _parentNode; }
	}

}