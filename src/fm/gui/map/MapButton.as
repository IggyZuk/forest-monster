package fm.gui.map {
	import fm.gui.buttons.CustomButton;
	import fm.engine.GameEngine;
	import fm.game.Art;
	import fm.states.State;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MapButton extends CustomButton {
		
		private var _body:Image;
		private var _text:Image;
		
		private var changeToState:Class;
		private var originPos:Point;
		private var tween:Tween;
		
		public function MapButton(texture:String, changeToState:Class, px:int, py:int, tx:int, ty:int) {
			super(texture);
			
			this.changeToState = changeToState;
			this.x = px;
			this.y = py;
			this.originPos = new Point(tx, ty);
			
			_text = new Image(Art.GuiAtlas.getTexture(texture + "_text"));
			_text.touchable = false;
			addChild(_text);
			
			tween = new Tween(_text, 0);
			
			Out();
		}
		
		override public function Cleanup():void {
			super.Cleanup();
			_text.removeFromParent(true);
			Starling.juggler.removeTweens(this);
		}
		
		override protected function Down():void {
			GameEngine.instance.stateManager.ChangeState(new changeToState);
		}
		
		override protected function Hover():void {
			
			Mouse.cursor = MouseCursor.BUTTON;
			
			body.alpha = 1;
			_text.visible = true;
			_text.alpha = 0;
			
			_text.x = originPos.x - 10;
			_text.y = originPos.y - 50;
			
			tween.reset(_text, 0.5, Transitions.EASE_OUT);
			tween.moveTo(originPos.x, originPos.y);
			tween.fadeTo(1);
			Starling.juggler.add(tween);
		}
		
		override protected function Out():void {
			
			Mouse.cursor = MouseCursor.ARROW;
			
			body.alpha = 0;
			_text.visible = false;
		}
		
	}

}