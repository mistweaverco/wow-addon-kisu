local shroudBuffSpellId = 114018

local function getShroudTime()
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(shroudBuffSpellId)
    if aura then
        return aura.expirationTime
    end
    return nil
end

local function tick()
    local shroudTime = getShroudTime()
    if shroudTime then
        local remaining = shroudTime - GetTime()
        -- We use the cached value of playerIsInInstance to avoid calling IsInInstance() too often
        if remaining > 0 and Kisu.Core.isPlayerInInstance() then
            SendChatMessage("Shroud of Concealment: " .. math.floor(remaining) .. " seconds remaining")
        end
    end
end

local runOnceOnAddonLoaded = function()
    table.insert(Kisu.Core.ticker, tick)
end

table.insert(Kisu.Core.runOnceOnAddonLoaded, runOnceOnAddonLoaded)