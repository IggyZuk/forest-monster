package fm.gui.buttons {
	import fm.engine.GameEngine;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MuteButton extends ToggleButton {
		
		public function MuteButton(px:Number, py:Number) {
			super("button_mute", false);
			x = px;
			y = py;
		}
		
		override protected function Down():void {
			super.Down();
			
			//Set Mute Here...
		}
		
	}

}