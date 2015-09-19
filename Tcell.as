class Tcell {
	public var pMyClip:MovieClip;
	public var bDestroying:Boolean;
	public var pClipToRemove:MovieClip;
	public var pRemoveObjectIndex:Number;
	public var pDiffX:Number;
	public var pDiffY:Number;
	public var pMouse_x:Number;
	public var pMouse_y:Number;
	//public var pReceptorClip:MovieClip;
	public var pLastXLoc:Number;
	public var pLastYLoc:Number;
	public var pLastRotation:Number;
	public var pNewXLoc:Number;
	public var pNewYLoc:Number;
	public var pIntersecting:Boolean;
	
	//constructor
	public function Tcell(whichClip, whichAttachClip) {
		pMyClip = whichClip
		bDestroying = false;
		pRemoveObjectIndex = 0;
		//pReceptorClip = pMyClip.attachMovie(whichAttachClip, "pReceptorClip", 1);
		//pReceptorClip._x = 50;
		//pReceptorClip._y = 30;
		//trace(pReceptorClip);
	}
	
	public function updatePosition(whichArray) {
		//Store the last position in variables
		pLastXLoc = pMyClip._x;
		pLastYLoc = pMyClip._y;
		pIntersecting = false;
		
		//Determine what the new positions will be and store them in variables
		pDiffX = _root._xmouse - pMyClip._x;
		pDiffY = _root._ymouse - pMyClip._y;
    	pNewXLoc = pMyClip._x + pDiffX/10;
		pNewYLoc = pMyClip._y + pDiffY/10;
			
		//Determine the new rotation
		if (bDestroying == false) {
			pLastRotation = pMyClip._rotation;
			pMouse_x = int(_root._xmouse - pMyClip._x);
			pMouse_y = int(_root._ymouse - pMyClip._y);
			var quad;
			if (pMouse_x>0 && pMouse_y>0) {
				quad = Number(4);
			}
			if (pMouse_x<0 && pMouse_y>0) {
				quad = Number(1);
			}
			if (pMouse_x<0 && pMouse_y<0) {
				quad = Number(2);
			}
			if (pMouse_x>0 && pMouse_y<0) {
				quad = Number(3);
			}
			var angle;
			var abs_x = Math.abs(pMouse_x);
			var abs_y = Math.abs(pMouse_y);
			var tg = abs_y/abs_x;
			var maths = Math.atan(tg)*Number(180)/Math.PI;
 			if (quad == 1) { angle = number(90) - number(maths) }
			if (quad == 2) { angle = number(90) + number(maths) }
 			if (quad == 3) { angle = number(270) - number(maths) }
 			if (quad == 4) { angle = number(270) + number(maths) }
			pMyClip._rotation = angle;	
		}

		//Find out if the new position is intersecting any of the tumors
		for(var i=0; i<whichArray.length; i++) {
			if ((whichArray[i].pMyClip.hitTest(pNewXLoc, pNewYLoc, true) == true)) {
				//trace("Bumped into Tumor");
				pIntersecting = true;
			}
		}
		
		//Checks to see if the Tcell is off the stage and puts it back asteroids style
		if(pMyClip._y < 0) {
			//trace("Off the top");
			pMyClip._y = 0;
		}
		if(pMyClip._y > 600) {
			//trace("Off the bottom");
			pMyClip._y = 600;
		}
		if(pMyClip._x < 0) {
			//trace("Off the left");
			pMyClip._x =0;
		}
		if(pMyClip._x > 800) {
			//trace("Off the right");
			pMyClip._x = 800;
		}
		
		if(pIntersecting == true) {
			pMyClip._x = pLastXLoc;
			pMyClip._y = pLastYLoc;
			//pMyClip._rotation = pLastRotation;
		}
		
		if(pIntersecting == false) {
			pMyClip._x = pNewXLoc;
			pMyClip._y = pNewYLoc;
			//pMyClip._rotation = pLastRotation;
		}
	}
	
	public function checkCollision(whichArray) {
		//trace("Checking collision!");
		for (var i=0; i<whichArray.length; i++) {
			//pReceptorClip
			//trace(whichArray[i].bExposed);
			//if ((whichArray[i].pMyClip.pHitTestClip.hitTest(pReceptorClip) == true))
			if ((whichArray[i].pMyClip.pHitTestClip.hitTest(pMyClip) == true)&&(whichArray[i].bExposed == true)){
				bDestroying = true;
				pMyClip.gotoAndPlay("destroy");
				whichArray[i].pMyClip.pHitTestClip.stop();
				pClipToRemove = whichArray[i].pMyClip;
				pRemoveObjectIndex = i;

			}		
		}
	}
}
