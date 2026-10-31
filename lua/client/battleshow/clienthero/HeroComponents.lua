--- @class HeroComponents
HeroComponents = Class(HeroComponents)

--- @param gameObject UnityEngine_GameObject
function HeroComponents:Ctor(gameObject)
    --- @type UnityEngine_GameObject
    self.gameObject = gameObject
    --- @type UnityEngine_Transform
    self.transform = gameObject.transform
    --- @type UnityEngine_Transform
    self.headAnchor = self.transform:Find("Model/HeadAnchor")
    --- @type UnityEngine_Transform
    self.bodyAnchor = self.transform:Find("Model/BodyAnchor")
    --- @type UnityEngine_Transform
    self.footAnchor = self.transform:Find("Model/FootAnchor")
    --- @type UnityEngine_Transform
    self.torsoAnchor = self.transform:Find("Model/torso")
    --- @type UnityEngine_Transform
    self.model = self.transform:Find("Model")

    --- @type UnityEngine_Vector3
    self.scaleFactor = nil
end

--- @return number
function HeroComponents:GetScaleFactor()
    if self.scaleFactor == nil then
        if self.transform.parent ~= nil then
            self.scaleFactor = self.transform.parent.localScale
        else
            self.scaleFactor = self.transform.localScale
        end
    end
    return self.scaleFactor
end

--- @param anchorType number
--- @return UnityEngine_Transform
function HeroComponents:GetHeroAnchor(anchorType)
    if anchorType == ClientConfigUtils.HEAD_ANCHOR then
        return self.headAnchor
    elseif anchorType == ClientConfigUtils.BODY_ANCHOR then
        return self.bodyAnchor
    elseif anchorType == ClientConfigUtils.FOOT_ANCHOR then
        return self.footAnchor
    elseif anchorType == ClientConfigUtils.TORSO_ANCHOR then
        return self.torsoAnchor
    end
end

--- @param anchorType number
--- @return UnityEngine_Vector3
function HeroComponents:GetAnchorPosition(anchorType)
    if anchorType == ClientConfigUtils.HEAD_ANCHOR then
        return self.headAnchor.position
    elseif anchorType == ClientConfigUtils.BODY_ANCHOR then
        return self.bodyAnchor.position
    elseif anchorType == ClientConfigUtils.FOOT_ANCHOR then
        return self.footAnchor.position
    elseif anchorType == ClientConfigUtils.TORSO_ANCHOR then
        return self.torsoAnchor.position
    else
        XDebug.Error("Cannot find Anchor by id " .. anchorType)
    end
end

--- @param path string
--- @return UnityEngine_Transform
function HeroComponents:FindChildByPath(path)
    return self.transform:Find(path)
end

--- @return UnityEngine_Vector3
function HeroComponents:Rotation()
    return self.model.rotation
end

--- @return UnityEngine_Vector3
function HeroComponents:LocalScale()
    return self.transform.localScale
end