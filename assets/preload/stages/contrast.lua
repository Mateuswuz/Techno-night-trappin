local shaderName = "bloom"

function onCreate()
    shaderCoordFix() -- initialize a fix for textureCoord when resizing game window

    makeLuaSprite("tempShader0")

    runHaxeCode([[
        var shaderName = "]] .. shaderName .. [[";
        
        game.initLuaShader(shaderName);
        
        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("tempShader0").shader = shader0; // setting it into temporary sprite so luas can set its shader uniforms/properties
        return;
    ]])

	-- background shit
	makeLuaSprite('sky', 'BG_sky', -400, -300);
	scaleObject('sky', 0.9, 0.9);
	addLuaSprite('sky', false);

	makeLuaSprite('clouds', 'BG_clouds', -325, -100);
	scaleObject('clouds', 0.9, 0.9);
	addLuaSprite('clouds', false);

	makeLuaSprite('mountains', 'BG_mountains', -400, -225);
	scaleObject('mountains', 0.9, 0.9);
	addLuaSprite('mountains', false);

	makeLuaSprite('buildings', 'BG_buildings', -300, -400);
	scaleObject('buildings', 0.9, 0.9);
	addLuaSprite('buildings', false);

	makeLuaSprite('ground', 'BG_ground', -350, 150);
	scaleObject('ground', 0.95, 0.9);
	addLuaSprite('ground', false);

	makeLuaSprite('bartop','',0,0);
	makeGraphic('bartop',1280,75,'000000');
	addLuaSprite('bartop',false);
	makeLuaSprite('barbot','',0,650);
	makeGraphic('barbot',1280,100,'000000');
	addLuaSprite('barbot',false);
	setScrollFactor('bartop',0,0);
	setScrollFactor('barbot',0,0);
	setObjectCamera('bartop','hud');
	setObjectCamera('barbot','hud');
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end