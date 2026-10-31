--- @class ClientHero10006BaseAttack : BaseSkillShow
ClientHero10006BaseAttack = Class(ClientHero10006BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero10006BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

--- @param actionResults List<BaseActionResult>
function ClientHero10006BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end