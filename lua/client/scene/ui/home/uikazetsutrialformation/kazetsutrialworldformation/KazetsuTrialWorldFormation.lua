require "lua.client.scene.ui.home.uiKazetsuTrialFormation.KazetsuTrialWorldFormation.KazetsuTrialWorldTeamFormation"
require "lua.client.scene.ui.home.uiKazetsuTrialFormation.KazetsuTrialWorldFormation.KazetsuTrialWorldFormationModel"
require "lua.client.scene.ui.home.uiKazetsuTrialFormation.heroSlotWorldFormation.KazetsuTrialHeroSlotWorldFormation"
require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
--- @class KazetsuTrialWorldFormation : WorldFormation
KazetsuTrialWorldFormation = Class(KazetsuTrialWorldFormation,WorldFormation)


function KazetsuTrialWorldFormation:InitReferences()
    self.attackerWorldFormation = KazetsuTrialWorldTeamFormation(self, true)
    self.attackerWorldFormation.btnCallbackSelect = function(isAttackerTeam, positionTable)
        self:CallbackSelectHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackChange = function(isAttackerTeam, positionTable)
        self:CallbackChange(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackRemove = function(isAttackerTeam, positionTable)
        self:CallbackRemoveHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackSwap = function(isAttackerTeam, positionTable)
        self:CallbackSwapHero(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnCallbackSelectSummoner = function()
        self:CallbackSelectSummoner()
    end

    self.attackerWorldFormation.btnTriggerPointerDown = function(isAttackerTeam, positionTable)
        self:SlotTriggerPointerDown(isAttackerTeam, positionTable)
    end
    self.attackerWorldFormation.btnTriggerPointerUp = function(isAttackerTeam, position)
        self:SlotTriggerPointerUp(isAttackerTeam, position)
    end
    self.attackerWorldFormation.btnTriggerPointerDrag = function(isAttackerTeam, position)
        self:SlotTriggerPointerDrag(isAttackerTeam, position)
    end
    self.defenderWorldFormation = KazetsuTrialWorldTeamFormation(self, false)
end

