package
{
	import com.quetwo.Arduino.ArduinoConnector;
	import com.quetwo.Arduino.ArduinoConnectorEvent;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class Pong extends Sprite
	{
		public var arduino:ArduinoConnector;
		
		public function Pong()
		{
			// Run the app initialization function.
			initApp();
			// Declare Socket for connection with the Arduino through Serial.
			var socket:Socket = new Socket();
			
			
			//----------------------------------------------------------- Content of the App -------------------------------------------------------------
			
			stage.addEventListener(Event.ENTER_FRAME, loop);
			
			// Position variables
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			// Other variables
			var ballSpeedX:int = -3;
			var ballSpeedY:int = -2;
			var cpuPaddleSpeed:int = 3;
			var playerScore:int = 0;
			var cpuScore:int = 0;
			
			// Player one's Paddle
			var playerOnePaddle:Shape = new Shape; // initializing the variable named rectangle
			playerOnePaddle.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
//			playerOnePaddle.graphics.drawRect((stageWidth - (stageWidth*0.97)), (stageHeight - stageHeight*0.5), 10,50); // (x spacing, y spacing, width, height)
			playerOnePaddle.graphics.drawRect(0, 0, 10,50); // (x spacing, y spacing, width, height)
			playerOnePaddle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			stage.addChild(playerOnePaddle); // adds the rectangle to the stage
			
			// Player two's Paddle
			var playerTwoPaddle:Shape = new Shape; // initializing the variable named rectangle
			playerTwoPaddle.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
			playerTwoPaddle.graphics.drawRect((stageWidth - (stageWidth*0.03)), (stageHeight - stageHeight*0.5), 10,50); // (x spacing, y spacing, width, height)
			playerTwoPaddle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			stage.addChild(playerTwoPaddle); // adds the rectangle to the stage
			
			// Ball
			var ball:Shape = new Shape; // initializing the variable named rectangle
			ball.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
			ball.graphics.drawCircle(0,0,5);
			ball.graphics.endFill(); // not always needed but I like to put it in to end the fill
			stage.addChild(ball); // adds the rectangle to the stage
			
			function calculateBallAngle(paddleY:Number, ballY:Number):Number {
				var ySpeed:Number = 5 * ( (ballY-paddleY) / 25 );
				//trace(ySpeed);
				return ySpeed;
			}
			
			function loop(e:Event):void
			{
				if( playerOnePaddle.hitTestObject(ball) == true ){
					if(ballSpeedX < 0){
						ballSpeedX *= -1;
						ballSpeedY = calculateBallAngle(playerOnePaddle.y, ball.y);
					}
					
				} else if(playerTwoPaddle.hitTestObject(ball) == true ){
					if(ballSpeedX > 0){
						ballSpeedX *= -1;
						ballSpeedY = calculateBallAngle(playerTwoPaddle.y, ball.y);
					}
					
				}
				
				if(playerTwoPaddle.y < ball.y - 10){
					playerTwoPaddle.y += cpuPaddleSpeed;
					
				} else if(playerTwoPaddle.y > ball.y + 10){
					playerTwoPaddle.y -= cpuPaddleSpeed;
				}
				
				
				playerOnePaddle.y = mouseY;
				
				//check if top of paddle is above top of screen
				if(playerOnePaddle.y - playerOnePaddle.height/2 < 0){ 
					playerOnePaddle.y = playerOnePaddle.height/2;
					
					//check if bottom of paddle is below bottom of screen
				} else if(playerOnePaddle.y + playerOnePaddle.height/2 > stage.stageHeight){
					playerOnePaddle.y = stage.stageHeight - playerOnePaddle.height/2;
				}
				
				ball.x += ballSpeedX;
				ball.y += ballSpeedY;
				
				//because the ball's position is measured by where its CENTER is...
				//...we need add or subtract half of its width or height to see if that SIDE is hitting a wall
				
				//first check the left and right boundaries
				if(ball.x <= ball.width/2){ //check if the x position of the left side of the ball is less than or equal to the left side of the screen, which would be 0
					ball.x = ball.width/2; //then set the ball's x position to that point, in case it already moved off the screen
					ballSpeedX *= -1; //and multiply the ball's x speed by -1, which will make it move right instead of left
					cpuScore ++; //increase cpuScore by 1
					//updateTextFields();
				} else if(ball.x >= stage.stageWidth-ball.width/2){ //check to see if the x position of it's right side is greater than or equal to the right side of the screen, which would be 550
					ball.x = stage.stageWidth-ball.width/2; //and set the x position to that, in case it already moved too far of the right side of the screen
					ballSpeedX *= -1; //multiply the x speed by -1 so that the ball is now moving left
					playerScore++; //increase playerScore by 1
					//updateTextFields();	
				}
				
				//now we do the same with the top and bottom of the screen
				if(ball.y <= ball.height/2){ //if the y position of the top of the ball is less than or equal to the top of the screen
					ball.y = ball.height/2; //like we did before, set it to that y position...
					ballSpeedY *= -1; //...and reverse its y speed so that it is now going down instead of up
					
				} else if(ball.y >= stage.stageHeight-ball.height/2){ //if the bottom of the ball is lower than the bottom of the screen
					ball.y = stage.stageHeight-ball.height/2; //reposition it
					ballSpeedY *= -1; //and reverse its y speec so that it is moving up now
					
				}
			}
						
			
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