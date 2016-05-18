package fm.gui.buttons {
	import fm.game.Art;
	
	import starling.display.MovieClip;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class CustomButton extends Sprite {
		
		protected var body:MovieClip;
		protected var bodyClip:Sprite;
		
		private var _isHovering:Boolean;
		
		public function CustomButton(texturePrefix:String) {
			
			addChild(bodyClip = new Sprite);
			
			body = new MovieClip(Art.GuiAtlas.getTextures(texturePrefix));
			bodyClip.addChild(body);
			
			addEventListener(TouchEvent.TOUCH, OnTouched);
		}
		
		public function Cleanup():void {
			body.removeFromParent(true);
			bodyClip.removeFromParent(true);
			removeEventListener(TouchEvent.TOUCH, OnTouched);
		}
		
		private function OnTouched(e:TouchEvent):void {
			var touch:Touch = e.getTouch(stage, TouchPhase.BEGAN);
			var outTouch:Touch = e.getTouch(e.target as DisplayObject, TouchPhase.HOVER);
			
			if (touch) { 
				Down();
			} else if (outTouch) {
				if (!_isHovering) {
					Hover();
					_isHovering = true;
				}
			} else {
				Out();
				_isHovering = false;
			}
		}
		
		protected function Down():void { }
		protected function Hover():void { }
		protected function Out():void { }
	}

}