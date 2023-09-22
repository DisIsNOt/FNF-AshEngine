---@funkinScript
local on = false;

local characters = {
    dad = {
      ['ash'] = {
        x = 0,
        y = 558,
        ['danceLeft'] = {0, 0},
        ['danceRight'] = {0, 0},
        ['singLEFT'] = {-105, -10},
        ['singDOWN'] = {-121, 51},
        ['singUP'] = {-134, -22},
        ['singRIGHT'] = {-148, 22},
      },

      ['dad'] = {
        x = 0,
        y = 740,
        ['danceLeft'] = {0, 0},
        ['danceRight'] = {0, 0},
        ['singLEFT'] = {-55, -10},
        ['singDOWN'] = {-51, 51},
        ['singUP'] = {-54, -22},
        ['singRIGHT'] = {-58, 22},
      },
    },
    bf = {
      ['bf'] = {
        x = 770,
        y = 125,
        ['idle'] = {-5, -10},
        ['singLEFT'] = {5, -10},
        ['singLEFTmiss'] = {7, -10},
        ['singDOWN'] = {-20, -10},
        ['singDOWNmiss'] = {-17, -10},
        ['singUP'] = {-45, -10},
        ['singUPmiss'] = {-45, -10},
        ['singRIGHT'] = {-47, -10},
        ['singRIGHTmiss'] = {-44, -10},
        ['hey'] = {-3, -10},
        ['hurt'] = {13, -10},
        ['scared'] = {-4, -10},
        ['dodge'] = {-10, -10},
        ['attack'] = {295, -10},
        ['pre-attack'] = {-40, -10},
      },
      ['bf-dark'] = {
        x = 0,
        y = 325,
        ['idle'] = {-5, -10},
        ['singLEFT'] = {5, -10},
        ['singLEFTmiss'] = {7, -10},
        ['singDOWN'] = {-20, -10},
        ['singDOWNmiss'] = {-17, -10},
        ['singUP'] = {-45, -10},
        ['singUPmiss'] = {-45, -10},
        ['singRIGHT'] = {-47, -10},
        ['singRIGHTmiss'] = {-44, -10},
        ['hey'] = {-3, -10},
        ['hurt'] = {13, -10},
        ['scared'] = {-4, -10},
        ['dodge'] = {-10, -10},
        ['attack'] = {295, -10},
        ['pre-attack'] = {-40, -10},
      },
    },
    gf = {
      ['gf'] = {
        x = 0,
        y = 625,
      },
      ['gf-dark'] = {
        x = 0,
        y = 625,
      },
    },
  }
  
  function getReflectProp(name, property)
    local name = tostring(name):upper() or 'BOYFRIEND'
    local property = tostring(property) or 'name'
    return runHaxeCode([[return reflect]]..name..[[.animation.curAnim.]]..property..[[]]);
  end
  
  function setReflectPOS(name, x, y)
    local name = tostring(name):upper() or 'BOYFRIEND'
    local x = tonumber(x) or 0
    local y = tonumber(y) or x
    runHaxeCode([[reflect]]..name..[[.offset.set(]]..x..[[, ]]..y..[[)]]);
  end
  
  function getReflectPOS(name)
    local name = tostring(name):upper() or 'BOYFRIEND'
    return {runHaxeCode([[return reflect]]..name..[[.offset.x]]), runHaxeCode([[return reflect]]..name..[[.offset.y]])};
  end
  
  function onCreatePost()
    if on then

    runHaxeCode([[
      reflectGF = new Character(
        game.gf.x + ]]..(characters.gf[gfName].x)..[[,
        game.gf.y + ]]..(characters.gf[gfName].y)..[[,
        ']]..(gfName)..[['
      );
      reflectDAD = new Character(
        game.dad.x + ]]..(characters.dad[dadName].x)..[[,
        game.dad.y + ]]..(characters.dad[dadName].y)..[[,
        ']]..(dadName)..[['
      );
      reflectBOYFRIEND = new Boyfriend(
        game.boyfriend.x + ]]..(characters.bf[boyfriendName].x)..[[,
        game.boyfriend.y + ]]..(characters.bf[boyfriendName].y)..[[,
        ']]..(boyfriendName)..[['
      );
      for (reflect in [reflectGF, reflectDAD, reflectBOYFRIEND]) {
        reflect.alpha = 0.25;
        reflect.flipY = true;
        for (char in [game.addBehindGF, game.addBehindDad, game.addBehindBF]) {char(reflect);}
      }
    ]]);
    end
  end
  
  function onUpdatePost(elapsed)
    if on then
    for index, chars in pairs({'gf', 'dad', 'boyfriend'}) do
      runHaxeCode([[
        reflect]]..(chars:upper())..[[.animation.copyFrom(game.]]..(chars)..[[.animation);
        reflect]]..(chars:upper())..[[.animation.curAnim.curFrame = game.]]..(chars)..[[.animation.curAnim.curFrame;
        reflect]]..(chars:upper())..[[.visible = game.]]..(chars)..[[.visible;
        reflect]]..(chars:upper())..[[.color = game.]]..(chars)..[[.color;
      ]]);
    end
    setReflectPOS('dad', characters.dad[dadName][getReflectProp('dad', 'name')][1], characters.dad[dadName][getReflectProp('dad', 'name')][2]);
    setReflectPOS('boyfriend', characters.bf[boyfriendName][getReflectProp('boyfriend', 'name')][1], characters.bf[boyfriendName][getReflectProp('boyfriend', 'name')][2]);
end
  end
  
  function onEvent(eventName, value1, value2)
    if eventName:find('Change Character') then
      local value1 = tostring(value1):lower() or 'dad'
      if value1:find('dad') or value1:find('0') then
        runHaxeCode([[
          game.remove(reflectDAD);
          reflectDAD = new Character(
            game.dad.x + ]]..(characters.dad[dadName].x)..[[,
            game.dad.y + ]]..(characters.dad[dadName].y)..[[,
            ']]..(dadName)..[['
          );
          reflectDAD.alpha = 0.25;
          reflectDAD.flipY = true;
          game.addBehindDad(reflectDAD);
        ]]);
      elseif value1:find('bf') or value1:find('1') then
        runHaxeCode([[
          game.remove(reflectBOYFRIEND);
          reflectBOYFRIEND = new Character(
            game.boyfriend.x + ]]..(characters.bf[boyfriendName].x)..[[,
            game.boyfriend.y + ]]..(characters.bf[boyfriendName].y)..[[,
            ']]..(boyfriendName)..[['
          );
          reflectGF.alpha = 0.25;
          reflectGF.flipY = true;
          game.addBehindBF(reflectBOYFRIEND);
        ]]);
      elseif value1:find('gf') or value1:find('2') then
        runHaxeCode([[
          game.remove(reflectGF);
          reflectGF = new Character(
            game.gf.x + ]]..(characters.gf[gfName].x)..[[,
            game.gf.y + ]]..(characters.gf[gfName].y)..[[,
            ']]..(gfName)..[['
          );
          reflectGF.alpha = 0.25;
          reflectGF.flipY = true;
          game.addBehindGF(reflectGF);
        ]]);
      end
    end
  end