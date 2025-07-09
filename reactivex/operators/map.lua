local Observable = require 'reactivex.observable'
local util = require 'reactivex.util'
local Observer = require 'reactivex.observer'

--- Returns a new Observable that produces the values of the original transformed by a function.
--- 建议使用mapNotNil替代
-- @arg {function} callback - The function to transform values from the original Observable.
-- @returns {Observable}
function Observable:map(callback)
  return self:lift(function (destination)
    callback = callback or util.identity

    local function onNext(...)
      return util.tryWithObserver(destination, function(...)
        return destination:onNext(callback(...))
      end, ...)
    end

    local function onError(e)
      return destination:onError(e)
    end

    local function onCompleted()
      return destination:onCompleted()
    end

    return Observer.create(onNext, onError, onCompleted)
  end)
end

---保证map返回非nil值(防止mapper忘记写return)
---@generic V
---@param self Observable<T>
---@param mapper fun(t:T):V
---@return Observable<V>
function Observable.mapNotNil(self, mapper)
    return self:map(function(v)
        local ret = mapper(v)
        util.erNil(ret)
        return ret
    end)
end