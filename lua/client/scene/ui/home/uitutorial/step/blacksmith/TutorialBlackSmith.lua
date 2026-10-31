--- @class TutorialBlackSmith : TutorialCampaign
TutorialBlackSmith = Class(TutorialBlackSmith, TutorialCampaign)

--- @return void
function TutorialBlackSmith:Ctor()
    TutorialCampaign.Ctor(self)

    ---@type TutorialSingle
    self.clickBlackSmith = TutorialSingle.Create(TutorialStepData():Step(TutorialStep.CLICK_BLACK_SMITH):
    Focus(TutorialFocus.FOCUS_CLICK):Delay(0.5):TrackingName("click_black_smith"))

    ---@type TutorialSingle
    self.whatBlackSmith = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_what_black_smith"):ShowNpc(true):
    Text1("player_option1"):TrackingName("black_smith_info"):Text2("player_option2"):Delay(2))

    ---@type TutorialSingle
    self.weaponInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_weapon"):ShowNpc(true):
    Step(TutorialStep.BLACK_SMITH_WEAPON):TrackingName("black_smith_info1"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    self.armorInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_armor"):ShowNpc(true):
    Step(TutorialStep.BLACK_SMITH_ARMOR):TrackingName("black_smith_info2"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    self.helmetInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_helmet"):ShowNpc(true):
    Step(TutorialStep.BLACK_SMITH_HELMET):TrackingName("black_smith_info3"):Focus(TutorialFocus.FOCUS):Pivot(TutorialPivot.BOTTOM_LEFT))

    ---@type TutorialSingle
    self.ringInfo = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_ring"):ShowNpc(true):
    Step(TutorialStep.BLACK_SMITH_RING):TrackingName("black_smith_info4"):Focus(TutorialFocus.FOCUS):Text1("player_option1_1"))

    ---@type TutorialSingle
    self.forgeCLick = TutorialSingle.Create(TutorialStepData()
            :KeyLocalize("npc_black_smith")
            :Step(TutorialStep.FORGE_CLICK)
            :Focus(TutorialFocus.FOCUS_CLICK)
            :WaitOpCode(OpCode.ITEM_UPGRADE_ON_BLACKSMITH)
            :Pivot(TutorialPivot.TOP_RIGHT)
            :StepId(self:GetStepId())
            :HideFocus(true)
            :ShowNpc(true)
            :WaitOpCode(OpCode.ITEM_UPGRADE_ON_BLACKSMITH)
            :TrackingName("click_forge")
    )

    ---@type TutorialSingle
    self.back = TutorialSingle.Create(TutorialStepData():KeyLocalize("npc_claim_black_smith"):Pivot(TutorialPivot.TOP_LEFT):
    Step(TutorialStep.BACK_BLACK_SMITH):TrackingName("back_black_smith"):Focus(TutorialFocus.TAP_TO_CLICK):Delay(1.5):ShowNpc(true))

    self.clickBlackSmith.tutorialStepData:TrackingID(1)
    self.whatBlackSmith.tutorialStepData:TrackingID(2)
    self.weaponInfo.tutorialStepData:TrackingID(3)
    self.armorInfo.tutorialStepData:TrackingID(4)
    self.helmetInfo.tutorialStepData:TrackingID(5)
    self.ringInfo.tutorialStepData:TrackingID(6)
    self.forgeCLick.tutorialStepData:TrackingID(7)
    self.back.tutorialStepData:TrackingID(8)
end

TutorialBlackSmith.stepId = 6000

--- @return number
function TutorialBlackSmith:GetStepId()
    return TutorialBlackSmith.stepId
end

--- @return number
function TutorialBlackSmith:CanRunTutorial()
    ---@type List --<id>
    local itemSortWeapon = ClientConfigUtils.GetEquipmentBlackSmith(EquipmentType.Weapon, -1)
    ---@type number
    local numberMaterial = InventoryUtils.Get(ResourceType.ItemEquip, itemSortWeapon:Get(1) - 1)
    return numberMaterial >= 3
end

--- @return TutorialNode
function TutorialBlackSmith:Continue()
    return TutorialLine.Create(TutorialOption.Create(self.whatBlackSmith, nil,
            TutorialLine.Create(self.weaponInfo,
                    self.armorInfo,
                    self.helmetInfo,
                    self.ringInfo
            )
    ),
            self.forgeCLick,
            self.back
    )
end

--- @return TutorialNode
function TutorialBlackSmith:Start()
    return TutorialLine.Create(self.clickBlackSmith,
            self:Continue()
    )
end