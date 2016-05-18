package fm.gui.buttons {
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.states.MapState;
	
	import starling.core.Starling;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class GoToMapButton extends CustomButton {
		
		private var tween:Tween;
		private var life:int;
		
		public function GoToMapButton(px:Number, py:Number) { 
			super("back_to_map");
			
			x = px;
			y = py;
			bodyClip.pivotX = bodyClip.width >> 1;
			bodyClip.pivotY = bodyClip.height >> 1;
			
			tween = new Tween(bodyClip, 0.5);
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			Starling.juggler.removeTweens(this);
		}
		
		public function Update():void {
			life++;
			x += Math.sin(life * 0.25) * 0.5;
			rotation = Math.sin(life * 0.25) * 0.1;
		}
		
		override protected function Down():void { GameEngine.instance.stateManager.ChangeState(new MapState); }
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
			Mouse.cursor = MouseCursor.AUTO;
		}
	}

}