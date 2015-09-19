class Horizontal {
	//This class describes the behavior of a movie clip that moves horizontally across the stage
	
	//Instance properties which are passed in on new method
	private var pMyClip_mc:MovieClip; //instance name passed in on new method
	private var pMyDepth:Number; //depth assigned from frame script
	private var pMyHorizontalDirection:Number; //either -1 or +1 passed by new method
	private var pMySpeed:Number; //random number between 1 and 5 passed by new method
	private var pMyLinkName; //identifying name of movie passed in by constructor
	
	//Instance properties which are static
	private var pMyInnerHeight:Number; //determines limit of x propery boundaries
	private var pMyInnerWidth:Number; //determines limit of y property boundaries
	
	//Horizontal constructor method
	public function Horizontal (whichClip:String, whichDepth:Number, whichHorDirection:Number, whichSpeed:Number, whichParent:MovieClip) {
		//Speed and direction properties which get passes are assigned here.
		pMySpeed = whichSpeed;
		pMyHorizontalDirection = whichHorDirection;
		pMyDepth = whichDepth;
		pMyLinkName = whichClip;
		
		//Create and instance of the clip on the stage
		pMyClip_mc = whichParent.attachMovie (whichClip, whichClip + whichDepth, whichDepth);		
		//Set initial location of clip so that it stay inside stage border
		pMyInnerHeight = Stage.height - pMyClip_mc._height;
		pMyInnerWidth = Stage.width - pMyClip_mc._width;
		pMyClip_mc._y = Math.floor (Math.random () * pMyInnerHeight) + (pMyClip_mc._height /2);
		pMyClip_mc._x = Math.floor (Math.random () * pMyInnerWidth) + (pMyClip_mc._width /2);
		
	}
	
	//This function gets called from the frame script on enter frame
	public function moveClip() {
		//move the balloon horizontally according to its speed
		if((pMyClip_mc._x > Stage.width) || (pMyClip_mc._x < 0)) {
			pMyHorizontalDirection = pMyHorizontalDirection * -1;
		}
		pMyClip_mc._x = pMyClip_mc._x + (pMySpeed * pMyHorizontalDirection);
	}

	//This function gets called from the frame script onEnterframe
	//It checks within a passed array if this object is colliding with any of the other objects in
	//the array. Reminder, the hit test will be true when this object is compared with itself.
	public function checkCollision(whichArray):Void {
		for (var i=0; i< whichArray.length; i++) {
			//trace(i);
			//trace(whichArray[i].pMyClip_mc);
			if((whichArray[i].pMyClip_mc != pMyClip_mc) && (whichArray[i].pMyClip_mc.hitTest(pMyClip_mc))) {
				//trace(pMyLinkName + " intersects " + whichArray[i].pMyLinkName);
				_root.intersectText_txt.text = pMyLinkName + " intersects " + whichArray[i].pMyLinkName;
				if ((pMyLinkName == "MOUSE")&&(whichArray[i].pMyLinkName == "BUG")) {
					_root.displayText_txt.text = "MOUSE eats BUG";
					whichArray[i].pMyClip_mc.removeMovieClip();
				}
				if ((pMyLinkName == "BUG")&&(whichArray[i].pMyLinkName == "SHEEP")) {
					_root.displayText_txt.text = "BUG eats SHEEP";
					whichArray[i].pMyClip_mc.removeMovieClip();
				}
				if ((pMyLinkName == "SHEEP")&&(whichArray[i].pMyLinkName == "PORCUPINE")) {
					_root.displayText_txt.text = "SHEEP eats PORCUPINE";
					whichArray[i].pMyClip_mc.removeMovieClip();
				}
				if ((pMyLinkName == "PORCUPINE")&&(whichArray[i].pMyLinkName == "MOUSE")) {
					_root.displayText_txt.text = "PORCUPINE eats MOUSE";
					whichArray[i].pMyClip_mc.removeMovieClip();
				}
				var newColor:Color = new Color(pMyClip_mc);
				var colorArray = ["00", "33", "66", "99", "CC", "FF"];
				var red:String = colorArray[Math.floor(Math.random() * 6)];
				var green:String = colorArray[Math.floor(Math.random() * 6)];
				var blue:String = colorArray[Math.floor(Math.random() * 6)];
				var newHexNum = "0x" + red + green + blue;
				//trace (newHexNum);
				newColor.setRGB(newHexNum);
			}
		}
	}

}
