package fm.gui.shop {
	import flash.filters.GlowFilter;
	import fm.game.Buyable;
	import fm.game.Tracker;
	import fm.gui.buttons.CustomButton;
	import fm.states.ShopState;
	import fm.game.Art;
	
	import starling.text.TextField;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.display.Image;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ShopButton extends CustomButton {
		
		private var shop:ShopState;
		private var buyable:Buyable;
		
		private var animation:Tween;
		private var titleImage:Image;
		
		public function ShopButton(shop:ShopState, buyable:Buyable) {
			super("shop_button");
			
			this.shop = shop;
			this.buyable = buyable;
			
			animation = new Tween(bodyClip, 0.5);
			
			x = buyable.position.x + shop.offSetPosition.x;
			y = buyable.position.y + shop.offSetPosition.y;
			
			//Center Body
			body.pivotX = body.width >> 1;
			body.pivotY = body.height >> 1;
			
			//Add Title Image
			titleImage = new Image(Art.GuiAtlas.getTexture(buyable.icon));
				titleImage.pivotX = titleImage.width >> 1;
				titleImage.pivotY = titleImage.height >> 1;
				titleImage.scaleX = titleImage.scaleY = 0.75;
				titleImage.alpha = 0.5;
				titleImage.touchable = false;
			bodyClip.addChild(titleImage);
			
			CheckIsNew();
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			titleImage.removeFromParent(true);
			Starling.juggler.removeTweens(this);
		}
		
		override protected function Down():void { 
			animation.reset(bodyClip, 0.25, Transitions.EASE_OUT);
			animation.scaleTo(1.5);
			Starling.juggler.add(animation);
			
			shop.OpenScroll(buyable);
		}
		override protected function Hover():void { 
			animation.reset(bodyClip, 0.25, Transitions.EASE_OUT_BOUNCE);
			animation.scaleTo(1.25);
			Starling.juggler.add(animation);
			
			titleImage.alpha = 1;
			titleImage.scaleX = titleImage.scaleY = 1;
			
			Mouse.cursor = MouseCursor.BUTTON; 
			
			//Send out events to other stuff...
			parent.setChildIndex(this, parent.numChildren - 1);
			shop.ChangeArrowPos(x, y - 100);
			
			
		}
		override protected function Out():void { 
			animation.reset(bodyClip, 0.25, Transitions.EASE_OUT_BOUNCE);
			animation.scaleTo(1);
			Starling.juggler.add(animation);
			
			titleImage.alpha = 0.5;
			titleImage.scaleX = titleImage.scaleY = 0.75;
			
			Mouse.cursor = MouseCursor.AUTO; 
		}
		
		private function CheckIsNew():void {
			if (Tracker.instance.coinNormalTotal >= buyable.cost) {
				shop.AddNewSign(buyable, x, y);
			}
		}
		
	}

}