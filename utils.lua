Kisu.Utils = {}

Kisu.Utils.fetchAllActiveBuffs = function()
    local active_buffs = {}
    local i = 1
    while true do
        local name, _, _, _, _, _, _, _, _, spell_id = UnitBuff("player", i)
        if not name then
            break
        end
        table.insert(active_buffs, {name = name, spell_id = spell_id})
        i = i + 1
    end
    return active_buffs
end

Kisu.Utils.debugPrintAllActiveBuffs = function()
    local active_buffs = Kisu.Utils.fetchAllActiveBuffs()
    for _, buff in ipairs(active_buffs) do
        print(buff.name, buff.spell_id)
    end
end

-- local _talents = {}
-- _talents["Invoke Yu'lon, the Jade Serpent"] = {
--     spell_id = 322118,
--     node_id = 1,
--     selected = false,
-- }

function Kisu.Utils.fetchTalentInfo(talents)
	local spec_id = PlayerUtil.GetCurrentSpecID()
	local config_id = C_ClassTalents.GetLastSelectedSavedConfigID(spec_id) or C_ClassTalents.GetActiveConfigID()
	local config_info = C_Traits.GetConfigInfo(config_id)
	local tree_id = config_info.treeIDs[1]

	local nodes = C_Traits.GetTreeNodes(tree_id)

	for _, node_id in ipairs(nodes) do
		for _, talent_data in pairs(talents) do
			if talent_data.node_id == node_id then
				local node_info = C_Traits.GetNodeInfo(config_id, node_id)
				if node_info.currentRank and node_info.currentRank > 0 then
					talent_data.selected = true
				end
			end
		end
	end
end
function Kisu.Utils.debugPrintTalentInfo()
	local spec_id = PlayerUtil.GetCurrentSpecID()
	local config_id = C_ClassTalents.GetLastSelectedSavedConfigID(spec_id) or C_ClassTalents.GetActiveConfigID()
	local config_info = C_Traits.GetConfigInfo(config_id)
	local tree_id = config_info.treeIDs[1]

	local nodes = C_Traits.GetTreeNodes(tree_id)

	for _, node_id in ipairs(nodes) do
		local node_info = C_Traits.GetNodeInfo(config_id, node_id)
		if node_info.currentRank and node_info.currentRank > 0 then
			local entry_id = node_info.activeEntry and node_info.activeEntry.entryID and node_info.activeEntry.entryID
			local entry_info = entry_id and C_Traits.GetEntryInfo(config_id, entry_id)
			local definition_info = entry_info
				and entry_info.definitionID
				and C_Traits.GetDefinitionInfo(entry_info.definitionID)

			if definition_info ~= nil then
				local talent_name = TalentUtil.GetTalentName(definition_info.overrideName, definition_info.spellID)
				print(
					string.format(
						"Name: %s - Rank: %d/%d - SpellID: %d - NodeID: %d",
						talent_name,
						node_info.currentRank,
						node_info.maxRanks,
						definition_info.spellID,
						node_id
					)
				)
			end
		end
	end
end