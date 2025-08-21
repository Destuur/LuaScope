LuaScope = LuaScope or {}

System.LogAlways("Initializing LuaScope...")
UIAction.RegisterEventSystemListener(LuaScope, "System", "OnGameplayStarted", "OnGameplayStarted")
System.LogAlways("LuaScope: Registered OnGameplayStarted event listener.")

local timerDuration = 900000
local wrappedFunctions = {}
local visitedObjects = {}
local sampledParams = sampledParams or {}
local currentTrackingNamespace = nil
local availableNamespaces = {
    "Action",
    "ActionMapManager",
    "ActionTrigger",
    "Actor.CreateActor",
    "AI",
    "AISpawner",
    "Alchemy",
    "AlchemyItem",
    "AlchemyTable",
    "AnimChar",
    "AnimDoor",
    "AnimObjectBase",
    "Archery",
    "AreaBezierVolume",
    "AreaTrigger",
    "AudioAreaAmbience",
    "AudioAreaEntity",
    "AudioAreaRandom",
    "AudioTriggerSpot",
    "AudioUtils",
    "Barber",
    "Barbershop",
    "BasicAI",
    "BasicAIActions",
    "BasicAnimal",
    "Battlement",
    "Bed",
    "BedTrigger",
    "Birds",
    "BirdsTakeoff",
    "Blacksmithing",
    "Boar",
    "Boid",
    "Boids",
    "Book",
    "BreakableObject",
    "Breakage",
    "bxor",
    "Calendar",
    "CameraShake",
    "CameraSource",
    "CaptionObject",
    "CarryableItem",
    "CarryableItemBind",
    "CarryItemPile",
    "Cart",
    "CartStash",
    "CattleBull",
    "CattleCow",
    "Chair",
    "CharacterAttachHelper",
    "Chickens",
    "ChickensBrownLight",
    "ChickensWhite",
    "ChoppingBlock",
    "CIPileBind",
    "Cloth",
    "Cloud",
    "CombatDebug",
    "Comment",
    "Constraint",
    "CreateItemTable",
    "Crime",
    "CryAction",
    "DatabaseUtils",
    "DeadBody_Base_Human",
    "DeadBody_Horse",
    "DeadBody_Human",
    "DeadBody_WolfDog",
    "DeadBody",
    "Debris",
    "DestroStash",
    "DestroyableObject",
    "DetailMovementSmartObject",
    "DialogModule",
    "DialogState",
    "DialogUtils",
    "Dice",
    "DiceInteractor",
    "DiceMinigameCup",
    "Dog",
    "DogMarkingSpot",
    "DummyTarget",
    "Dump",
    "EntityCommon",
    "EntityModule",
    "EntityNamed",
    "EntityUtils",
    "EnvironmentLight",
    "EnvironmentModule",
    "EquipWeapon",
    "Explosion",
    "FastTravel",
    "FieldMouse",
    "FireplaceSmartObject",
    "Fish",
    "Flash",
    "Fog",
    "FogVolume",
    "FoodProcessingTrigger",
    "ForgeBuilder",
    "ForgeBuilderTrigger",
    "Game",
    "GameUtils",
    "GeomCache",
    "GeomEntity",
    "GhostDummy",
    "GhostsController",
    "Grindstone",
    "Hare",
    "Hazard",
    "Hen",
    "Hole",
    "HoleDigging",
    "Horse",
    "Horsetraders",
    "ImpressByPlayer",
    "IndulgenceBoxTrigger",
    "InteractionTrigger",
    "InteractiveObjectEx",
    "InventoryDummyDog",
    "InventoryDummyHorse",
    "InventoryDummyPlayer",
    "InventoryDummyPlayerFemale",
    "InventoryWeapon",
    "IsAnimal",
    "IsFemale",
    "ItemManager",
    "ItemSystem",
    "ItemUtils",
    "JointGen",
    "KettleActionTrigger",
    "Ladder",
    "Lamp",
    "LedgeObject",
    "LedgeObjectStatic",
    "Light",
    "Lightning",
    "LocationPoint",
    "Lockpickable",
    "MaterialEffects",
    "Minigame",
    "MissileWeapon",
    "MissionObjective",
    "Movie",
    "MovingSmartObjectHolder",
    "NavigationSeedPoint",
    "NavigationUtils",
    "Negotiation",
    "NegotiationOrientation",
    "NegotiationProposition",
    "NegotiationUtils",
    "Nest",
    "Net",
    "NPC_Female",
    "NPC_NAI",
    "NPC",
    "NullAI",
    "OnInit",
    "OnShutdown",
    "os",
    "package",
    "Particle",
    "Physics",
    "Pick",
    "PickableArea",
    "Pig",
    "player.actor",
    "player.human",
    "player.inventory",
    "player.player",
    "player.soul",
    "player",
    "PlayerFemale",
    "PlayerStateHandler",
    "PlayerWeapon",
    "PrecacheCamera",
    "PredefinedNavigationPath",
    "PressurizedObject",
    "PrismObject",
    "ProximityTrigger",
    "Rain",
    "Rats",
    "RecipesBook",
    "RedDeerDoe",
    "RedDeerStag",
    "ReflexLight",
    "RigidBody",
    "RoeDeerBuck",
    "RoeDeerHind",
    "RopeEntity",
    "RPG",
    "ScriptCommand",
    "SequenceArea",
    "SequenceObject",
    "SequenceTrigger",
    "SetupBribe",
    "SetupHaggle",
    "Sharpening",
    "SheepEwe",
    "SheepRam",
    "ShootingContest",
    "ShootingTarget",
    "ShootingTargetOld",
    "Shop",
    "Shops",
    "SimpleBribeTransaction",
    "SkillCheck",
    "SkipTime",
    "SmartAreaShape",
    "SmartObject",
    "SmartObjectCondition",
    "SmartObjectTrigger",
    "Smithery",
    "SO_ActionSettings",
    "SO_AnimationAndBark",
    "SO_CheeringSpot_Leaning",
    "SO_CheeringSpot_Standing",
    "SO_DeadBody_Horse",
    "SO_DeadBody_Human_Hanged",
    "SO_DeadBody_Human_Interactable",
    "SO_DeadBody_Human",
    "SO_DeadBody_WolfDog",
    "SO_DiggingSpot",
    "SO_HostageSituation",
    "SO_LeaningRail",
    "SO_LyingHarmed_Healing",
    "SO_LyingHarmed_Wounded",
    "SO_LyingHarmed",
    "SO_Party_Duo_Sitting",
    "SO_Party_Duo_Standing",
    "SO_Party_Lying",
    "SO_Party_Sitting",
    "SO_Party_Standing",
    "SO_SpecialSittingActivity",
    "SO_TrackviewMessage",
    "SO_WaitingSpot",
    "SocialClass",
    "Sound",
    "SpawnEnemy",
    "SpawnFriend",
    "SpawnGroup",
    "SpawnPoint",
    "SpeedLimiter",
    "StanceSmartObject",
    "Startup",
    "StashCorpse",
    "StashInventoryCollector",
    "StashInventoryGenerator",
    "Statistics",
    "StoneThrowing",
    "StoneThrowingPile",
    "System",
    "ThreatenByPlayer",
    "Torch",
    "TranscriptionTable",
    "UI",
    "UIAction",
    "UIApseLinkNode",
    "UIForgeBuilderLinkNode",
    "UIShopLinkNode",
    "Variables",
    "VectorUtils",
    "ViewDist",
    "VolumeObject",
    "WaterPuddle",
    "WaterTubeActionTrigger",
    "WaterVolume",
    "WHCart",
    "WHCartMountPoint",
    "WildDog",
    "Wind",
    "WindArea",
    "Wolf",
    "XGenAIModule"
}

