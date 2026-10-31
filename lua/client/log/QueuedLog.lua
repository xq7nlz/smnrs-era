--- @class QueuedLog
QueuedLog = Class(QueuedLog)

function QueuedLog:Ctor(message, stackTrace, type)
    ---@type string
    self.message = message
    ---@type string
    self.stackTrace = stackTrace
    ---@type LogType
    self.type = type
end
