package
{
	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.display.*;
	
	public class Pong extends Sprite
	{
		public var arduino:ArduinoConnector;
		
		public function Pong()
		{
			// Run the app initialization function.
			initApp();
			
			// Declare Socket for connection with the Arduino through Serial.
			var socket:Socket = new Socket();
			
			// Content of the App
			var distanceNumber:TextField = new TextField();
			addChild(distanceNumber);
			distanceNumber.text = "Hello World";
						
			
		}
		
		// Function that starts the Arduino and Flash Connector Setup.
		public function initApp():void
		{
			// Create a new Arduino class object. 
			arduino = new ArduinoConnector();
			// Select the COM port that we the Arduino is connected to.
			arduino.connect("COM8", 9600);
			arduino.addEventListener("socketData", getDistanceFromArdy);
		}
		// After application is closed, close the COM Port as well.
		protected function closeApp(event:Event):void
		{
			arduino.dispose();                              
		}
		
		//-----------------------------------------------------------
		
		// Testing function to send messages to an Arduino. Not needed for now so it is not called.
		// Use this if you want to call it: this.addEventListener(Event.ENTER_FRAME, sendMessage);
		public function sendMessage(event:Event):void {
			arduino.writeString("hello world");
			trace("Sent Message");
		}
		
		// This function gets the distance that is spit out by the Arduino in Centimeters.
		private function getDistanceFromArdy(aEvt: ArduinoConnectorEvent): String {
			var distanceValue:String;
			distanceValue = arduino.readBytesAsString();
			trace(arduino.readBytesAsString());
			return distanceValue;
		}
		
	}
}