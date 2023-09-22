local playereffect = true
local sicksonly = false

local dadeffect = false
-- wor
local offsets = {
  [0] = {15.5, 14.75},
  [1] = {16, 19.75},
  [2] = {15.5, 14.75},
  [3] = {15.5, 14.75},
}
local playtag = {}
local oppotag = {}
function goodNoteHit(id, dir, type, sus)
    local rating = (not sicksonly) and 'sick' or getPropertyFromGroup('notes', id, 'rating')
 if not sus and playereffect and rating == 'sick' then  
    playtag[dir+1] = makeStrumAsset(dir, function (t, d, x, y, s)
    weird(t, d, 'playerStrums') 
   end, type..dir)
 end
end
function opponentNoteHit(id, data, type, sus)
if not sus then
    if dadeffect then
      oppotag[data+1] = makeStrumAsset(data, function (t, d, x, y, s)
     weird(t, d, 'opponentStrums') 
    end, id..data)
end
end
 function onTimerCompleted(t) for i,v in pairs(playtag) do if t == v..'b' then doTweenAlpha('strum'..v..'a', v, 0, 0.5, 'quadOut') removeLuaSprite(v, false) addLuaSprite(v, true) end end  for i,v in pairs(oppotag) do if t == v..'b' then doTweenAlpha('strum'..v..'a', v, 0, 0.5, 'quadOut') removeLuaSprite(v, false) addLuaSprite(v, true) end end end
function makeStrumAsset(dir, custom, tag, x, y)
 local animTable = { [0] = 'Left', [1] = 'Down', [2] = 'Up', [3] = 'Right'}
 local colorTable = { [0] = 'Purple', [1] = 'Blue', [2] = 'Green', [3] = 'Red'}
 local tag = tag or 'strum'..animTable[dir]
 local skin = getPropertyFromGroup('playerStrums', dir, 'texture') or 'NOTE_assets'
 local x = x or getPropertyFromGroup('playerStrums', dir, 'x')
 local y = y or getPropertyFromGroup('playerStrums', dir, 'y')
 local anims = {
    {name = 'static', prefix = 'arrow'..animTable[dir]:upper()},
    {name = 'pressed', prefix = animTable[dir]:lower()..' press'},
    {name = 'confirm', prefix = animTable[dir]:lower()..' confirm'},
    {name = 'note', prefix = colorTable[dir]:lower()},
 }
 makeAnimatedLuaSprite(tag, skin, x, y)
 for i = 1,#anims do addAnimationByPrefix(tag, anims[i]['name'], anims[i]['prefix'], 24, false)end
 setObjectOrder(tag, getObjectOrder(tag) or getObjectOrder('boyfriendGroup'))
 addLuaSprite(tag, false)
 if custom then custom(tag, dir, x, y, skin) end
 return tag
end
function weird(to, dop, w)
  scaleObject(to, 0.7, 0.7)
  updateHitbox(to)
  setProperty(to..'.x', getPropertyFromGroup(w, dop, 'x'))
  setProperty(to..'.alpha', getPropertyFromGroup(w, dop, 'alpha'))
  setProperty(to..'.y', getPropertyFromGroup(w, dop, 'y'))
  local scalex = getProperty(to..'.scale.x')
  local scaley = getProperty(to..'.scale.y')
  setProperty(to..'.offset.x',  (getPropertyFromGroup(w, dop, 'offset.x') + offsets[dop][1]) * scalex)
  setProperty(to..'.offset.y',  (getPropertyFromGroup(w, dop, 'offset.y') + offsets[dop][2]) * scaley)
  setBlendMode(to, 'ADD') 
  setObjectCamera(to, 'hud') 
  playAnim(to, 'confirm') 
  doTweenX(to..'aaa', to..'.scale', 0.85, 0.5, 'quadOut')
  doTweenY(to..'bbb', to..'.scale', 0.85, 0.5, 'quadOut')
  runTimer(to..'b', 0.15) 
 end
end
-- Made by Daniel (skry#4271)