function LuaScope.OnGameplayStarted(actionName, eventName, argTable)
    LuaScope.Cmd()
    Script.SetTimer(timerDuration, LuaScope.Dump)
end

--- <summary>
--- Wraps a C function to log its arguments on each call.
--- Prevents double-wrapping and stores the original function for restoration.
--- </summary>
--- <param name="name">The full name (including namespace) of the function.</param>
--- <param name="func">The original function to wrap.</param>
--- <returns>The wrapped function.</returns>
local function WrapCFunction(name, func)
    if wrappedFunctions[name] then
        return wrappedFunctions[name]
    end

    local wrapper = function(...)
        local args = {...}
        local sigKey = name .. "|paramCount:" .. #args

        if not sampledParams[sigKey] then
            sampledParams[sigKey] = args
            System.LogAlways(string.format("[LuaScope] %s | first call paramCount: %d", name, #args))
        end

        return func(...)
    end

    wrappedFunctions[name] = { wrapper = wrapper, original = func }
    return wrapper
end


--- <summary>
--- Retrieves a global object by a dot-separated string path.
--- Example: "player.actor" returns _G.player.actor.
--- </summary>
--- <param name="path">Dot-separated string path to the global object.</param>
--- <returns>The referenced object, or nil if not found.</returns>
local function GetGlobalFromString(path)
    if type(path) ~= "string" then return nil end
    local obj = _G
    for part in string.gmatch(path, "[%w_]+") do
        obj = obj and obj[part]
    end
    return obj
end

--- <summary>
--- Recursively explores a namespace (table or userdata), wrapping all C functions found.
--- Prevents infinite loops by tracking visited objects.
--- </summary>
--- <param name="name">The name of the namespace (for logging).</param>
--- <param name="obj">The object/table to explore.</param>
--- <param name="depth">Maximum recursion depth.</param>
local function ExploreNamespace(name, obj, depth)
    if visitedObjects[obj] then return end
    visitedObjects[obj] = true

    local t = type(obj)
    if t ~= "table" and t ~= "userdata" then return end

    if t == "table" then
        for k, v in pairs(obj) do
            local keyName = tostring(k)
            local valueType = type(v)

            if valueType == "function" then
                local status, info = pcall(debug.getinfo, v)
                if not (status and info and info.what == "Lua") then
                    obj[k] = WrapCFunction(name .. "." .. keyName, v)
                end
            elseif valueType == "table" and depth > 1 then
                ExploreNamespace(name .. "." .. keyName, v, depth - 1)
            end
        end
    end

    local mt = getmetatable(obj)
    if mt and mt.__index and depth > 0 then
        local idx = mt.__index
        if type(idx) == "table" or type(idx) == "userdata" then
            ExploreNamespace(name .. ".__index", idx, depth - 1)
        end
    end
end

--- <summary>
--- Console command entry point.
--- Starts tracking all C functions in the given namespace or object.
--- </summary>
--- <param name="arg1">String path to a namespace or a direct object reference.</param>
function LuaScope.Cmd(arg1)
    local name, obj

    if currentTrackingNamespace and arg1 == currentTrackingNamespace then
        System.LogAlways("[LuaScope] Already tracking: " .. tostring(arg1))
    elseif not arg1 or arg1 == "" then
        local randomIndex = math.random(1, #availableNamespaces)
        name = availableNamespaces[randomIndex]
        System.LogAlways("[LuaScope] No namespace given, randomly selected: " .. name)
    elseif type(arg1) == "string" then
        name = arg1
    else
        name = "<object:" .. tostring(arg1) .. ">"
    end

    obj = GetGlobalFromString(name)
    if not obj then
        System.LogAlways("[LuaScope] ERROR: Namespace not found -> " .. tostring(name))
        return
    end

    if currentTrackingNamespace and currentTrackingNamespace ~= name then
        LuaScope.Clear()
    end
    currentTrackingNamespace = name

    local depth = 1
    ExploreNamespace(name, obj, depth)
    System.LogAlways("[LuaScope] Now tracking: " .. tostring(name) .. " (depth=" .. depth .. ")")
end

--- <summary>
--- Dumps all tracked function calls and their parameters to the log.
--- Recursively prints tables and handles userdata.
--- </summary>
function LuaScope.Dump()
    if not next(sampledParams) then
        System.LogAlways("[LuaScope] No sampled parameters to display.")
        Script.SetTimer(timerDuration, LuaScope.Dump)
        return
    end
    for sig, args in pairs(sampledParams) do
        System.LogAlways(string.format("[LuaScope] %s | paramCount: %d", sig, #args))

        local function dumpTable(t, indent)
            indent = indent or 1
            local prefix = string.rep("  ", indent)
            local parts = {}
            for k, v in pairs(t) do
                local valStr
                if type(v) == "table" then
                    valStr = dumpTable(v, indent+1)
                elseif type(v) == "userdata" then
                    valStr = "userdata: " .. tostring(v)
                else
                    valStr = tostring(v)
                end
                table.insert(parts, prefix .. tostring(k) .. " = " .. valStr)
            end
            return "{\n" .. table.concat(parts, "\n") .. "\n" .. string.rep("  ", indent-1) .. "}"
        end

        for i, p in ipairs(args) do
            local paramStr
            if type(p) == "table" then
                paramStr = dumpTable(p)
            elseif type(p) == "userdata" then
                paramStr = "userdata: " .. tostring(p)
            else
                paramStr = tostring(p)
            end

            System.LogAlways(string.format("  Param %d: %s", i, paramStr))
        end
    end
    Script.SetTimer(timerDuration, LuaScope.Dump)
end


--- <summary>
--- Restores all wrapped functions to their original state and clears all tracked data.
--- </summary>
function LuaScope.Clear()
    for originalName, wrapper in pairs(wrappedFunctions) do
        local parts = {}
        for part in string.gmatch(originalName, "[%w_]+") do
            table.insert(parts, part)
        end
        local obj = _G
        for i = 1, #parts-1 do
            obj = obj and obj[parts[i]]
        end
        if obj and wrapper.original then
            obj[parts[#parts]] = wrapper.original
        end
    end

    wrappedFunctions = {}
    sampledParams = {}
    visitedObjects = {}
    currentTrackingNamespace = nil
    System.LogAlways("[LuaScope] Cleared all tracked data and reset state.")
end


System.AddCCommand("LuaScope", "LuaScope.Cmd()", "Tracks a namespace. Usage: LuaScope <NamespacePath> e.g. LuaScope player.actor")
System.AddCCommand("LuaDump", "LuaScope.Dump()", "Print all tracked function calls")
System.AddCCommand("LuaClear", "LuaScope.Clear()", "Clear tracked data")

System.LogAlways("LuaScope initialized!")