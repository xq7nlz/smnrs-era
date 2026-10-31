require "lua.client.scene.ui.home.uiEventBossChallengeFormation.bossChallengeWorldFormation.BossChallengeWorldTeamFormation"
require "lua.client.scene.ui.home.uiEventBossChallengeFormation.bossChallengeWorldFormation.BossChallengeWorldFormationModel"
require "lua.client.scene.ui.home.uiEventBossChallengeFormation.heroSlotWorldFormation.BossChallengeHeroSlotWorldFormation"
require "lua.client.scene.ui.home.uiFormation2.worldFormation.WorldFormation"
--- @class BossChallengeWorldFormation : WorldFormation
BossChallengeWorldFormation = Class(BossChallengeWorldFormation,WorldFormation)


function BossChallengeWorldFormation:InitReferences()
    self.attackerWorldFormation = BossChallengeWorldTeamFormation(self, true)
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
    self.defenderWorldFormation = BossChallengeWorldTeamFormation(self, false)
end

