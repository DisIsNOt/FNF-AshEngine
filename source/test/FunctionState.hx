package test;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;


import lime.app.Application;
import lime.app.Event;
import openfl.Lib;
import haxe.Exception;

import sys.io.File;
import sys.FileSystem;

import flixel.util.FlxSave;

using StringTools;


class TestState extends MusicBeatState {

  

   public static var buildPath = FileSystem.fullPath("assets");
   public static var pathThing:String = "\\images\\";
   public static var fileName:String = "path.txt";
   public static var fullThing = buildPath + pathThing + fileName; 

   override public function create() {
      super.create();


      var hahashit:FlxText = new FlxText(0,0, "Nothing is here Press ESC to exit");
      hahashit.size = 20;
      add(hahashit);

   }

   override public function update(elapsed:Float):Void {
      super.update(elapsed);

      if (FlxG.keys.pressed.ESCAPE) {
         trace("pressed esc");
         MusicBeatState.switchState(new TitleState());
         changeWindowTitle("Friday Night Funkin': save");

      }

      FlxG.mouse.visible = true;
   } 

   public static function alertWindow(datitle:String, damessage:String) {
      Application.current.window.alert(damessage, datitle);
   }

   public static function changeWindowTitle(windowTitle:String) {
      Application.current.window.title = windowTitle;
   }

   public static function closeWindow() {
         Lib.current.stage.window.close(); 
   }

   public static function deleteFile(path:String, filePath:String, alertMessage:Bool) {
      var daPath = FileSystem.fullPath(path);
      var daPathSec = daPath + "\\";
      var daFilePath = filePath;
      var daDeletePath = daPathSec + daFilePath;

      var fullDeletePath = StringTools.replace(daDeletePath, "/", "\\");

      if (sys.FileSystem.exists(fullDeletePath)) {
         sys.FileSystem.deleteFile(fullDeletePath);
         if (alertMessage == true) {
            Application.current.window.alert("File : " + filePath + " deleted", "function deletefile");
         }

      } else {
         if (alertMessage == true) {
            Application.current.window.alert("File : " + filePath + " not found", "function deletefile");
         }


      }
   }


   /*
   public static function deleteTxtFile(file:String, alertMessage:Bool):Void {
      var wayToDelete = file;

      if (sys.FileSystem.exists(wayToDelete)) {
         sys.FileSystem.deleteFile(wayToDelete);
         if (alertMessage == true) {
            Application.current.window.alert("File :" + fileName + " deleted sucessfully", "function deleteTxtfile");
         }
     
      } else {
         if (alertMessage == true) {
            Application.current.window.alert("File : " + fileName + " not found", "function deleteTxtfile");

         }
     
         
      }

   }
   */
   
      //trace(fullDeletePath);

} 

