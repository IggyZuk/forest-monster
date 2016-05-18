package fm.engine.managers {
	import fm.engine.GameEngine;
	import fm.states.State;
	import fm.game.Art;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.animation.Tween;
	import starling.animation.Transitions;
	
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.system.System;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Ignatus Zuk
	 */
	
	public class StateManager {
		
		private var engine:GameEngine;
		
		public var currentState:State;
		private var states:Vector.<State> = new Vector.<State>;
		
		private var inTransition:Boolean;
		
		public function StateManager(engine:GameEngine, state:State) { 
			this.engine = engine; //Register our engine with state manager
			ChangeState(state);
		}
		//public function Cleanup();
		
		public function Update(passedTime:Number):void {
			if (!currentState) return;
			
			currentState.Update(passedTime);
			currentState.Draw();
		}
		
		public function ChangeState(state:State):void {
			if(inTransition) return;
			if (getQualifiedClassName(currentState) ==  getQualifiedClassName(state)) return;
			
			inTransition = true;
			
			Starling.juggler.purge(); //Clean up all previous juggler objects
			
			const tansitionTime:Number = Art.Config.state.@speed;
			const tansition:String = Art.Config.state.@transition;
			const positions:Array = [[GameEngine.WIDTH, 0], [-GameEngine.WIDTH, 0], [0, GameEngine.HEIGHT], [0, -GameEngine.HEIGHT]];
			const direction:int = Math.random() * 4;
			
			var oldState:State = currentState;
			
			//Add new state
			states.unshift(state);
			engine.gameContent.addChild(state);
			state.Init();
			
			//Move new state from right to left
			var stateTween:Tween = new Tween(state, tansitionTime, tansition);
			stateTween.onUpdate = function():void { state.clipRect = new Rectangle(state.x, state.y, GameEngine.WIDTH, GameEngine.HEIGHT); }
			state.x = positions[direction][0];
			state.y = positions[direction][1];
			stateTween.moveTo(0, 0);
			stateTween.onComplete = function():void {
				//When completed clean system and remove old state
				Mouse.cursor = MouseCursor.ARROW;
				System.gc();
				
				if(oldState){
					oldState.Cleanup();
					oldState.removeFromParent(true);
					states.shift();
				}
				inTransition = false;
			}
			Starling.juggler.add(stateTween);
			
			//Move old state to the left and remove it
			if (oldState) {
				var stateTween2:Tween = new Tween(oldState, tansitionTime, tansition);
				stateTween2.onUpdate = function():void { oldState.clipRect = new Rectangle(oldState.x, oldState.y, GameEngine.WIDTH, GameEngine.HEIGHT); }
				stateTween2.moveTo(-positions[direction][0], -positions[direction][1]);
				Starling.juggler.add(stateTween2);
			}
			
			currentState = state; //Assign current state to the new state
		}
		
		public function AddState(state:State):void {
			
			//Pause current state
			if (states.length > 0) {
				states[0].Pause();
			}
			
			//Store and init the new state
			states.unshift(state);
			engine.gameContent.addChild(state);
			states[0].Init();
			
			currentState = states[0]; //Assign the current state
		}
		
		public function RemoveState():void {
			
			//Cleanup the current state
			if (states.length > 0) {
				states[0].Cleanup();
				states[0].removeFromParent(true);
				states.shift();
			}
			
			Mouse.cursor = MouseCursor.ARROW;
			Starling.juggler.purge();
			System.gc();
			
			//Resume previous state
			if (states.length > 0) {
				states[0].Resume();
			}
			
			currentState = states[0]; //Assign the current state
		}
	}
	
	
}