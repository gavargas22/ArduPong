package
{
	import flash.display.Stage;

	public class PongComponents extends Pong
	{
		public function PongComponents()
		{
			import flash.display.Shape;
			
			// Create the components of the game interface.
			
			var playground:Stage = new Stage;
			
			// Player one's Paddle
			var playerOnePaddle:Shape = new Shape; // initializing the variable named rectangle
			playerOnePaddle.graphics.beginFill(0x000000); // choosing the colour for the fill, here it is red
			playerOnePaddle.graphics.drawRect((playground.width - playground.width*0.95), (playground.height - playground.height*0.5), 100,100); // (x spacing, y spacing, width, height)
			playerOnePaddle.graphics.endFill(); // not always needed but I like to put it in to end the fill
			playground.addChild(playerOnePaddle); // adds the rectangle to the stage
			
			return
			
			// Player two's paddle
//			var playerTwoPaddle:Shape = new Shape; // initializing the variable named rectangle
//			playerTwoPaddle.graphics.beginFill(0xFF0000); // choosing the colour for the fill, here it is red
//			playerTwoPaddle.graphics.drawRect(0, 0, 100,100); // (x spacing, y spacing, width, height)
//			playerTwoPaddle.graphics.endFill(); // not always needed but I like to put it in to end the fill
//			addChild(playerTwoPaddle); // adds the rectangle to the stage
//			
//			playerScoreText.text = ("Player Score: " + playerScore);
//			cpuScoreText.text = ("CPU Score: " + cpuScore);
		}
	}
}