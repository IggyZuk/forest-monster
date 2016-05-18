package fm.gui.shop {
	import flash.geom.Rectangle;
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.game.Buyable;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.filters.BlurFilter;
	import starling.text.TextField;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Scroll extends Sprite {
		
		private var buyable:Buyable;
		private var usingNormalCoins:Boolean;
		
		private var titleIcon:Image;
		private var titleText:TextField;
		private var descriptionText:TextField;
		private var costText:TextField;
		private var buyButton:BuyButton;
		private var scrollBg:Image;
		
		public var isRemoving:Boolean;
		
		public function Scroll(buyable:Buyable, usingNormalCoins:Boolean) {
			this.buyable = buyable;
			this.usingNormalCoins = usingNormalCoins;
			
			ConstructVisuals();
			
			pivotX = width >> 1;
			pivotY = height >> 1;
			x = GameEngine.WIDTH >> 1;
			y = GameEngine.HEIGHT >> 1;
			
			//Add intro transition
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT);
			scaleX = scaleY = 0;
			tween.scaleTo(1);
			Starling.juggler.add(tween);
			
			scrollBg.filter = BlurFilter.createGlow(0x000000, 0.5, 7.5);
		}
		
		public function Cleanup():void {
			titleText.removeFromParent(true);
			descriptionText.removeFromParent(true);
			costText.removeFromParent(true);
			buyButton.removeFromParent(true);
			scrollBg.removeFromParent(true);
		}
		
		private function ConstructVisuals():void {
			scrollBg = new Image(Art.GuiAtlas.getTexture("scroll_box"));
			addChild(scrollBg);
			addChild(buyButton = new BuyButton(this, buyable, 345, 445, usingNormalCoins));
			
			titleIcon = new Image(Art.GuiAtlas.getTexture(buyable.icon));
				titleIcon.x = (width >> 1) - (titleIcon.width >> 1);
				titleIcon.y = 50;
			addChild(titleIcon);
			
			titleText = AddText(buyable.title, new Rectangle(0, 150, 350, 55), Art.DescriptionFont.name, 48);
			descriptionText = AddText(buyable.description, new Rectangle(0, 200, 350, 200), Art.DescriptionFont.name, 32, true);
			costText = AddText(String(buyable.cost), new Rectangle(200, 400, 250, 50), Art.SpeedFont.name, 32, true);
		}
		
		private function AddText(text:String, rect:Rectangle, fontName:String, size:int, isLeftAlighed:Boolean = false, isTopAlighned:Boolean = false):TextField {
			var textField:TextField = new TextField(rect.width, rect.height, text, fontName, size);
			//textField.border = true;
			textField.touchable = false;
			textField.pivotX = textField.width >> 1;
			if (rect.x == 0) textField.x = width >> 1;
			else textField.x = rect.x;
			textField.y = rect.y;
			if (isLeftAlighed) textField.hAlign = HAlign.LEFT;
			if (isTopAlighned) textField.vAlign = VAlign.TOP;
			else textField.vAlign = VAlign.CENTER;
			addChild(textField);
			return textField;
		}
		
		public function CloseingTween():Tween {
			isRemoving = true;
			var tween:Tween = new Tween(this, 0.5, Transitions.EASE_IN_OUT);
			tween.scaleTo(0);
			Starling.juggler.add(tween);
			return tween;
		}
		
	}

}