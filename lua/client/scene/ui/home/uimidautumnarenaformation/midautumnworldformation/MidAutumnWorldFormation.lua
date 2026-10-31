require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.MidAutumnWorldFormation.MidAutumnWorldTeamFormation"
require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.MidAutumnWorldFormation.MidAutumnWorldFormationModel"
require "lua.client.scene.ui.home.uiMidAutumnArenaFormation.MidAutumnHeroSlot.MidAutumnHeroSlotWorldFormation"
require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
--- @class MidAutumnWorldFormation : WorldFormation
MidAutumnWorldFormation = Class(MidAutumnWorldFormation,WorldFormation)


function MidAutumnWorldFormation:InitReferences()
    self.attackerWorldFormation = MidAutumnWorldTeamFormation(self, true)
    self.defenderWorldFormation = MidAutumnWorldTeamFormation(self, false)
end

