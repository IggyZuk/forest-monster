package fm.engine {
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	import flash.display3D.Context3DRenderMode;

	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	[SWF(width = "800", height = "600", frameRate = "60", backgroundColor = "#000000")]
	
	public class Main extends MovieClip {
		
		private var mStarling:Object;
		
		public function Main() {
			stop();
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, OnLoading);
			loaderInfo.addEventListener(Event.COMPLETE, OnComplete);
		}
		
		private function OnLoading(e:ProgressEvent):void {
			const PROGRESS_BAR_HEIGHT:int = 20;
			
			graphics.clear();
			graphics.beginFill(0xcccccc);
			graphics.drawRect(0, (stage.stageHeight - PROGRESS_BAR_HEIGHT) / 2,
			stage.stageWidth * e.bytesLoaded / e.bytesTotal, PROGRESS_BAR_HEIGHT);
			graphics.endFill();
		}
		
		private function OnComplete(e:Event):void {
			graphics.clear();
			gotoAndStop(2);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			const StarlingType:Class = getDefinitionByName("starling.core.Starling") as Class;
			const RootClass:Class = getDefinitionByName("fm.engine.GameEngine") as Class;
			
			StarlingType.handleLostContext = true; //Handle lost context
			
			mStarling = new StarlingType(RootClass, stage, null, null, Context3DRenderMode.AUTO); // create our Starling instance
			mStarling.antiAliasing = 0; // set anti-aliasing (higher the better quality but slower performance)
			mStarling.start(); // start it!
		}
	}
}