package fm.gui.buttons {
	import fm.engine.GameEngine;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class PauseButton extends ToggleButton {
		
		public function PauseButton(px:Number, py:Number) {
			super("button_pause", false);
			x = px;
			y = py;
		}
		
		override protected function Down():void {
			super.Down();
			
			//GameEngine.instance.isPaused = isOn;
			
			//Pause Game Here...
		}
		
	}

}