package fm.gui.hud {
	import flash.geom.Rectangle;
	import fm.engine.GameEngine;
	import fm.states.State;
	import fm.game.Art;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class Hud extends Sprite {
		
		public function Hud() { }
		public function Cleanup():void { }
		public function Update(passedTime:Number):void { }
		
		protected function AddText(rect:Rectangle, txt:String, font:BitmapFont, color:uint = 0xFFFFFF, hAlign:String = "left"):TextField {
			var text:TextField = new TextField(rect.width, rect.height, txt, font.name, font.size, color);
			text.hAlign = hAlign;
			text.vAlign = VAlign.TOP;
			text.x = rect.x;
			text.y = rect.y;
			text.height = text.textBounds.height + 10;
			if(GameEngine.instance.debug) text.border = true;
			
			return text;
		}
		
		protected function SetText(textField:TextField, value:int):void { textField.text = String(value); }
		
		protected function AddImage(name:String, px:int, py:int):Image {
			var image:Image = new Image(Art.GuiAtlas.getTexture(name));
			image.x = px;
			image.y = py;
			return image;
		}
	}

}