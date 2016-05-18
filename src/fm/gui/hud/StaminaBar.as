package fm.gui.hud {
	import fm.states.GameState;
	import fm.game.entities.Monster;
	import fm.game.Art;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class StaminaBar extends Sprite {
		
		private var game:GameState;
		
		private var leftBar:Image;
		private var midBar:Image;
		private var rightBar:Image;
		
		private var stamina:Quad;
		
		private var staminaCurrent:int;
		private var staminaTotal:int;
		
		private var scaleVelocity:Number;
		
		public function StaminaBar(_game:GameState, px:int, py:int, scaleFactor:Number) {
			this.game = _game
			
			//Set Properties
			scaleVelocity = 0;
			staminaCurrent = _game.monster.stamina;
			staminaTotal = Monster.s_maxStamina;
			
			//Add StaminaBar parts
			leftBar = new Image(Art.GuiAtlas.getTexture("stamina_bar_left"));
				leftBar.x = 0;
			addChild(leftBar);
			
			midBar = new Image(Art.GuiAtlas.getTexture("stamina_bar_mid"));
				midBar.x = leftBar.width-(scaleFactor*0.5);
				midBar.scaleX = scaleFactor;
			addChild(midBar);
			
			rightBar = new Image(Art.GuiAtlas.getTexture("stamina_bar_right"));
				rightBar.x = leftBar.width+midBar.width-(scaleFactor);
			addChild(rightBar);
			
			stamina = new Quad(width - 20, height - 20, 0xFF8026);
				stamina.x = 10;
				stamina.y = 10;
			addChildAt(stamina, 0);
			
			//Position
			pivotX = width >> 1;
			pivotY = height >> 1;
			x = px;
			y = py;
		}
		
		public function Cleanup():void {
			leftBar.removeFromParent(true);
			midBar.removeFromParent(true);
			rightBar.removeFromParent(true);
			stamina.removeFromParent(true);
		}
		
		public function Update():void {
			scaleVelocity = staminaCurrent / staminaTotal;
			staminaCurrent = game.monster.stamina;
			
			if (stamina.scaleX <= scaleVelocity) stamina.scaleX += 0.005;
			else stamina.scaleX -= 0.005;
		}
	}

}