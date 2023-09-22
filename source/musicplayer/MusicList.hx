package musicplayer;

import flixel.FlxG;
import flixel.text.FlxText as Text;
import flixel.FlxSprite as Spr;
import flixel.FlxState;
import flixel.util.FlxColor as Color;
import flixel.FlxSubState;
import sys.FileSystem;
import sys.io.File;
import lime.app.Application as App;


using StringTools;

class MusicList extends MusicBeatSubstate {
    var detector:Detector = new Detector();
    var selectLeft:Alphabet;
    var selectRight:Alphabet;

    var musicList:Array<String> = ["Music Available :"];

    var musicListDisplay:Text;

    var blackBG:Spr;

    override function create() {
        //selectLeft = new Alphabet(20, 20, '>', true);
        //add(selectLeft);

        blackBG = new Spr().makeGraphic(1980, 780, Color.BLACK);
        blackBG.alpha = 0.35;
        add(blackBG);

        readMusicDir();


        super.create();
    }

    override function update(elasped:Float) {
        var enter = FlxG.keys.justPressed.ENTER;
        var back = FlxG.keys.justPressed.ESCAPE;

        if(back) {
            close(); // close the substate
        }

        super.update(elasped);
    }


    public function readMusicDir() {
        var dir = "mods/music";
        var readDir = FileSystem.readDirectory(dir);
        var files = readDir.filter(fileName -> fileName.endsWith(".ogg"));

        if (files.length != 0) {
            for (i in files) {
                trace("Music File found in mods/music : " + i);
                musicList.push(i);

            }

            for(i in 0...musicList.length) {

                musicListDisplay = new Text(0, 0, 0, '', 20);
                musicListDisplay.font = 'VCR OSD Mono';
                musicListDisplay.text = musicList[i];
                musicListDisplay.y = (i * 20) + 60;
                add(musicListDisplay);

                trace(musicList[i]);
            }
        } else {
            trace("nothing was in directory");
        }

    }
    
}