class Random {
	//Properties passed in through constructor
	private var pMyClip_mc:MovieClip; //instance name passed in on new method
	private var pMyDepth:Number; //depth assigned from frame script
	private var pMyHorizontalDirection:Number; //either -1 or +1 passed by new method
	private var pMyVerticalDirection:Number; //either -1 or +1 passed by the new constructor
	private var pMySpeed:Number; //random number between 1 and 5 passed by new method
	private var pMyScale:Number; //determines the scale of the new movie clip passed in by new constructor
	private var pMyInnerHeight:Number; //determines limit of x propery boundaries
	private var pMyInnerWidth:Number; //determines limit of y property boundaries
	
	//Constructor method
	public function Random (whichClip:String, whichDepth:Number, whichHorDirection:Number, whichVerDirection:Number, whichSpeed:Number, whichParent:MovieClip, whichScale:Number) {
		//Speed and direction properties which get passed are assigned here.
		pMySpeed = whichSpeed;
		pMyHorizontalDirection = whichHorDirection;
		pMyVerticalDirection = whichVerDirection;
		pMyScale = whichScale;
		
		//Create an instance of the clip on the stage
		pMyClip_mc = whichParent.attachMovie (whichClip, whichClip + whichDepth, whichDepth);		
		//Set initial location of clip so that it stay inside stage border
		pMyInnerHeight = Stage.height - pMyClip_mc._height;
		pMyInnerWidth = Stage.width - pMyClip_mc._width;
		pMyClip_mc._y = Math.floor (Math.random () * pMyInnerHeight) + (pMyClip_mc._height /2);
		pMyClip_mc._x = Math.floor (Math.random () * pMyInnerWidth) + (pMyClip_mc._width /2);
		
		//Set initial scale of the movie clip based on random scale passed in by constructor
		pMyClip_mc._xscale = pMyScale;
		pMyClip_mc._yscale = pMyScale;
		
	}
	
	//This function gets called from the frame script on enter frame
	public function updateClip() {
		if((pMyClip_mc._x > Stage.width) || (pMyClip_mc._x < 0)) {
			pMyHorizontalDirection = pMyHorizontalDirection * -1;
		}
		if((pMyClip_mc._y > Stage.height) || (pMyClip_mc._y < 0)) {
			pMyVerticalDirection = pMyVerticalDirection * -1;
		}
		pMyClip_mc._x = pMyClip_mc._x + (pMySpeed * pMyHorizontalDirection);
		pMyClip_mc._y = pMyClip_mc._y + (pMySpeed * pMyVerticalDirection);
	}
}
