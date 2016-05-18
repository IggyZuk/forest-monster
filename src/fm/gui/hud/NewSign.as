package fm.gui.hud {
	import flash.geom.Point;
	import fm.game.Art;
	import fm.game.Buyable;
	
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class NewSign extends Sprite {
		
		private var body:Image;
		private var life:int;
		
		public function NewSign(buyable:Buyable, px:int, py:int) {
			buyable.IsNotNew();
			
			x = px + 15;
			y = py - 15;
			
			body = new Image(Art.GuiAtlas.getTexture("new_item_sign"));
				body.pivotY = body.height;
				body.touchable = false;
			addChild(body);
		}
		
		public function Cleanup():void {
			body.removeFromParent(true);
		}
		
		public function Update():void {
			scaleX = scaleY = Math.abs(Math.sin(++life * 0.085)) * 0.2 + 0.8;
		}
	}

}