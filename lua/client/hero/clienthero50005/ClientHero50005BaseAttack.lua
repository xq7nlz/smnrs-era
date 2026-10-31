--- @class ClientHero50005BaseAttack : BaseSkillShow
ClientHero50005BaseAttack = Class(ClientHero50005BaseAttack, BaseSkillShow)

--- @param clientHero ClientHero
function ClientHero50005BaseAttack:Ctor(clientHero)
    BaseSkillShow.Ctor(self, clientHero, true)
end

--- @param actionResults List<BaseActionResult>
function ClientHero50005BaseAttack:CastOnTarget(actionResults)
    BaseSkillShow.CastOnTarget(self, actionResults)
    self:DoAnimation()
end