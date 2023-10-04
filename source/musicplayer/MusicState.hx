package musicplayer;

import flixel.FlxG;
import flixel.FlxSprite as Spr;
import flixel.util.FlxColor as Color;
import flixel.text.FlxText as Text;
import lime.app.Application;
import openfl.system.System;

import sys.FileSystem;
import sys.io.File;
using StringTools; 

class MusicState extends MusicBeatState {

    
    public var directories:Array<String> = [
        'mods/music',
        'assets/shared/music'
    ];
    var txtDir:Text;
    var txtMusicSelect:Text;
    var txtMusicSelect2:Text;

    var musicListModsDisplay:Text;
    var musicListAssetsDisplay:Text;
    var pressedEnter:Bool = false;
    public var musicListMods:Array<String> = [];
    public var musicListAssets:Array<String> = [];


    override function create() {

        var daBg:Spr;
        musicList(false, true, 1);
        musicList(false, true, 2);

        daBg = new Spr().loadGraphic(Paths.image('menuBGBlue'));
        daBg.screenCenter();
        add(daBg);

        txtDir = new Text(200,200,0, "", 25);
        txtDir.font = "VCR OSD Mono";
        txtDir.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        add(txtDir);
        txtMusicSelect = new Text(txtDir.x, txtDir.y + 80, 0, "", 25);
        txtMusicSelect.font = "VCR OSD Mono";
        txtMusicSelect.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        add(txtMusicSelect);
        txtMusicSelect2 = new Text(txtDir.x, txtDir.y + 80, 0, "", 25);
        txtMusicSelect2.font = "VCR OSD Mono";
        txtMusicSelect2.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
        add(txtMusicSelect2);

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
        txtMusicSelect2.text = "<" + musicListAssets[curOptionSelected] + ">";

        switch(curOption) {
           case 0:
            txtDir.setBorderStyle(OUTLINE, Color.YELLOW, 1, 1);
            txtMusicSelect.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
            txtMusicSelect2.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
            
           case 1:
            txtDir.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
            txtMusicSelect.setBorderStyle(OUTLINE, Color.YELLOW, 1, 1);
            txtMusicSelect2.setBorderStyle(OUTLINE, Color.YELLOW, 1, 1);
        }

        if(controls.UI_RIGHT_P && curOption == 0) { //kill me
            funniSound();
            curSelected++;
        } else if (controls.UI_LEFT_P && curOption == 0) {
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
            curSelected = directories.length - 2;
        }

        if (curSelected == 0) {
            txtMusicSelect.visible = true;
            txtMusicSelect2.visible = false;
            if (controls.UI_LEFT_P) {
                pressed = 0;
                pressedEnter = false;
                curOptionSelected--;
                FlxG.sound.destroy(true);
                funniSound();
            } else if(controls.UI_RIGHT_P) {
                pressedEnter = false;
                pressed = 0;
                FlxG.sound.destroy(true);
                curOptionSelected++;
                funniSound();
            }
            if (curOptionSelected < 0) {
                curOptionSelected = musicListMods.length - 1;
            } else if (curOptionSelected > musicListMods.length - 1) {
                curOptionSelected = 0;
            }
        }
        if (curSelected == 1) {
            txtMusicSelect.visible = false;
            txtMusicSelect2.visible = true;
            if (controls.UI_LEFT_P) {
                pressed = 0;
                pressedEnter = false;
                curOptionSelected--;
                FlxG.sound.destroy(true);
                funniSound();
            } else if(controls.UI_RIGHT_P) {
                pressed = 0;
                pressedEnter = false;
                curOptionSelected++;
                FlxG.sound.destroy(true);
                funniSound();
            }
            if (curOptionSelected < 0) {
                curOptionSelected = musicListAssets.length - 1;
            } else if (curOptionSelected > musicListAssets.length - 1) {
                curOptionSelected = 0;
            }
        }

        ////some sound systems (play/pause) or something
        if (curSelected == 0) {
            if(FlxG.keys.justPressed.ENTER) {
                pressedEnter = true;
                var e:String = musicListMods[curOptionSelected];
                var output:String = StringTools.replace(e, ".ogg", "");
    
                trace(musicListMods[curOptionSelected]);
                FlxG.sound.playMusic(Paths.music(output), 0.7);
                trace("pressed enter");
            
            }
    
            if(FlxG.keys.justPressed.SPACE && pressedEnter) {   //idk man i finally did it the stupid pause system fuck this shit    
                trace(pressed);
                pressed++;
                if(pressed == 1) {
                    FlxG.sound.pause();
                }
                if (pressed == 2) {
                    FlxG.sound.resume();
                }
                if (pressed > 1) {
                    pressed = 0;
                }
            }
        }

        
        if (goback) {
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

    public function musicList(?show:Bool, ?push:Bool, ?pushDir:Int) {
        var dir:String = "mods/music";
        var dirFiles = FileSystem.readDirectory(dir);
        var filterDirFiles = dirFiles.filter(fileName -> fileName.endsWith(".ogg"));
        var dir2:String = "assets/shared/music";
        var dirFiles2 = FileSystem.readDirectory(dir2);
        var filterDirFiles2 = dirFiles2.filter(fileName -> fileName.endsWith(".ogg"));
        if (push) {
            if (filterDirFiles2.length != 0 && pushDir == 1) {
                for (burh in filterDirFiles2) {
                    trace("music files in asstes/shared/music: " + burh);
                    musicListAssets.push(burh);
                }
            }

            if (filterDirFiles.length != 0 && pushDir == 2) {
                for (e in filterDirFiles) {
                    trace("music files in mods/music : " + e);
                    musicListMods.push(e);
                }
            }
        }
        if (show) {
            try {
                if (filterDirFiles2.length != 0) {
                    for (burh in filterDirFiles2) {
                        trace("music files in asstes/shared/music: " + burh);
                        musicListAssets.push(burh);
                    }
                }
    
                if (filterDirFiles.length != 0) {
                    for (e in filterDirFiles) {
                        trace("music files in mods/music : " + e);
                        musicListMods.push(e);
                    }
                }
    
                for (b in 0...musicListMods.length) {
                    musicListModsDisplay = new Text(0, 0, 0, "", 20);
                    musicListModsDisplay.font = "VCR OSD Mono";
                    musicListModsDisplay.text = musicListMods[b];
                    musicListModsDisplay.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
                    musicListModsDisplay.y = (b * 30) + 50;
                    musicListModsDisplay.visible = true;
                    add(musicListModsDisplay);
        
                }
                for (a in 0...musicListAssets.length) {
                    musicListAssetsDisplay = new Text(musicListModsDisplay.x + 650, musicListModsDisplay.y, 0, "", 20);
                    musicListAssetsDisplay.font = "VCR OSD Mono";
                    musicListAssetsDisplay.text = musicListAssets[a];
                    musicListAssetsDisplay.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
                    musicListAssetsDisplay.y = (a * 30) + 50;
                    musicListAssetsDisplay.visible = true;
                    add(musicListAssetsDisplay);
        
                }
        
            } catch(burh:Dynamic) {
                trace("No music files was found");
                musicListMods.push("No music files was found");
            } 

        }
    }
}