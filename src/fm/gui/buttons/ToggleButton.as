package fm.gui.buttons {
	import fm.game.Art;
	
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.core.Starling;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class ToggleButton extends CustomButton {
		
		private var _isOn:Boolean;
		private var tween:Tween;
		
		override public function ToggleButton(texturePrefix:String, isOn:Boolean) {
			super(texturePrefix);
			
			bodyClip.pivotX = bodyClip.width >> 1;
			bodyClip.pivotY = bodyClip.height >> 1;
			
			this._isOn = isOn;
			tween = new Tween(bodyClip, 0.5);
		}
		
		protected function Toggle():void {
			if (_isOn) _isOn = false;
			else _isOn = true;
			body.currentFrame = int(_isOn);
		}
		
		override protected function Down():void { Toggle(); }
		override protected function Hover():void { 
			tween.reset(bodyClip, 0.25, Transitions.EASE_OUT);
			tween.scaleTo(1.25);
			Starling.juggler.add(tween);
			Mouse.cursor = MouseCursor.BUTTON; 
		}
		override protected function Out():void {
			tween.reset(bodyClip, 0.25, Transitions.EASE_OUT);
			tween.scaleTo(1);
			Starling.juggler.add(tween);
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		public function get isOn():Boolean { return _isOn; }
	}

}