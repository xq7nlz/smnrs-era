--- @class ClientHero60006004ActiveSkill : ClientHero60006ActiveSkill
ClientHero60006004ActiveSkill = Class(ClientHero60006004ActiveSkill, ClientHero60006ActiveSkill)

function ClientHero60006004ActiveSkill:DeliverSetFrameAction()
    self.pos = PositionConfig.GetOpponentCenterTeamPosition(self.baseHero.teamId) - U_Vector3.up

    self:AddFrameAction(18, function()
        self:StartAccost()
    end)
end

function ClientHero60006004ActiveSkill:StartAccost()
    self:DoMovePosition(self.pos, nil, 1 / ClientConfigUtils.FPS)
end