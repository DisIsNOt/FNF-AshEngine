package;


import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxState;



import haxe.Json;
import haxe.io.Path;
import sys.io.File;
import sys.*;


class Variables extends FlxState {

   //only variables pls

   //health drain thing
   public static var healthDrain:Bool = true;
   public static var drainAmount:Float = 0.039; //default 0.024
   public static var sustainDrainAmount:Float = 0.019;
   public static var cannotLowerThan:Float = 0.25;

   public static var sustainNoteHeal:Bool = true; //trigger sustainNote heal alot or no wdf

   public static var getUsername:String = Sys.environment().get("USERNAME");


   public static var trailEffect:Bool = false; //these two variables are for a lua scripts idk rn
   public static var trailEffectOpponentOnly:Bool = false; 

   public static var selectedSong:String = '';

   //get json file contents
   /*
   public static var fileName = "C:/Users/Intel/Desktop/FNF-AshEngine-main/source/hi.json";
   public static var fileContent = File.getContent(fileName);
   public static var jsonData = Json.parse(fileContent);
   */
}

