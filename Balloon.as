class Tumor {
	public var pMyClip:MovieClip;
	public var pMyXLoc:Number;
	public var pMyYLoc:Number;
	public var pFrameCount:Number;
	public var pFrameToAttach:Number;
	public var pMyRotation:Number;
	public var pHitTestClip:MovieClip;
	public var pMovieToAttach:String;
	public var pSplitFrame:Number;
	public var pMyXGrowthDirection:Number;
	public var pMyYGrowthDirection:Number;
	public var bExposed:Boolean;
	public var bAttached:Boolean;
	
	public function Tumor(linkName, whatDepth, whatParent, whatX, whatY, whatFrame, rotateAngle, movieToAttach, splitFrame, xGrowthDirection, yGrowthDirection) {
		//push(new Tumor("tumor", nextDepth(), _root, 610, 60, getRanNum(50, 75), 135, "stub"))
		pMyXLoc = whatX;
		pMyYLoc = whatY;
		pMyClip = whatParent.attachMovie (linkName, linkName + whatDepth, whatDepth);
		pMyClip._x = pMyXLoc;
		pMyClip._y = pMyYLoc;
		pFrameToAttach = whatFrame;
		pFrameCount = 0;
		pMyRotation = rotateAngle;
		pMovieToAttach = movieToAttach;
		pMyClip._rotation = pMyRotation;
		pSplitFrame = splitFrame;
		pMyXGrowthDirection = xGrowthDirection;
		pMyYGrowthDirection = yGrowthDirection;
		bAttached = false;
		_global.totalTumors += 1;
		_root.tumorCount_txt.text = _global.totalTumors;
	}
	
	public function updateTumor() {
		pFrameCount += 1;
		if(pFrameCount == pFrameToAttach) {
		//pReceptorClip = pMyClip.attachMovie(whichAttachClip, "pReceptorClip", 1);
		pHitTestClip = pMyClip.attachMovie(pMovieToAttach, "pHitTestClip", 1);
		//pHitTestClip._x = pMyClip._x;
		//pHitTestClip._y = pMyClip._y;
		}
		//if (bAttached == true) {
			//trace(pHitTestClip._currentFrame);
		//}
		if (pHitTestClip._currentframe == 5) {
			//trace("I'm at frame 10");
			bExposed = true;
		}
		if (pHitTestClip._currentframe == 25) {
			//trace("I'm at frame 50");
			bExposed = false;
		}
		if(pFrameCount == pSplitFrame) {
			//pFrameCount = pFrameToAttach + 1;
			var xFactor = _root.getRanNum(-25, 25);
			var yFactor = _root.getRanNum(-25, 25);
			var rotateFactor = _root.getRanNum(-25, 25);
			var newRotation = pMyRotation + rotateFactor
			//trace(newRotation);
			var myChildXLoc = (pMyXLoc + (_root.getRanNum(50, 75) * pMyXGrowthDirection)) + xFactor;
			var myChildYLoc = (pMyYLoc + (_root.getRanNum(50, 75) * pMyYGrowthDirection)) + yFactor;
			//trace(myChildXLoc);
			//trace(myChildYLoc);
			if(_root.gTcellObject.pMyClip.hitTest(myChildXLoc, myChildYLoc)==true) {
				//trace("Under Tumor Clip!");
			}
			if(_root.gTcellObject.pMyClip.hitTest(myChildXLoc, myChildYLoc)==false) {
				//trace("Will be born");
				_global.gTumorArray.push(new Tumor("tumor", _root.nextDepth(), _root, myChildXLoc, myChildYLoc, _root.getRanNum(25, 50), newRotation, "stub", _root.getRanNum(100, 200), pMyXGrowthDirection, pMyYGrowthDirection));
				_global.totalTumors += 1;
				_root.tumorCount_txt.text = _global.totalTumors;
				bAttached = true;
			}
			if(_root.gTcellObject.pMyClip.hitTest(myChildXLoc, myChildYLoc)==true) {
				trace("Will NOT be born");
			}		
		}
	}
	
	public function getRanNum(loNum, hiNum) {
		var multiplier:Number = (hiNum+1)-(loNum);
		return (Math.floor(Math.random()*multiplier)+loNum);
	}
}	
