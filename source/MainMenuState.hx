package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxTimer;

import flixel.ui.FlxButton;
import openfl.system.System;

import lime.app.Application;
using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3A'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	private var musicPlayerButton:FlxButton;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public var pressedBack:Bool = false;


	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var canPress:Bool = true;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);


		musicPlayerButton = new FlxButton(100,0, 'Music Player', musicButtonClicked);
		add(musicPlayerButton);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "AshEngine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

 
	var selectedSomethin:Bool = false;
	var chance:Int = 0;
	var canMousePress:Bool = true;
	var canMouseSelect:Bool = true;
	var soundPlayed:Int = -1;
	
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (controls.BACK && pressedBack == false) {
			MusicBeatState.switchState(new TitleState());
			pressedBack = true;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		menuItems.forEach(function(sprite:FlxSprite){
			sprite.centerOffsets();
	
			if (sprite.ID != curSelected) {
				sprite.animation.play('idle');
			}

			if (FlxG.mouse.overlaps(sprite)) {
				if (canMouseSelect) {
					var add:Float = 0;
					curSelected = sprite.ID;
	
					if(menuItems.length > 4) {
						add = menuItems.length * 8;
					}
	
					if (sprite.ID == curSelected) {
						sprite.animation.play('selected');
					}

					if (soundPlayed != curSelected) {
						FlxG.sound.play(Paths.sound('scrollMenu'));
						soundPlayed = curSelected; 
					}
					
					camFollow.setPosition(sprite.getGraphicMidpoint().x, sprite.getGraphicMidpoint().y - add);
					if(FlxG.mouse.justPressed && canMousePress) {
						FlxG.sound.play(Paths.sound('confirmMenu'));
						FlxG.mouse.visible = false;
						canMousePress = false;
						canMouseSelect = false;
	
						FlxFlicker.flicker(sprite, 1, 0.06, false, false, function(flk:FlxFlicker){
							var currentlySelecting:String = optionShit[curSelected];
	
							switch(currentlySelecting) {
								case 'story_mode':
									MusicBeatState.switchState(new StoryMenuState());
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'mods':
									MusicBeatState.switchState(new ModsMenuState());
								case 'awards':
									MusicBeatState.switchState(new AchievementState());
								case 'credits':
									MusicBeatState.switchState(new Credits());
								case 'options':
									MusicBeatState.switchState(new options.OptionsState());
							}
						});
                    }
			    }


			}
		});
		#if desktop
		if (FlxG.keys.anyJustPressed(debugKeys))
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end
		
		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	private function musicButtonClicked() {
		if (canPress){
			canPress = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxFlicker.flicker(musicPlayerButton, 1, 0.05, true, false);
	
			var daTimer:FlxTimer = new FlxTimer().start(0.8, function(tmr:FlxTimer){
	
				MusicBeatState.switchState(new musicplayer.MusicState());
	
			});
		}
	}
}
