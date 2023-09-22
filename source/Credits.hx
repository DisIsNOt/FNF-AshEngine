package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import openfl.system.System;

import sys.FileSystem;

import flixel.group.FlxGroup.FlxTypedGroup;

class Credits extends MusicBeatState {
    private var ashEngineTeam:FlxTypedGroup<FlxSprite>;  

    private var selectors:FlxTypedGroup<FlxSprite>;
    var selectorRight:Alphabet;

   var bg:FlxSprite;
   final bgArr:Array<String> = [
        'menuBG',
        'menuBGBlue',
        'menuBGMagenta'
    ];

    var creditsOption1:Array<String> = [
        "creditsAsh",
        "creditsTop"
    ];
    var credItems1:FlxSprite;
    var creditsTitleText:Alphabet;
    var name1:FlxText;
    var description1:FlxText;
    var descriptionBg:FlxSprite;

    var curSelected:Int = 0;

    override function create() {
        System.gc();
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

        FlxG.mouse.visible = true;
        FlxG.mouse.useSystemCursor = true;
        var randomInt:Int = FlxG.random.int(0, bgArr.length -1);
        var foo:String = bgArr[randomInt];
        bg = new FlxSprite().loadGraphic(Paths.image(foo));
        bg.setGraphicSize(Std.int(bg.width * 1.1));
        selectorRight = new Alphabet(0,0, ">", true);
        descriptionBg = new FlxSprite(0, 650).makeGraphic(FlxG.width, 90, FlxColor.BLACK);
        descriptionBg.alpha = 0.5;
        creditsTitleText = new Alphabet(0, 30, "", true);
        creditsTitleText.changeX = false;
        add(bg);
        add(selectorRight);
        add(creditsTitleText);
        addDaTeam();

        super.create();
    }


    var poop:Int = -1;

    override function update(elapsed:Float) { 
        if (controls.BACK) {
            MusicBeatState.switchState(new MainMenuState());
        }

        if (controls.UI_RIGHT_P) {
            openSubState(new CreditsSubstate());
        }

        selectorRight.x = creditsTitleText.x + creditsTitleText.width + 35;
        selectorRight.y = creditsTitleText.y;

        ashEngineTeam.forEach(function(spr:FlxSprite) { //page1
            var dur:Float = 0.09;
            var page1Names:Array<Array<String>> = [
                ['Ashmostly', 'Main Programmer of AshEngine'],
                ['TopL', 'Main Supporter of AshEngine']
            ];

            if (FlxG.mouse.overlaps(spr)) {
                curSelected = spr.ID;

                FlxTween.tween(spr.scale, {x:1,y:1}, dur, {ease: FlxEase.cubeIn});

                if (poop != curSelected) {
                    FlxG.sound.play(Paths.sound('scrollMenu'));
                    poop = curSelected;
                }
                
                if (spr.ID == curSelected) {
                    name1.text = page1Names[curSelected][0];
                    description1.text = page1Names[curSelected][1];
                    name1.x = descriptionBg.x;
                    name1.y = descriptionBg.y;
                    name1.visible = true;
                    description1.visible = true;
                    description1.x = descriptionBg.x;
                    description1.y = name1.y + 30;

                    name1.font = Paths.font('cronos.otf');
                    description1.font = Paths.font('cronos.otf');
                    
                    
                    name1.screenCenter(X);
                    description1.screenCenter(X);
                } 

            } else {
                FlxTween.tween(spr.scale, {x: 0.9, y:0.9}, dur, {ease: FlxEase.cubeInOut});
            }
            //////
        });

        super.update(elapsed);
    }

    public function addDaTeam() {
        creditsTitleText.text = 'AshEngine Team';
        ashEngineTeam = new FlxTypedGroup<FlxSprite>();
        add(ashEngineTeam);

        FlxG.sound.playMusic(Paths.music('ori_and_will_of_the_wisps'), 0.9);

        for (i in 0...creditsOption1.length) {
            credItems1 = new FlxSprite((i * 600) + 50, 120).loadGraphic(Paths.image('credits/' + creditsOption1[i]));
            credItems1.scale.set(0.9, 0.9);
            credItems1.ID = i;
            ashEngineTeam.add(credItems1);

        }
        add(descriptionBg);
        name1 = new FlxText(0, 20, 0, "", 34);
        name1.setFormat(Paths.font('vcr.ttf'), 34, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(name1);
        description1 = new FlxText(0,50,0, "", 34);
        description1.setFormat(Paths.font('vcr.ttf'), 34, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(description1);

        creditsTitleText.screenCenter(X);
    }
}