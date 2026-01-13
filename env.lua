pcall(function()
    if getgenv().Bypass then return end

    local Name = string.lower((identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "")
    if Name:find("xeno") or Name:find("solara") or Name:find("velocity") then return end
    if not (getgc and islclosure and debug and debug.info and getfenv and rawset and setfenv and getcallbackvalue) then return end

    getgenv().Bypass = true

    local clone = clonefunction or function(f) return f end
    local cloneref = cloneref or function(x) return x end

    local getgc = clone(getgc)
    local getfenv = clone(getfenv)
    local setfenv = clone(setfenv)
    local debuginfo = clone(debug.info)
    local rawset = clone(rawset)
    local getcallbackvalue = clone(getcallbackvalue)
    local islclosure = clone(islclosure)
    local getconnections = getconnections and clone(getconnections)

    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local ScriptContext = cloneref(game:GetService("ScriptContext"))

    local isexecutorclosure = isexecutorclosure
    local function Check(f) return isexecutorclosure and isexecutorclosure(f) end

    local HandshakeRemote = nil
    local HandshakeCallback = nil

    local TempRf, TempRe = Instance.new("RemoteFunction"), Instance.new("RemoteEvent")
    local OriginalInvoke, OriginalFire = TempRf.InvokeServer, TempRe.FireServer
    TempRf:Destroy()
    TempRe:Destroy()
    local ClonedInvoke = clone(OriginalInvoke)
    local ClonedFire = clone(OriginalFire)

    local function sigma()
        if not (hookfunction and newcclosure) then return end

        pcall(function()
            local originalgetcb = clone(getcallbackvalue)
            hookfunction(getcallbackvalue, newcclosure(function(remote, callback)
                if HandshakeRemote and remote == HandshakeRemote then
                    return nil
                end
                return originalgetcb(remote, callback)
            end))
        end)

        pcall(function()
            local originalhook = clone(hookfunction)
            hookfunction(hookfunction, newcclosure(function(target, newfunc)
                if target == OriginalInvoke or target == RemoteFunction.InvokeServer then
                    return originalhook(target, newcclosure(function(self, ...)
                        if HandshakeRemote and self == HandshakeRemote then
                            return ClonedInvoke(self, ...)
                        end
                        return newfunc(self, ...)
                    end))
                elseif target == OriginalFire or target == RemoteEvent.FireServer then
                    return originalhook(target, newcclosure(function(self, ...)
                        return newfunc(self, ...)
                    end))
                end
                return originalhook(target, newfunc)
            end))
        end)
    end

    if hookfunction and newcclosure then
        pcall(function()
            if debug.getupvalues or getupvalues then
                local original = clone(debug.getupvalues or getupvalues)
                hookfunction(debug.getupvalues or getupvalues, newcclosure(function(f)
                    if Check(f) then return {} end
                    return original(f)
                end))
            end
        end)

        pcall(function()
            if debug.getconstants or getconstants then
                local original = clone(debug.getconstants or getconstants)
                hookfunction(debug.getconstants or getconstants, newcclosure(function(f)
                    if Check(f) then return {} end
                    return original(f)
                end))
            end
        end)

        pcall(function()
            if debug.getinfo or getinfo then
                local original = clone(debug.getinfo or getinfo)
                hookfunction(debug.getinfo or getinfo, newcclosure(function(f, ...)
                    if Check(f) then return nil end
                    return original(f, ...)
                end))
            end
        end)

        pcall(function()
            if debug.getproto or getproto then
                local original = clone(debug.getproto or getproto)
                hookfunction(debug.getproto or getproto, newcclosure(function(f, ...)
                    if Check(f) then return nil end
                    return original(f, ...)
                end))
            end
        end)

        pcall(function()
            if debug.getprotos or getprotos then
                local original = clone(debug.getprotos or getprotos)
                hookfunction(debug.getprotos or getprotos, newcclosure(function(f)
                    if Check(f) then return {} end
                    return original(f)
                end))
            end
        end)

        pcall(function()
            if debug.getstack or getstack then
                local original = clone(debug.getstack or getstack)
                hookfunction(debug.getstack or getstack, newcclosure(function(l, ...)
                    return original(l, ...)
                end))
            end
        end)

        pcall(function()
            if debug.setconstant or setconstant then
                local original = clone(debug.setconstant or setconstant)
                hookfunction(debug.setconstant or setconstant, newcclosure(function(f, ...)
                    if Check(f) then return end
                    return original(f, ...)
                end))
            end
        end)

        pcall(function()
            if debug.setupvalue or setupvalue then
                local original = clone(debug.setupvalue or setupvalue)
                hookfunction(debug.setupvalue or setupvalue, newcclosure(function(f, ...)
                    if Check(f) then return end
                    return original(f, ...)
                end))
            end
        end)

        pcall(function()
            if debug.setstack or setstack then
                local original = clone(debug.setstack or setstack)
                hookfunction(debug.setstack or setstack, newcclosure(function(l, ...)
                    return original(l, ...)
                end))
            end
        end)

        pcall(function()
            if getscriptclosure then
                local original = clone(getscriptclosure)
                hookfunction(getscriptclosure, newcclosure(function(s)
                    local result = original(s)
                    if Check(result) then return nil end
                    return result
                end))
            end
        end)

        pcall(function()
            local originalgc = clone(getgc)
            hookfunction(getgc, newcclosure(function(tables)
                local result = originalgc(tables)
                local filtered = {}
                for _, value in next, result do
                    if typeof(value) == "function" then
                        if Check(value) then continue end
                        if HandshakeCallback and value == HandshakeCallback then continue end
                    end
                    filtered[#filtered + 1] = value
                end
                return filtered
            end))
        end)
    end

    local spawnfunc = spawn or task.spawn
    if not spawnfunc then return end

    spawnfunc(function()
        pcall(function()
            local Remote, Callback, Env, SafeEnv = nil, nil, nil, nil

            for _ = 1, 15 do
                local Net = ReplicatedStorage:FindFirstChild("packages")
                Net = Net and Net:FindFirstChild("Net")

                if Net then
                    for _, Child in ipairs(Net:GetChildren()) do
                        if Child:IsA("RemoteFunction") and Child.Name:sub(1, 3) == "RF/" then
                            local Cb = getcallbackvalue(Child, "OnClientInvoke")
                            if Cb then
                                local Ok, Src = pcall(debuginfo, Cb, "s")
                                if Ok and Src and Src:find("ReplicatedFirst") then
                                    Remote = Child
                                    Callback = Cb
                                    HandshakeRemote = Child
                                    HandshakeCallback = Cb
                                    local EnvOk, EnvVal = pcall(getfenv, Cb)
                                    if EnvOk then Env = EnvVal end
                                    break
                                end
                            end
                        end
                    end
                end

                if Callback then break end
                task.wait(0.3)
            end

            if not Callback or not Env then return end

            SafeEnv = setmetatable({
                wait = task.wait,
                delay = task.delay,
                spawn = task.spawn,
                task = task,
                coroutine = coroutine,
                script = Env.script,
            }, {
                __index = Env,
                __newindex = Env,
            })

            local Ok = pcall(function() setfenv(Callback, SafeEnv) end)
            if not Ok then return end

            local Freeze = newcclosure and newcclosure(function() return task.wait(9e9) end) or
                function() return task.wait(9e9) end
            local FreezeMeta = { __index = function() return Freeze end }

            for _, Func in next, getgc(true) do
                if typeof(Func) == "function" and islclosure(Func) then
                    local Ok, Src = pcall(debuginfo, Func, "s")
                    if Ok and Src and Src:find("ReplicatedFirst")
                        and not Src:find("loading")
                        and not Src:find("Loading")
                        and not Src:find("printLoadingTime")
                        and not Src:find("UserGenerated")
                        and not Src:find("DetailModuleClient")
                        and not Src:find("visibleskip")
                        and not Src:find("tips")
                    then
                        local EnvOk, FuncEnv = pcall(getfenv, Func)
                        if EnvOk and FuncEnv and FuncEnv ~= SafeEnv then
                            rawset(FuncEnv, "wait", Freeze)
                            rawset(FuncEnv, "delay", Freeze)
                            rawset(FuncEnv, "spawn", Freeze)
                            rawset(FuncEnv, "task", setmetatable({}, FreezeMeta))
                            rawset(FuncEnv, "coroutine", setmetatable({}, FreezeMeta))
                        end
                    end
                end
            end

            if getconnections then
                pcall(function()
                    for _, Conn in next, getconnections(ScriptContext.Error) do
                        Conn:Disable()
                    end
                end)
            end

            if Remote and Callback and setcallbackvalue then
                local setcb = clone(setcallbackvalue)
                local Wrapped = newcclosure and newcclosure(function(...) return Callback(...) end) or Callback
                pcall(function() setcb(Remote, "OnClientInvoke", Wrapped) end)
            end

            task.wait(0.5)
            sigma()
        end)
    end)
end)
