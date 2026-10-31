---@class Vector2
Vector2 = Class(Vector2)

Vector2.DEFAULT_X = 0
Vector2.DEFAULT_Y = 0

function Vector2:Ctor(paramsOrX, y)
    if type(paramsOrX) == "number" then
        self.x = paramsOrX or Vector2.DEFAULT_X
        self.y = y or Vector2.DEFAULT_Y
    else
        local p = paramsOrX or {}
        self.x = p.x or Vector2.DEFAULT_X
        self.y = p.y or Vector2.DEFAULT_Y
    end
end

function Vector2.Clone(vector2)
    return Vector2(vector2.x, vector2.y)
end

function Vector2:copy ()
    return Vector2({ x = self.x, y = self.y })
end

function Vector2:__tostring ()
    return string.format("<Vector2 %f, %f>", self.x, self.y)
end

function Vector2:__eq (other)
    return self.x == other.x and self.y == other.y
end

function Vector2:__add (other)
    return Vector2({ x = (self.x + other.x), y = (self.y + other.y) })
end

function Vector2:__sub (other)
    return Vector2({ x = (self.x - other.x), y = (self.y - other.y) })
end

function Vector2:__mul (value)
    return Vector2({ x = (self.x * value), y = (self.y * value) })
end

function Vector2:__div (value)
    return Vector2({ x = (self.x / value), y = (self.y / value) })
end

function Vector2:zero ()
    self.x = 0
    self.y = 0
end

function Vector2:isZero ()
    return self.x == 0 and self.y == 0
end

function Vector2:length ()
    return math.sqrt((self.x ^ 2) + (self.y ^ 2))
end

function Vector2:lengthSq ()
    return (self.x ^ 2) + (self.y ^ 2)
end

function Vector2:normalize ()
    local length = self:length()
    if length > 0 then
        self.x = self.x / length
        self.y = self.y / length
    end
end

function Vector2:dot (other)
    return (self.x * other.x) + (self.y * other.y)
end

function Vector2:perp ()
    return Vector2(-self.y, self.x)
end