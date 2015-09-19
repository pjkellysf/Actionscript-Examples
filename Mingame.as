// Clear out input handler before setting to avoid assert
_screen.SetInputHandler("");
_screen.SetInputHandler("buttonPress");
_screen.BlockInput(false);
var frameRate = 30
var gameTime = gameVarsArray[0] * frameRate;
var numSymbols = gameVarsArray[1];
var numLocks = gameVarsArray[2];
var gameSpeed = Math.floor(gameVarsArray[3] * frameRate);
var frameCounter = 0;
var bGameOver = false;
var penaltyTime = gameVarsArray[4] * frameRate;
var bPenaltyStatus = gameVarsArray[5];
var parentName = subButton;

var lockMovieArray = [lock1, lock2, lock3, lock4];
var locksToOpen = 4 - numLocks;
var openLockCounter = locksToOpen;

var masterSymbolArray = ["bottom", "L1", "right", "R1", "left", "top"];
var symbolArray = copyArray(masterSymbolArray);
var symbolXLoc = 225;
var symbolYLoc = 80;

var clipScale = 45;
var comboStartY = 308;
var comboXIncrement = 31;
var initialComboAttachDepth = 2;

var penalty = false;

var rotateSound = new Sound(this);
rotateSound.attachSound("display_switch");
var correctSound = new Sound(this);
correctSound.attachSound("correct");
var inCorrectSound = new Sound(this);
inCorrectSound.attachSound("incorrect");
var openSound = new Sound(this);
openSound.attachSound("correct_latch");

setLocks(locksToOpen);
makeCombo();
displaySymbol();

function setLocks(locksToOpen) {
	for (var i=0; i < locksToOpen; i++) {
		lockMovieArray[i].gotoAndStop("open");
		//updateAfterEvent();
	}
}

function makeCombo() {
	if(numSymbols == 6) {comboStartX = 165;}
	if(numSymbols == 5) {comboStartX = 180;}
	if(numSymbols == 4) {comboStartX = 196;}
	if(numSymbols == 3) {comboStartX = 210;}
	if((numSymbols == 2)||(numSymbols == 1)) {comboStartX = 227;}
	comboArray = [];
	for(var i=1; i <=numSymbols; i++) {
		var whichElement = getRanNum(0, (masterSymbolArray.length - 1));
		comboArray.push(masterSymbolArray[whichElement]);
	}
	comboMovieArray = []
	attachDepth = initialComboAttachDepth;
	for(var i=0; i<=comboArray.length-1; i++) {
		comboMovieArray.push(attachMovie(comboArray[i], comboArray[i] + attachDepth, attachDepth));
		newClip = comboMovieArray[i];
		newClip._x = comboStartX;
		newClip._y = comboStartY;
		newClip._xscale = clipScale;
		newClip._yscale = clipScale;
		comboStartX = comboStartX + comboXIncrement;
		if(comboArray[i] == "L1") {newClip.display.gotoAndStop("half")};
		if(comboArray[i] == "R1") {newClip.display.gotoAndStop("half")};
		attachDepth += 1;
	}
	comboStatusArray = [];
	for(var i=1; i<=numSymbols; i++) {
		comboStatusArray.push(false);
	}
}

function removeCombo() {
	for(var i=0; i<=comboMovieArray.length; i++) {
		comboMovieArray[i].removeMovieClip();
	}
}

var bPaused = false;

function checkFrame() {
	if(!bGameover && !bPaused && _screen.HaveLiveController()){
		updateTimer();
		if ((frameCounter % gameSpeed) == 0) {
			displaySymbol();
		}
		if(penalty == true) {
			penaltyCounter += 1;
			if(penaltyCounter == penaltyTime) {
				penalty = false;
				penalty_mc.gotoAndStop("off");
			}
		}
	}
}

function checkGameOver()
{
	if(bGameover == true)
	{
		_screen.BlockInput(true);
		gotoAndStop("loser");
	};
}

