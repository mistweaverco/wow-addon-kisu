Kisu = {}
Kisu.Core = {}
Kisu.Core.AddonPanel = CreateFrame("Frame")
Kisu.Core.ticker = {}
Kisu.Core.runOnceOnAddonLoaded = {}
Kisu.Core.Cache = {}


function Kisu.Core.tick()
	for _, tick in pairs(Kisu.Core.ticker) do
		tick()
	end
end

function Kisu.Core.onAddonCopartmentClick()
	InterfaceOptionsFrame_OpenToCategory(Kisu.Core.AddonPanel)
end

function Kisu.Core.setupAddonCompartment()
	AddonCompartmentFrame:RegisterAddon({
		text = "Kisu",
		icon = "Interface\\Icons\\classicon_rogue",
		notCheckable = true,
		func = Kisu.Core.onAddonCopartmentClick,
	})
end

local function updatePlayerIsInInstance()
	Kisu.Core.Cache.playerIsInInstance = nil
	Kisu.Core.isPlayerInInstance(true)
end

function Kisu.Core.isPlayerInInstance(force)
	if force ~= true and Kisu.Core.Cache.playerIsInInstance ~= nil then
		return Kisu.Core.Cache.playerIsInInstance
	end
	local inInstance, _ = IsInInstance()
	if inInstance then
		Kisu.Core.Cache.playerIsInInstance = true
		return true
	else
		Kisu.Core.Cache.playerIsInInstance = false
		return false
	end
end

function Kisu.Core.setupAddonPanel()
	Kisu.Core.AddonPanel.name = "Kisu"
	Kisu.Core.AddonPanel.okay = function() end
	Kisu.Core.AddonPanel.cancel = function() end
	Kisu.Core.AddonPanel.default = function() end
	Kisu.Core.AddonPanel.refresh = function() end
	InterfaceOptions_AddCategory(Kisu.Core.AddonPanel)
end

local function onAddonLoaded()
	KisuDB = KisuDB or {}
	KisuPCDB = KisuPCDB or {}

	Kisu.Core.setupAddonPanel();
	Kisu.Core.setupAddonCompartment();

	for _, ro in pairs(Kisu.Core.runOnceOnAddonLoaded) do
		ro()
	end

	if next(Kisu.Core.ticker) ~= nil then
		C_Timer.NewTicker(1, Kisu.Core.tick)
	end
end

local frame = CreateFrame("Frame")

-- trigger event with /reloadui or /rl
frame:RegisterEvent("ADDON_LOADED")

-- trigger when entering or leaving an instance
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

frame:SetScript("OnEvent", function(this, event, addonName, ...)
	if event == "ADDON_LOADED" and addonName == "Kisu" then
		onAddonLoaded()
	end
	if event == "PLAYER_ENTERING_WORLD" then
		updatePlayerIsInInstance()
	end
end)

SLASH_KISU1 = "/kisu"

SlashCmdList.KISU = function(msg, editBox)
	InterfaceOptionsFrame_OpenToCategory(Kisu.Core.AddonPanel)
end
