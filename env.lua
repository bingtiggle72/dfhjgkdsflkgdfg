pcall(function()
    if getgenv()["_0x1"] then return end
    local _n = string.lower((identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "")
    if _n:find("xeno") or _n:find("solara") or _n:find("velocity") then return end
    if not (getgc and islclosure and debug and debug.info and getfenv and rawset and setfenv and getcallbackvalue) then return end
    getgenv()["_0x1"] = true
    local _t = task
    local _tw = task.wait
    local _td = task.delay
    local _ts = task.spawn
    local _co = coroutine
    local _sm = setmetatable
    local _ty = typeof
    local _nx = next
    local _ip = ipairs
    local _gc = clonefunction and clonefunction(getgc) or getgc
    local _gf = clonefunction and clonefunction(getfenv) or getfenv
    local _sf2 = clonefunction and clonefunction(setfenv) or setfenv
    local _di = clonefunction and clonefunction(debug.info) or debug.info
    local _rs = clonefunction and clonefunction(rawset) or rawset
    local _gcv = clonefunction and clonefunction(getcallbackvalue) or getcallbackvalue
    local _il = clonefunction and clonefunction(islclosure) or islclosure
    local _gc2 = getconnections and (clonefunction and clonefunction(getconnections) or getconnections)
    local _rs2 = cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
    local _sc = cloneref and cloneref(game:GetService("ScriptContext")) or game:GetService("ScriptContext")
    local _iec = isexecutorclosure
    local function _chk(f) return _iec and _iec(f) end
    local _handshakeRemote = nil
    local _handshakeCallback = nil
    local _rf,_re = Instance.new("RemoteFunction"),Instance.new("RemoteEvent")
    local _oi,_of = _rf.InvokeServer,_re.FireServer
    _rf:Destroy() _re:Destroy()
    local _ci,_cf = clonefunction and clonefunction(_oi) or _oi, clonefunction and clonefunction(_of) or _of
    getgenv()._origGetUpvalues = clonefunction and clonefunction(debug.getupvalues or getupvalues) or (debug.getupvalues or getupvalues)
    getgenv()._origGetConstants = clonefunction and clonefunction(debug.getconstants or getconstants) or (debug.getconstants or getconstants)
    getgenv()._origGetInfo = clonefunction and clonefunction(debug.getinfo or getinfo) or (debug.getinfo or getinfo)
    local function _setupSpyProtection()
        if not (hookfunction and newcclosure) then return end
        pcall(function()
            local _ocv = clonefunction(getcallbackvalue)
            hookfunction(getcallbackvalue, newcclosure(function(r, c)
                if _handshakeRemote and r == _handshakeRemote then return nil end
                return _ocv(r, c)
            end))
        end)
        pcall(function()
            local _ohf = clonefunction(hookfunction)
            hookfunction(hookfunction, newcclosure(function(t, nf)
                if t == _oi or t == RemoteFunction.InvokeServer then
                    return _ohf(t, newcclosure(function(self, ...)
                        if _handshakeRemote and self == _handshakeRemote then
                            return _ci(self, ...)
                        end
                        return nf(self, ...)
                    end))
                elseif t == _of or t == RemoteEvent.FireServer then
                    return _ohf(t, newcclosure(function(self, ...)
                        return nf(self, ...)
                    end))
                end
                return _ohf(t, nf)
            end))
        end)
    end
    if hookfunction and newcclosure then
        pcall(function()
            if debug.getupvalues or getupvalues then
                local _o = clonefunction(debug.getupvalues or getupvalues)
                hookfunction(debug.getupvalues or getupvalues, newcclosure(function(f) if _chk(f) then return {} end return _o(f) end))
            end
        end)
        pcall(function()
            if debug.getconstants or getconstants then
                local _o = clonefunction(debug.getconstants or getconstants)
                hookfunction(debug.getconstants or getconstants, newcclosure(function(f) if _chk(f) then return {} end return _o(f) end))
            end
        end)
        pcall(function()
            if debug.getinfo or getinfo then
                local _o = clonefunction(debug.getinfo or getinfo)
                hookfunction(debug.getinfo or getinfo, newcclosure(function(f, ...) if _chk(f) then return nil end return _o(f, ...) end))
            end
        end)
        pcall(function()
            if debug.getproto or getproto then
                local _o = clonefunction(debug.getproto or getproto)
                hookfunction(debug.getproto or getproto, newcclosure(function(f, ...) if _chk(f) then return nil end return _o(f, ...) end))
            end
        end)
        pcall(function()
            if debug.getprotos or getprotos then
                local _o = clonefunction(debug.getprotos or getprotos)
                hookfunction(debug.getprotos or getprotos, newcclosure(function(f) if _chk(f) then return {} end return _o(f) end))
            end
        end)
        pcall(function()
            if debug.getstack or getstack then
                local _o = clonefunction(debug.getstack or getstack)
                hookfunction(debug.getstack or getstack, newcclosure(function(l, ...) return _o(l, ...) end))
            end
        end)
        pcall(function()
            if debug.setconstant or setconstant then
                local _o = clonefunction(debug.setconstant or setconstant)
                hookfunction(debug.setconstant or setconstant, newcclosure(function(f, ...) if _chk(f) then return end return _o(f, ...) end))
            end
        end)
        pcall(function()
            if debug.setupvalue or setupvalue then
                local _o = clonefunction(debug.setupvalue or setupvalue)
                hookfunction(debug.setupvalue or setupvalue, newcclosure(function(f, ...) if _chk(f) then return end return _o(f, ...) end))
            end
        end)
        pcall(function()
            if debug.setstack or setstack then
                local _o = clonefunction(debug.setstack or setstack)
                hookfunction(debug.setstack or setstack, newcclosure(function(l, ...) return _o(l, ...) end))
            end
        end)
        pcall(function()
            if getscriptclosure then
                local _o = clonefunction(getscriptclosure)
                hookfunction(getscriptclosure, newcclosure(function(s) local r = _o(s) if _chk(r) then return nil end return r end))
            end
        end)
        pcall(function()
            local _ogc = clonefunction(getgc)
            hookfunction(getgc, newcclosure(function(i)
                local r = _ogc(i)
                local o = {}
                for _, v in _nx, r do
                    if _ty(v) == 'function' then
                        if _chk(v) then continue end
                        if _handshakeCallback and v == _handshakeCallback then continue end
                    end
                    o[#o+1] = v
                end
                return o
            end))
        end)
    end
    local _sf = spawn or _ts
    if not _sf then return end
    _sf(function()
        pcall(function()
            local _hr, _hc, _he, _ne = nil, nil, nil, nil
            for _ = 1, 15 do
                local _nf = _rs2:FindFirstChild("packages")
                _nf = _nf and _nf:FindFirstChild("Net")
                if _nf then
                    for _, _c in _ip(_nf:GetChildren()) do
                        if _c:IsA("RemoteFunction") and _c.Name:sub(1,3) == "RF/" then
                            local _cb = _gcv(_c, "OnClientInvoke")
                            if _cb then
                                local _s, _src = pcall(_di, _cb, 's')
                                if _s and _src and _src:find("ReplicatedFirst") then
                                    _hr = _c
                                    _hc = _cb
                                    _handshakeRemote = _c
                                    _handshakeCallback = _cb
                                    local _eo, _ev = pcall(_gf, _cb)
                                    if _eo then _he = _ev end
                                    break
                                end
                            end
                        end
                    end
                end
                if _hc then break end
                _tw(0.3)
            end
            if not _hc or not _he then return end
            _ne = _sm({
                wait = _tw,
                delay = _td,
                spawn = _ts,
                task = _t,
                coroutine = _co,
                script = _he.script,
            }, {
                __index = _he,
                __newindex = _he,
            })
            local ok = pcall(function() _sf2(_hc, _ne) end)
            if not ok then return end
            local _fr
            if newcclosure then
                _fr = newcclosure(function() return _tw(9e9) end)
            else
                _fr = function() return _tw(9e9) end
            end
            local _mt = {__index = function() return _fr end}
            for _, _v in _nx, _gc(true) do
                if _ty(_v) == 'function' and _il(_v) then
                    local _s, _src = pcall(_di, _v, 's')
                    if _s and _src and _src:find('ReplicatedFirst')
                        and not _src:find('loading')
                        and not _src:find('Loading')
                        and not _src:find('printLoadingTime')
                        and not _src:find('UserGenerated')
                        and not _src:find('DetailModuleClient')
                        and not _src:find('visibleskip')
                        and not _src:find('tips')
                    then
                        local _s2, _env = pcall(_gf, _v)
                        if _s2 and _env and _env ~= _ne then
                            _rs(_env, 'wait', _fr)
                            _rs(_env, 'delay', _fr)
                            _rs(_env, 'spawn', _fr)
                            _rs(_env, 'task', _sm({}, _mt))
                            _rs(_env, 'coroutine', _sm({}, _mt))
                        end
                    end
                end
            end
            if _gc2 then
                pcall(function()
                    for _, _v in _nx, _gc2(_sc.Error) do
                        _v:Disable()
                    end
                end)
            end
            if _hr and _hc and setcallbackvalue then
                local _scv = clonefunction and clonefunction(setcallbackvalue) or setcallbackvalue
                local _whc
                if newcclosure then
                    _whc = newcclosure(function(...) return _hc(...) end)
                else
                    _whc = _hc
                end
                pcall(function() _scv(_hr, "OnClientInvoke", _whc) end)
            end
            _tw(0.5)
            _setupSpyProtection()
        end)
    end)
end)
