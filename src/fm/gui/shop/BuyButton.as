package fm.gui.shop {
	import fm.game.Tracker;
	import fm.game.Buyable;
	import fm.gui.buttons.CustomButton;
	
	import starling.core.Starling;
	import starling.filters.GrayscaleFilter;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class BuyButton extends CustomButton {
		
		private var scroll:Scroll;
		private var buyable:Buyable;
		private var tween:Tween;
		
		private var isBuyable:Boolean;
		private var usingNormalCoins:Boolean;
		
		public function BuyButton(scroll:Scroll, buyable:Buyable, px:Number, py:Number, usingNormalCoins:Boolean) {
			super("scroll_buy");
			
			this.scroll = scroll;
			this.buyable = buyable;
			
			this.x = px;
			this.y = py;
			
			this.usingNormalCoins = usingNormalCoins;
			
			body.pivotX = width >> 1;
			body.pivotY = height >> 1;
			
			tween = new Tween(bodyClip, 0.5);
			
			CheckIsBuyable();
		}
		
		override protected function Down():void {
			if (!isBuyable) return;
			buyable.Buy(usingNormalCoins);
			CheckIsBuyable();
		}
		
		override protected function Hover():void {
			if (!isBuyable) return;
			tween.reset(bodyClip, 0.15, Transitions.EASE_OUT);
			tween.scaleTo(1.25);
			Starling.juggler.add(tween);
			
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		override protected function Out():void {
			tween.reset(bodyClip, 0.15, Transitions.EASE_IN);
			tween.scaleTo(1);
			Starling.juggler.add(tween);
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function CheckIsBuyable():void {
			var coins:int = usingNormalCoins ? Tracker.instance.coinNormalTotal : Tracker.instance.coinGoldTotal;
			if (!buyable.isBought && coins >= buyable.cost) isBuyable = true;
			else {
				isBuyable = false;
				this.filter = new GrayscaleFilter();
			}
		}
	}

}