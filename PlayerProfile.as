#include "../screen_stub.as"
stop();
alpha_mc._visible = false;
initials_mc._visible = false;
background_mc.gotoAndStop("full");

var currentName = "$UI_NEW"; //string
var currentInitials = "$UI_NEW"; //string
var currentCharIndex; //integer
var currentVibration; //boolean
var currentInvertH; //boolean
var currentInvertV; //boolean

var displayLength = 59; //this is the number of characters available

//code for setting up screen variables
var screenOptions 			= new _level0.MenuOptions();
screenOptions.numRows 		= 7;
screenOptions.numColumns 	= 1;
screenOptions.path 			= targetPath(this);
screenOptions.activate 		= "ACCEPT";
screenOptions.deactivate 	= "CANCEL";
screenOptions.defaultBack	= false;
_screen.SetMenuOptions(screenOptions);
_screen.PortLockMyControllers();

var subScreen0 = _global.screen.CreateMenu("");
var subScreen1 = _global.screen.CreateMenu("");
var subScreen2 = _global.screen.CreateMenu("");
var subScreen3 = _global.screen.CreateMenu("");
var subScreen4 = _global.screen.CreateMenu("");
var subScreen5 = _global.screen.CreateMenu("");

createSubMenu(0, 0, ".object0", subScreen0, "object0");
createSubMenu(0, 5, ".object1", subScreen1, "object1");
createSubMenu(0, _global.gameflow.GetNumberOfCharacters(), ".object2", subScreen2, "object2");
createSubMenu(0, 2, ".object3", subScreen3, "object3");
createSubMenu(0, 2, ".object4", subScreen4, "object4");
createSubMenu(0, 2, ".object5", subScreen5, "object5");

subScreen0.SetCurrentIndex(0);
subScreen1.SetCurrentIndex(0);
subScreen2.SetCurrentIndex(0);
subScreen3.SetCurrentIndex(0); 
subScreen4.SetCurrentIndex(0);
subScreen5.SetCurrentIndex(0);

subScreen0.Close();
subScreen1.Close();
subScreen2.Close();
subScreen3.Close();
subScreen4.Close();
subScreen5.Close();

function createSubMenu(numRows, numColumns, target, subScreenNum, whichClip) {
	var screenOptions 			= new _level0.MenuOptions();
	screenOptions.numRows 		= numRows;
	screenOptions.numColumns 	= numColumns
	screenOptions.path 			= targetPath(this) + target;
	if ((whichClip == "object0") || (whichClip == "object1"))
		screenOptions.activate 		= "ACCEPT";
	subScreenNum.SetMenuOptions(screenOptions);
	_screen.OpenChild(subScreenNum, whichClip, "inherit_controller");
}

var selectSound = new Sound(this);
selectSound.attachSound("ui_scroll");

var activateSound = new Sound(this);
activateSound.attachSound("ui_select");

var labels = ["name", "initials", "favorite", "vibration", "horizontal", "vertical", "saveprofile"];

function OnSelect(index) {
	selectSound.start(0, 1);
	gotoAndStop(labels[index]);
	this["object"+index].gotoAndStop("active");
	if (index >= 0 && index < 6)
	{
		_screen.OpenChild(this["subScreen"+index], "object"+index, "inherit_controller");
	}
}

function OnDeselect(index) {
	if(message_txt.text != "") {message_txt.text = ""; message_txt2.text = ""};
	this["object"+index].gotoAndStop("inactive");
	if (labels[index] == "name") 		{subScreen0.Close();}
	if (labels[index] == "initials") 	{subScreen1.Close();}
	if (labels[index] == "favorite") 		{subScreen2.Close();}
	if (labels[index] == "vibration") 	{subScreen3.Close();}
	if (labels[index] == "horizontal") 	{subScreen4.Close();}
	if (labels[index] == "vertical") 	{subScreen5.Close();}
}

function OnActivate(index) {
	activateSound.start(0, 1);
	if(labels[index]=="saveprofile") {
		if((currentName == "$UI_NEW")||(currentName == ""))
		{
			message_txt.text = "$MP_PROFILE_03";
			message_txt2.text = "$MP_PROFILE_03";
		}
		else if((currentInitials == "$UI_NEW")||(currentInitials == ""))
		{
			message_txt.text = "$MP_PROFILE_09";
			message_txt2.text = "$MP_PROFILE_09";
		}
		else
		{
			saveProfile(currentName, currentInitials, currentCharIndex, currentVibration, currentInvertH, currentInvertV);
		}
	}
	else
	{
		_screen.SetCurrentIndex(1+Number(index));
	}
}

function OnDeactivate(index)
{
	_screen.PortUnlockMyControllers();	
	_screen.Back();
}

function saveProfile(myname, initials, favCharIndex, vibration, inverth, invertv) {
	//testing saving a profile
	if(_global.profiles.CanCreateNewMPProfile()) {
		profileIndex = _global.profiles.CreateNewMPProfile(myname);
	}
	if(profileIndex == -1) {message_txt.text = "$MP_PROFILE_04"; message_txt2.text = "$MP_PROFILE_04";}
	if(profileIndex != -1) {
		_global.profiles.SetMPProfileInitials(profileIndex, initials);
		_global.profiles.SetMPProfileName(profileIndex, myname);
		_global.profiles.SetMPProfileFavoriteCharacter(profileIndex, favCharIndex);
		_global.profiles.SetMPProfileOption(profileIndex, "vibration", vibration);
		_global.profiles.SetMPProfileOption(profileIndex, "inverthoriz", inverth);
		_global.profiles.SetMPProfileOption(profileIndex, "invertvert", invertv);
		_global.profiles.SetProfileScreenFlag(true);
		OnDeactivate(6);
//		var screen = _global.screen.CreateMenu("mpgametypeselect");
//		_screen.CloseAndOpen(screen, "");
	}
}

//Profile Text Entry Code
//if you change the length of this array make sure you change the variable displayLength in the parent
var display = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
			   "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
			   "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
			   "À", "Á", "Â", "Ä", "Å", "Æ", "Ç", "È", "É", "Ê", "Ë", 
			   "Ò", "Ó", "Ô", "Ö", "Ø", "Ñ", "ß", "Ù", "Ú", "Û", "Ü", ""];

display.reverse();

function OnSelect(index) {
	_parent._parent.selectSound.start(0, 1);
	display_txt.text = _global.profiles.TranslateUTF8ToExtASCII(display[index]);
}
