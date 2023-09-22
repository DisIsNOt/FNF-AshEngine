package musicplayer;

import flixel.FlxG;
import flixel.FlxSprite as Spr;
import flixel.util.FlxColor as Color;
import flixel.text.FlxText as Text;
import flixel.math.FlxMath;
import lime.app.Application;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIInputText;

import sys.FileSystem;
import sys.io.File;
using StringTools; 

class MusicState extends MusicBeatState {

    public var musicListMain:Array<String> = [];
    var txtField:FlxUIInputText;
    var txtFieldVisible:Bool = false;
    var musicListTextDisplay:Text;

    override function create() {

        var daBg:Spr;

        daBg = new Spr().loadGraphic(Paths.image('menuBGBlue'));
        daBg.screenCenter();
        add(daBg);

        txtField = new FlxUIInputText(200, 200, 400, "Input", 19, Color.BLACK, Color.WHITE, true);
        txtField.resize(400, 100);
        add(txtField);
        
        listOutAllMusic();
        
        super.create();
    }

    override function update(elasped:Float) {
        var goback = FlxG.keys.justPressed.ESCAPE;
        var enter = FlxG.keys.justPressed.ENTER;
        var keyE = FlxG.keys.justPressed.E;
        txtField.visible = txtFieldVisible;
        if(txtFieldVisible == false) txtFieldVisible = false;
            
        if (goback) {
            MusicBeatState.switchState(new MainMenuState());
        }

        if(enter && txtFieldVisible == true) {
            checkCommand();
        } 

        if (keyE && txtFieldVisible == false) {
            txtFieldVisible = true;
        }
        
        super.update(elasped);
    }

    function checkCommand() {
        if (txtField.text != null) {
            switch(txtField.text) {
                case 'musiclist.open':
                    txtFieldVisible = false;
                    openSubState(new MusicList());
                case 'cmd.close':
                    txtFieldVisible = false;
            }
        }
    }

    public function listOutAllMusic() {
        var dir = "mods/music";
        var dirFiles = FileSystem.readDirectory(dir);
        var filterDirFiles = dirFiles.filter(fileName -> fileName.endsWith(".ogg"));

        if(filterDirFiles.length != 0) {
            for (i in filterDirFiles) {
                trace("Files: " + i);
                musicListMain.push(i);
            }

            for (i in 0...musicListMain.length) {
                musicListTextDisplay = new Text(0, 0, 0, "", 20);
                musicListTextDisplay.font = "VCR OSD Mono";
                musicListTextDisplay.text = musicListMain[i];
                musicListTextDisplay.setBorderStyle(OUTLINE, Color.BLACK, 1, 1);
                add(musicListTextDisplay);

                musicListTextDisplay.y = (i * 30) + 50;
                

            }
        } else {
            trace("No ogg files in dir");
            musicListMain.push("No ogg files in dir");
        }
    }



}