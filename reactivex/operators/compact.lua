local Observable = require 'reactivex.observable'
local util = require 'reactivex.util'

--- Returns a new Observable that produces the values of the first with falsy values removed.
-- @returns {Observable}
function Observable:compact()
  return self:filter(util.identity)
end