function updateTimer()
{
	frameCounter += 1;
	timeBar_mc._xscale = (frameCounter/gameTime) * 100;
	if(frameCounter >= gameTime)
	{
		bGameOver = true;
	}
}

function displaySymbol()
{
	if (symbolArray.length  == 0)
	{
		symbolArray = copyArray(masterSymbolArray);
	}
	rotateSound.start(0, 1);
	var whichElement = getRanNum(0, (symbolArray.length - 1));
	var whichClip = symbolArray[whichElement];
	currentSymbol = whichClip;
	var currentClip = attachMovie(whichClip, "attachedClip_mc", 1);
	currentClip._x = symbolXLoc;
	currentClip._y = symbolYLoc;
	currentClip._alpha = 50;
	currentClip.subButton.gotoAndPlay("blur");
	symbolArray.splice(whichElement, 1);
}

function copyArray(sourceArray)
{
	var targetArray = [];
	for(var i = 0; i < sourceArray.length; i++)
	{
		targetArray.push(sourceArray[i]);
	}
	return targetArray;
}

function getRanNum(loNum, hiNum)
{
	var multiplier = (hiNum + 1) - (loNum);
	return (Math.floor(Math.random() * multiplier) + loNum);
}

function checkCombos()
{
	bCompleted = true;
	for(var i=0; i < comboStatusArray.length; i++)
	{
		if(comboStatusArray[i] == false)
		{
			bCompleted = false;
		}
	}
	if(bCompleted == true)
	{
		checkLocks();
	}
}

function checkLocks()
{
	if(openLockCounter < 3)
	{
		openNextlock();
		openSound.start(0,1);
		makeCombo();
	}
	else
	{
		_screen.BlockInput(true);
		openSound.start(0,1);
		gotoAndStop("winner");
	}
}

function openNextLock()
{
	openLockCounter += 1;
	locksToOpen += 1;
	for (var i=0; i < locksToOpen; i++)
	{
		lockMovieArray[i].gotoAndStop("open");
	}
}

function lookForMatch(whichColor)
{
	bMatch = false;
	for(var i=0; i< comboArray.length; i++)
	{
		if((currentSymbol == whichColor)&&(comboArray[i] == whichColor)&&(comboStatusArray[i] == false))
		{
			correctSound.start(0, 1);
			comboStatusArray[i] = true;
			comboMovieArray[i].subButton.gotoAndPlay("hilite");
			comboMovieArray[i].display.gotoAndStop("none");
			bMatch = true;
			break;
		}
	}
}

function startPenalty()
{
	penalty = true;
	penaltyCounter = 0;
	penalty_mc.gotoAndStop("on");
}

function soundResponse()
{
	if(bMatch == false)
	{
		if(bPenaltyStatus == true)
		{
			startPenalty();
		}
		inCorrectSound.start(0, 1);
	}
	else
	{
		correctSound.start(0,1);
	}
}

function openPauseScreen()
{
	_screen.OpenChild(this.pause_mc._screen, "pause_mc");
	this.pause_mc._screen.BlockInput(true);
	pause_mc.swapDepths(1000);
	pause_mc.gotoAndPlay("start");
	pause_mc._alpha=100;
}

function buttonPress(whichButton)
{
	if (whichButton == 0) // START
	{
		if (!bPaused)
		{
			bPaused = true;
			openPauseScreen();
		}
	}
	else if(penalty == false)
	{
		var theKey = "";
		if (whichButton == 6)		{ theKey = "bottom";	}
		else if (whichButton == 7)	{ theKey = "right";		}
		else if (whichButton == 8)	{ theKey = "L1";		}
		else if (whichButton == 9)	{ theKey = "R1";		}
		else if (whichButton == 12)	{ theKey = "top";		}
		else if (whichButton == 13)	{ theKey = "left";		}
		lookForMatch(theKey);
		soundResponse();
		checkCombos();
	}
}

function removeAttachedClips() {
	attachedClip_mc.removeMovieClip();
	for(var i=0; i<comboMovieArray.length; i++)
	{
		comboMovieArray[i].removeMovieClip();
	}
}
