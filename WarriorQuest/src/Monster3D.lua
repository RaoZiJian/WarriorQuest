Monster3D = class("Monster3D",function ()
	return require "Base3D".create()
end)

local size = cc.Director:getInstance():getWinSize()
local scheduler = cc.Director:getInstance():getScheduler()

function Monster3D:ctor()

end

function Monster3D.create(type)

    local monster = Monster3D.new()
    monster:AddSprite3D(type)    
    
    --base
    monster:setRaceType(type)

    --self
    local function update(dt)
        if monster.FindEnemy2Attack == nil then return  end
        monster:FindEnemy2Attack()        
    end

    scheduler:scheduleScriptFunc(update, 0.5, false)  
    
    return monster
end

function Monster3D:AddSprite3D(type)
	
    local filename = "Sprite3DTest/orc.c3b";
    self._sprite3d = cc.EffectSprite3D:create(filename)
    self:addChild(self._sprite3d)
    self._sprite3d:setRotation3D({x = 90, y = 0, z = 0})        
    self._sprite3d:setRotation(180)
      
    self._action.attack = filename
end

local scheduler = cc.Director:getInstance():getScheduler()

function Monster3D:FindEnemy2Attack()
    if self._isalive == false then
        if self._scheduleAttackId ~= 0 then
            scheduler:unscheduleScriptEntry(self._scheduleAttackId)
            self._scheduleAttackId = 0
        end
        return
    end 
    
    if self._statetype == EnumStateType.ATTACK and self._scheduleAttackId == 0 then
        local function scheduleAttack(dt)
            if self._target == nil or self._target == 0 or self._target._isalive == false then
                scheduler:unscheduleScriptEntry(self._scheduleAttackId)
                self._scheduleAttackId = 0
                return
            end

            self._target:hurt(self._attack)
        end    
        self._scheduleAttackId = scheduler:scheduleScriptFunc(scheduleAttack, 1, false)            
    end

    if self._statetype ~= EnumStateType.ATTACK and self._scheduleAttackId ~= 0 then
        scheduler:unscheduleScriptEntry(self._scheduleAttackId)
        self._scheduleAttackId = 0
    end  
end

return Monster3D