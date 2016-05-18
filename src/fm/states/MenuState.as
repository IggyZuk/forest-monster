package fm.states {
	import fm.engine.GameEngine;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	public class MenuState extends State {
		
		private var backgroundImage:Image;
		private var playButton:Button;
		private var titleText:TextField;
		
		override public function Init():void {
			
			backgroundImage = new Image(Art.MenuTitleTexture);
				backgroundImage.pivotX = backgroundImage.width >> 1;
				backgroundImage.pivotY = backgroundImage.height >> 1;
				backgroundImage.x = stage.stageWidth >> 1;
				backgroundImage.y = stage.stageHeight >> 1;
			addChild(backgroundImage);
			
			playButton = new Button(Art.GuiAtlas.getTexture("title_play_button"));
				playButton.pivotX = playButton.width >> 1;
				playButton.pivotY = playButton.height >> 1;
				playButton.x = stage.stageWidth >> 1;
				playButton.y = stage.stageHeight >> 1;
			addChild(playButton);
			playButton.addEventListener(Event.TRIGGERED, onTriggered);
			
			//Add Title
			titleText = new TextField(400, 36, GameEngine.title, Art.DescriptionFont.name, 32, 0xFF0070);
			titleText.hAlign = HAlign.RIGHT;
			titleText.pivotX = titleText.width;
			titleText.x = GameEngine.WIDTH - 10;
			titleText.y = 10;
			addChild(titleText);
		}
		
		override public function Cleanup():void {
			backgroundImage.removeFromParent(true);
			playButton.removeFromParent(true);
			titleText.removeFromParent(true);
			playButton.removeEventListener(Event.TRIGGERED, onTriggered);
		}
		
		override public function Update(passedTime:Number):void {
			//Some movement on background and title
			backgroundImage.rotation = Math.sin(Starling.juggler.elapsedTime) * 0.02;
		}
		
		private function onTriggered(e:Event):void {
			GameEngine.instance.stateManager.ChangeState(new IntroSceneState);
		}
	}

}