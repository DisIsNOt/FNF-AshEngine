function opponentNoteHit()
 
  
 
 


end

function onBeatHit()
   triggerEvent('Chromatic Aberration', 0.008, 11);

end


function onUpdate(elapsed)

end
--[=[]
   x = 600;
   y = 720;
function onCreate()
 
 
   makeAnimatedLuaSprite('iconWuggy', 'iconHuggyWuggy', 0,0);
   addAnimationByPrefix('iconWuggy', 'neutral', 'neutral', 24, false);
   addAnimationByPrefix('iconWuggy', 'lose', 'lose', 24, false);
   --objectPlayAnimation('iconWuggy','neutral');
   setObjectCamera('iconWuggy', 'hud')
   scaleObject('iconWuggy', 0.7 ,0.7)
   addLuaSprite('iconWuggy', true)



  




end

function onUpdate()
   xx = getProperty('iconP2.x')
   yy = getProperty('iconP2.y')
   debugPrint(xx,yy)



   if getProperty('healthBar.percent') > 80 then
      setProperty('iconWuggy.x', xx - 34)
       setProperty('iconWuggy.y', yy - 10)
      objectPlayAnimation('iconWuggy','lose');
      
   else
      setProperty('iconWuggy.x', xx - 54)
      setProperty('iconWuggy.y', yy - 30)
      objectPlayAnimation('iconWuggy','neutral');


   end
      


   offsetEditor = 'off';



  if offsetEditor == 'on' then
  shift = getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT');
  up = getPropertyFromClass('flixel.FlxG', 'keys.pressed.UP')
  down = getPropertyFromClass('flixel.FlxG', 'keys.pressed.DOWN')
  left = getPropertyFromClass('flixel.FlxG', 'keys.pressed.LEFT')
  right = getPropertyFromClass('flixel.FlxG', 'keys.pressed.RIGHT')  --damn this shit is crazy holy moly



  if down then
  y = y + 1;
  end
  if down and shift then
     y = y + 5;
  end
  if up then
     y = y - 1;
  end
  if up and shift then
     y = y - 5;
  end
  if left then
     x = x - 1;
  end
  if left and shift then
     x = x - 5;
  end
  if right then
     x = x + 1;
  end 
  if right and shift then
     x = x + 5;
  end
  debugPrint('X:'..x, 'Y:'..y);

  end
  

end
--[=[

function onUpdate()
   --]=]
   --[=[





   
  


--



end
--]=]
