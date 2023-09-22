package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import openfl.display.Sprite;

import sys.FileSystem;
import sys.io.File;

import lime.app.Application as App;

using StringTools;

class Detector {
    public function new() {
    }
    //CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin'); load browser;
    public function getCurrentClass() {
        return Type.getClass(FlxG.state);
    }

    public function checkAllForCode(path:String, lineToFind:String, ?throwError:Bool = false, ?errorMessage:String, ?closeGame:Bool = false) {
        var dir = path; //example: mods/scripts
        var file = FileSystem.readDirectory(dir);
        var scripts = file.filter(fileName -> fileName.endsWith(".lua"));


        if(FileSystem.exists(dir)) {
            if (scripts.length != 0) {
                for (i in scripts) {
                    var scriptPath = dir + "/" + i;
                    var ioutput = File.getContent(scriptPath).toString();
                    var output = StringTools.replace(ioutput, " ", "");
        
        
                    if (output.indexOf(lineToFind) != -1) {
                        trace("Code Line " + lineToFind + " found in : " + i);
                        if(throwError == true) {
                            App.current.window.alert(errorMessage + " in: " + i, "AshEngine Cheat Detection"); 
                        }
                        if(closeGame) {
                            Sys.exit(1);
                        }
                    } else {
                        trace("Did't find the specified code line in any lua file");
                    }
                
                }
            } else {
                trace("No lua script found");
            }
        } else {
            trace("The directory you specified doesn't exists");
        }

    }

    public function checkActiveScripts(dir:String) {
        var directory = dir;
        var foundedFiles = null;
       

        if (FileSystem.exists(directory)) {
           var daFile = FileSystem.readDirectory(directory);
           foundedFiles = daFile.filter(fileName -> fileName.endsWith(".lua"));
        } else {
            var daFile = [];
            foundedFiles = [];
            trace('directory doens\'t exists');
        }

        if (foundedFiles.length != 0) {
            for (i in foundedFiles)  {
                trace("Found lua scipt: " + i + " in " + directory);
            }
        } else {
            trace("No lua scirpt found in " + directory);
        }      
    }


    /*
    public function checkOneForCode(scriptName:String, lineToFind:String, ?throwError:Bool = false) {
        var directoryPathThing = "mods/scripts/" + scriptName;
                var outputThing = File.getContent(directoryPathThing).toString();
                var output = StringTools.replace(outputThing, " ", ""); 
                //trace(output); //output for that certain lua file;

                
                if (output.indexOf(lineToFind) != -1 || output.indexOf(lineToFind) != -1) {

                    trace('found sus code');
                } else {
                    trace('nothing here');
                }

    }
    */

    
}




