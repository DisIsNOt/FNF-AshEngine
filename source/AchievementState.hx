package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;


using StringTools;

class AchievementState extends MusicBeatState {
   public static var achievementThing:Array<Array<Dynamic>> = [
     //'Name'        'description'              'image name'   'locked image name'    'is it unlocked?'
      ['Test',       'decription text here',    'debugger',     'lockedachievement',      false],
      ['Test2',      'descriptionn 2 here',     'debugger',     'lockedachievement',      false],
      ['Test3',      'haha swag',               'debugger',     'lockedachievement',      false],
      ['Test4',      'whatthefuck',             'debugger',     'lockedachievement',      false],
      ['Test5',      'beat me',                 'debugger',     'lockedachievement',      false]
   ];
   var debug:Bool = false;


   var achievementIcon:FlxSprite;
   var achievementDisplay:FlxText;
   
   var testingPurpose:FlxText;

   var selectedBg:FlxSprite;
   var descrText:FlxText;
   var descrBg:FlxSprite;


   var dafont:String = "VCR OSD Mono";
   var achievementId:Int = 0;

   var maximumNum:Int = achievementThing.length - 1;
 
   override function create() {
      saveAchievement();
      loadAchievement();
      Paths.clearStoredMemory();
      Paths.clearUnusedMemory();
 
      var bgThing:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
      bgThing.setGraphicSize(Std.int(bgThing.width * 1.1));
      bgThing.screenCenter();
      add(bgThing);


      for (i in 0...achievementThing.length) {
         if (debug) 
            trace(achievementThing[i]);

         if (achievementThing[i][4] == false) {
            achievementThing[i][2] = achievementThing[i][3];
         } else if (achievementThing[i][4] == true) {
            achievementThing[i][2] = achievementThing[i][2];
         }

         achievementIcon = new FlxSprite(0, 0).loadGraphic(Paths.image('achievements/' + achievementThing[i][2]));
         achievementIcon.setGraphicSize(Std.int(achievementIcon.width * (2 / 3)));
         achievementIcon.antialiasing = true;
         add(achievementIcon);
 
         achievementDisplay = new FlxText(achievementIcon.x + 150,0, 0, "", 20);
         achievementDisplay.font = dafont;
         achievementDisplay.text = achievementThing[i][0];
         add(achievementDisplay);

         descrText = new FlxText(achievementIcon.x + 150,0, 0, "", 20);
         descrText.font = dafont;
         descrText.text = achievementThing[i][1];
         add(descrText);


         achievementIcon.y = (i * 120) + 60;
         achievementDisplay.y = (i * 120) + 100;
         descrText.y = (i * 120) + 125;
      }



      super.create();
   }

   override function update(elapsed:Float):Void {
      if(FlxG.keys.justPressed.L) {
         //changeSelection(1);
      }
      if (FlxG.keys.justPressed.K) {
         //changeSelection(-1);
      }
      if (achievementId < 0) {
        achievementId = 0;
      }
      if (achievementId > maximumNum) {
         achievementId = achievementThing.length - 1;
      }

      if (controls.BACK){
         MusicBeatState.switchState(new MainMenuState());
      }

      //achievementDisplay.text = achievementThing[achievementId][0];
     super.update(elapsed);
  }

  public static function giveAchievement(achievementid:Int) { //0 to whatever
      for (i in 0...achievementThing.length) {
         achievementThing[achievementid][4] = true;
      }

      trace('Achievement Complete: ' + achievementThing[achievementid][0]);
      FlxG.sound.play(Paths.sound('confirmMenu'), 1);
      saveAchievement();
  }

  public static function removeAchievement(idachievement:Int) {
   for (i in 0...achievementThing.length) 
   {
      achievementThing[idachievement][4] = false;
   }


   FlxG.sound.play(Paths.sound('cancelMenu'), 0.8);
   saveAchievement();
   trace('Removed Achievement: ' + achievementThing[idachievement][0]);
  }

  
  /*
  public function changeSelection(amt:Int) {
   achievementId += amt;
   
   if (achievementId != achievementThing.length) {
   FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
   }
  }
  */


  ////   function for saving achievements idk dont touch
  public static function saveAchievement() {
   FlxG.save.data.achievementThing = achievementThing;

   FlxG.save.flush();

   trace('Achievement Saved');

   var save:FlxSave = new FlxSave();
   save.bind('AshEngine_achievement', 'AshEngine');
   save.data.achievementThing = achievementThing;
   save.flush();
  }

  public static function loadAchievement(){
   if(FlxG.save.data.achievementThing != null) {
      achievementThing = FlxG.save.data.achievementThing;
      trace('Achievement Loaded');
   } 

   var save:FlxSave = new FlxSave();
	save.bind('AshEngine_achievement', 'AshEngine');
  }
  /////////
}