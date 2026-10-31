--- @class TutorialSummonHeroic : TutorialSummon
TutorialSummonHeroic = Class(TutorialSummonHeroic, TutorialSummon)

--- @return void
function TutorialSummonHeroic:Ctor()
	TutorialSummon.Ctor(self)
	---@type TutorialSingle
	self.t1 = TutorialSingle.Create(TutorialStepData()
			:KeyLocalize("npc_hello")
			:Delay(0.5)
			:ShowNpc(true)
			:Pivot(TutorialPivot.CENTER))

	---@type TutorialSingle
	--- Tutorial asking continue tutorial or not?
	self.askingContinueTutorial = TutorialSingle.Create(TutorialStepData()
			:KeyLocalize("asking_continue_tutorial")
			:TrackingName("asking_continue_tutorial")
			:ShowNpc(true)
			:Text1("yes")
			:Text2("no")
			:Delay(1))

	---@type TutorialNode
	--- Tutorial click on free/one premium button
	self.freeHeroicSummon = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.FREE_HEROIC_SUMMON_CLICK)
			:Focus(TutorialFocus.FOCUS_CLICK)
			:StepId(self:GetStepId())
			:Delay(1)
			:TrackingName("click_summon_heroic")
			:TrackingID(7)
	)

	---@type TutorialNode
	--- Tutorial click on x10 hero premium summon button
	self.tenHeroicSummon = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.TEN_HEROIC_SUMMON_CLICK)
			:Focus(TutorialFocus.FOCUS_CLICK)
			:StepId(self:GetStepId())
			:Delay(0.2)
			:TrackingName("click_ten_summon_heroic")
			:TrackingID(7)
	)

	---@type TutorialNode
	--- Tutorial introduce hero after summoning hero
	self.introduceHeroSummoned = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.INTRODUCE_HERO_SUMMONED)
			:Focus(TutorialFocus.FOCUS)
			:KeyLocalize("introduce_hero_summoned")
			:StepId(self:GetStepId())
			:Delay(3.5)
			:ShowNpc(true)
			:Pivot(TutorialPivot.BOTTOM_LEFT)
			:TrackingName("introduce_hero_summoned")
			:TrackingID(8)
	)

	self.backResult.tutorialStepData:TrackingID(9)
	self.backSummonAuto.tutorialStepData:TrackingID(10)

	---@type TutorialNode
	--- Tutorial making skip all tutorial remaining
	self.skipAllTutorial = TutorialSingle.Create(TutorialStepData()
			:Step(TutorialStep.SKIP_ALL_TUTORIAL)
			:Focus(TutorialFocus.FOCUS)
			:TrackingName("skip_all_tutorial"))
end

TutorialSummonHeroic.stepId = TutorialStepID.TUTORIAL_SUMMON_10

--- @return number
function TutorialSummonHeroic:GetStepId()
	return TutorialSummonHeroic.stepId
end

--- @return number
--- Run this tutorial if there is none hero in inventory
function TutorialSummonHeroic:CanRunTutorial()
	---@type List
	local listHero = InventoryUtils.Get(ResourceType.Hero)
	return listHero:Count() == 0
end

--- @return TutorialNode
function TutorialSummonHeroic:CreateTutorialSummonHeroLine()
	return TutorialLine.Create(
			self.pleaseHeroicSummon,
			self.tenHeroicSummon,
			self.introduceHeroSummoned,
			self.backResult,
			self.backSummonAuto
	)
end

--- @return TutorialNode
function TutorialSummonHeroic:Continue()
	--return TutorialLine.Create(self:TutorialSummonInfo(), self:CreateTutorialSummonHeroLine(), self:SkipTutorialLine())
	return TutorialLine.Create(self:TutorialSummonInfo(), self:CreateTutorialSummonHeroLine())
end

--- @return TutorialNode
function TutorialSummonHeroic:Start()
	return self:Continue()
end

--- @return TutorialNode
--- If player choose option 1 will continue tutorial, option 2 will skip all tutorial remaining
function TutorialSummonHeroic:SkipTutorialLine()
	return TutorialOption.Create(self.askingContinueTutorial, nil, self.skipAllTutorial)
end

--- @return TutorialNode
--- Tutorial Npc introduce about all summon hero scroll
function TutorialSummonHeroic:TutorialSummonInfo()
    return TutorialLine.Create(self.t1,self.clickSummon, self.heroicInfo, self.friendInfo, self.basicInfo)
end