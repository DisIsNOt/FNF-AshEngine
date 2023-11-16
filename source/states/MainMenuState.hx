package states;

import backend.WeekData;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;
import flixel.util.FlxSave;

import states.editors.MasterEditorMenu;
import options.OptionsState;
import flixel.ui.FlxButton;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.1B'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	var soundTest:FlxButton;	
	var canPress:Bool = true;
	var canSelect:Bool = true;

	var menuControlType:String = 'mouse';


	var shit2:FlxText;
	var shit3:FlxText;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		//#if !switch 'donate', #end
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		loadShit();
		saveShit();
		Application.current.window.title = "Friday Night Funkin': AshEngine";
		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		soundTest = new FlxButton(100, 0, "Sound Tester", musicButtonClicked);
		add(soundTest);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
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
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		FlxG.camera.follow(camFollow, null, 0);
		FlxG.mouse.visible = true;

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "AshEngine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('cronos.otf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('cronos.otf'), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		shit2 = new FlxText(985, FlxG.height - 24,  0, "Press CTRL to switch control type", 12);
		shit2.scrollFactor.set();
		shit2.setFormat(Paths.font('cronos.otf'), 22, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(shit2);
		shit3 = new FlxText(1002, FlxG.height - 44, 0, "Current Control Type: " + menuControlType, 12);
		shit3.scrollFactor.set();
		shit3.setFormat(Paths.font('cronos.otf'), 22, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(shit3);



		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;
	var e:Int = 0;
	var sel:Int = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		FlxG.camera.followLerp = FlxMath.bound(elapsed * 9 / (FlxG.updateFramerate / 60), 0, 1);

		if(FlxG.keys.justPressed.CONTROL) {
			sel++;

			menuItems.forEach(function(spr:FlxSprite){
				if (spr.ID == curSelected) {
					spr.animation.play('selected');
					var addB:Float = 0;
					if(menuItems.length > 4) {
						addB = menuItems.length * 8;
					}
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - addB);
					spr.centerOffsets();
				}
			}); 
		}

		if(sel == 1) {
			FlxG.mouse.enabled = false;
			menuControlType = 'keyboard';
			saveShit();
			shit3.text = "Current Control Type: " + menuControlType;
		}
		if (sel > 1) {
			FlxG.mouse.enabled = true;
			menuControlType = 'mouse';
			saveShit();
			shit3.text = "Current Control Type: " + menuControlType;
			sel = 0;
		}

		menuItems.forEach(function(spr:FlxSprite) {
			if(FlxG.mouse.overlaps(spr) && menuControlType == 'mouse' && canSelect) {
				curSelected = spr.ID;
				
				if(spr.ID == curSelected) {
					spr.animation.play('selected');
					var add:Float = 0;
					if(menuItems.length > 4) {
						add = menuItems.length * 8;
					}
					camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
					spr.centerOffsets();
				} 
				if(e != curSelected) {
					FlxG.sound.play(Paths.sound('scrollMenu'));
					e = curSelected;
				}

				if(FlxG.mouse.justPressed && canPress) {
					spr.animation.play('selected');
					canPress = false;
					canSelect = false;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(f:FlxFlicker){
						var choice:String = optionShit[curSelected];

						switch(choice) {
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							case 'awards':
								MusicBeatState.switchState(new AchievementsMenuState());
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								LoadingState.loadAndSwitchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
								}
						}
					});

				}
			} else {
				if(menuControlType == 'mouse') {
					spr.animation.play('idle');
					spr.centerOffsets();
				}
			}

		});
		
		if (controls.BACK)
		{
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new TitleState());
		}
		if (!selectedSomethin && menuControlType == 'keyboard')
		{
			if (controls.UI_UP_P) {
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}


			if (controls.ACCEPT)
			{
				canPress = false;
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if(ClientPrefs.data.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										LoadingState.loadAndSwitchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new OptionsState());
										OptionsState.onPlayState = false;
										if (PlayState.SONG != null)
										{
											PlayState.SONG.arrowSkin = null;
											PlayState.SONG.splashSkin = null;
										}
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (controls.justPressed('debug_1'))
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

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	function musicButtonClicked() {
		if(canPress) {
			MusicBeatState.switchState(new states.MusicState());
			FlxFlicker.flicker(soundTest, 1, 0.06);
			FlxG.sound.play(Paths.sound("confirmMenu"));
		}
	}

	function saveShit() {
		FlxG.save.data.menuControlType = menuControlType;
		FlxG.save.data.sel = sel;

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('AshEngine_others', 'AshEngine');
		save.data.others = 3; //idk this doens't do anything
		save.flush();
	}

	function loadShit() {
		if(FlxG.save.data.menuControlType != null) {
			menuControlType = FlxG.save.data.menuControlType;
		}
		if(FlxG.save.data.sel != null) {
			sel = FlxG.save.data.sel;
		}

		var save:FlxSave = new FlxSave();
		save.bind('AshEngine_others', 'AshEngine');

	}
}
