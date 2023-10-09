package states;

import openfl.events.TextEvent;
import flixel.FlxG;
import flixel.FlxSprite as Spr;
import flixel.util.FlxColor as Color;
import flixel.text.FlxText as Text;
import flixel.text.FlxText.FlxTextBorderStyle;
import lime.app.Application;
import openfl.system.System;

import sys.FileSystem;
import sys.io.File;
using StringTools; 

class MusicState extends MusicBeatState {

    
    public var directories:Array<String> = [
        'mods/music',
    ];
    var txtDir:Text;
    var txtMusicSelect:Text;

    var musicListModsDisplay:Text;
    var pressedEnter:Bool = false;
    public var musicListMods:Array<String> = [];

    public var e:String = null;

    override function create() {
        Application.current.window.title = "Friday Night Funkin:' AshEngine - SoundPlayer";

        var daBg:Spr;

        daBg = new Spr().loadGraphic(Paths.image('menuBGBlue'));
        daBg.screenCenter();
        add(daBg);

        var info:Text = new Text(800, 0, 0, "", 20);
        info.font = "VCR OSD Mono";
        info.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        info.text = " SPACE - Resume or Pause sound\n ENTER - Play selected sound";
        add(info);

        txtDir = new Text(100,200,0, "", 25);
        txtDir.font = "VCR OSD Mono";
        txtDir.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        add(txtDir);
        txtMusicSelect = new Text(txtDir.x, txtDir.y + 80, 0, "", 25);
        txtMusicSelect.font = "VCR OSD Mono";
        txtMusicSelect.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        add(txtMusicSelect);

        var dir:String = directories[0];
        var dirFiles = FileSystem.readDirectory(dir);
        var filterDirFiles = dirFiles.filter(fileName -> fileName.endsWith(".ogg"));
            try {
                if (filterDirFiles.length != 0) {
                    for (e in filterDirFiles) {
                        trace("music files in mods/music : " + e);
                        musicListMods.push(e);
                    }
                }
    
                for (b in 0...musicListMods.length) {
                    musicListModsDisplay = new Text(txtDir.x + 400, 0, 0, "", 20);
                    musicListModsDisplay.font = "VCR OSD Mono";
                    musicListModsDisplay.text = musicListMods[b];
                    musicListModsDisplay.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
                    musicListModsDisplay.y = (b * 30) + txtDir.y;
                    musicListModsDisplay.visible = true;
                    add(musicListModsDisplay);
        
                }
            } catch(burh:Dynamic) {
                trace("No music files was found");
                musicListMods.push("No music files was found");
            } 

        super.create();
    }

    var paused:Bool = false;
    var pressed:Int = 0;
    var curSelected:Int = 0;
    var curOptionSelected:Int = 0;
    var curOption:Int = 0;
    override function update(elasped:Float) {
        var goback = FlxG.keys.justPressed.ESCAPE;

        txtDir.text = " Directory\n" + "<" + directories[curSelected] + ">";
        txtMusicSelect.text = "<" + musicListMods[curOptionSelected] + ">";

        switch(curOption) {
           case 0:
            txtDir.setBorderStyle(OUTLINE, Color.YELLOW, 1, 1);
            txtMusicSelect.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
            
           case 1:
            txtDir.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
            txtMusicSelect.setBorderStyle(OUTLINE, Color.YELLOW, 1, 1);
        }

        if(controls.UI_RIGHT_P) { //kill me
            funniSound();
            curSelected++;
        } else if (controls.UI_LEFT_P) {
            funniSound();
            curSelected--;
        } else if (controls.UI_UP_P) {
            funniSound();
            curOption++;
        } else if (controls.UI_DOWN_P) {
            funniSound();
            curOption--;
        }
        if(curOption < 0) {
            curOption = 1;
        } else if(curOption > 1) {
            curOption = 0;
        }
        if (curSelected < 0) {
            curSelected = 1;
        }
        if (curSelected > directories.length - 1) {
            curSelected = directories.length - 1;
        }

        if (curSelected == 0 && curOption == 1) {
            txtMusicSelect.visible = true;
            if (controls.UI_LEFT_P) {
                pressed = 0;
                curOptionSelected--;
                funniSound();
            } else if(controls.UI_RIGHT_P) {
                pressed = 0;
                curOptionSelected++;
                funniSound();
            }
            if (curOptionSelected < 0) {
                curOptionSelected = musicListMods.length - 1;
            } else if (curOptionSelected > musicListMods.length - 1) {
                curOptionSelected = 0;
            }
        }
        ////some sound systems (play/pause) or something
        if(FlxG.keys.justPressed.ENTER) {
            pressedEnter = true;
            if(curSelected == 0) {
                e = musicListMods[curOptionSelected];
            }
            var output:String = StringTools.replace(e, ".ogg", "");
            Application.current.window.title = "Friday Night Funkin': AshEngine - SoundPlayer: currently playing: " + output;

            FlxG.sound.playMusic(Paths.music(output), 0.7);
            
            trace("Playing :" + output);
            trace("pressed enter");
        }
        if(FlxG.keys.justPressed.SPACE && pressedEnter) {   //idk man i finally did it the stupid pause system fuck this shit    
            trace(pressed);
            pressed++;
            var output:String = StringTools.replace(e, ".ogg", "");
            if(pressed == 1) {
                FlxG.sound.pause();
                Application.current.window.title = "Friday Night Funkin': AshEngine - SoundPlayer: currently playing: " + output + " - PAUSED";
            }
            if (pressed == 2) {
                FlxG.sound.resume();
                Application.current.window.title = "Friday Night Funkin': AshEngine - SoundPlayer: currently playing: " + output;
            }
            if (pressed > 1) {
                pressed = 0;
            }
        }
        if (goback) {
            Application.current.window.title = "Friday Night Funkin': AshEngine";
            MusicBeatState.switchState(new MainMenuState());
            Paths.clearUnusedMemory();
        }
        super.update(elasped);
    }

    public function funniSound() {
        try {
            FlxG.sound.play(Paths.sound('scrollMenu'));
        } catch(e:Dynamic) {
            trace('burh sound missing');
        }
    }
    private function addDir(burj:String = null) {
        if (burj != null) {
            directories.push(burj);
        }
    }

}