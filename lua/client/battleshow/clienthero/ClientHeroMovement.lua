--- @class ClientHeroMovement
ClientHeroMovement = Class(ClientHeroMovement)

--- @param clientHero ClientHero
function ClientHeroMovement:Ctor(clientHero)
    --- @type ClientHero
    self.clientHero = clientHero
    --- @type UnityEngine_Transform
    self.transform = clientHero.gameObject.transform
end

--- @param toX number
--- @param toY number
--- @param duration number
--- @param onComplete function
--- @param easeType DOTweenEase
function ClientHeroMovement:DoMoveAxis(toX, toY, onComplete, duration, easeType)
    duration = duration or ClientConfigUtils.EXECUTE_MOVE_TIME
    easeType = easeType or DOTweenEase.Linear
    self:DoMovePosition(U_Vector3(toX, toY, 0), duration, onComplete, easeType)
end

--- @return DG_Tweening_Tweener
--- @param position UnityEngine_Vector3
--- @param duration number
--- @param onComplete function
--- @param easeType DOTweenEase
function ClientHeroMovement:DoMovePosition(position, onComplete, duration, easeType)
    duration = duration or ClientConfigUtils.EXECUTE_MOVE_TIME
    easeType = easeType or DOTweenEase.Linear
    return self.transform:DOMove(position, duration):OnComplete(function ()
        if onComplete ~= nil then
            onComplete()
        end
    end):OnUpdate(function ()
        self.clientHero.animation:UpdateLayer(self.transform.position.y)
    end)
end

--- @param position UnityEngine_Vector3
function ClientHeroMovement:SetPosition(position)
    self.transform:DOMove(position, 0.2)
    self.clientHero.animation:UpdateLayer(self.transform.position.y)
end

--- @param position UnityEngine_Vector3
function ClientHeroMovement:SetPositionInstant(position)
    self.transform:DOMove(position, 0)
    self.clientHero.animation:UpdateLayer(self.transform.position.y)
end