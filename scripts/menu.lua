local function ShowLogo()
    return [[
  __________________      __  ___
 /_  __/_  __/_  __/___ _/  |/  /
  / /   / /   / / / __ `/ /|_/ /
 / /   / /   / / / /_/ / /  / /
/_/   /_/   /_/  \__,_/_/  /_/
]]
end

local actions = {
    [1] = {
        name = "Start Bot",
        run = function()
            print("Starting bot...")
        end
    },
    [2] = {
        name = "Stop Bot",
        run = function()
            print("Stopping bot...")
        end
    },
    [3] = {
        name = "Restart Bot",
        run = function()
            print("Restarting bot...")
        end
    },
    [4] = {
        name = "Install",
        run = function()
            print("\nStarting Install")

            local scriptPath = debug.getinfo(1, "S").source:sub(2)
            local cwd = os.getenv("PWD") or "."

            if scriptPath:sub(1, 1) ~= "/" then
                scriptPath = cwd .. "/" .. scriptPath
            end

            local scriptDir = scriptPath:match("(.*/)")
            local projectRoot = scriptDir:gsub("/scripts/$", "")

            print(projectRoot)

            print("[0/???] cd'ing to project")
            os.execute(string.format([[
                cd %s && curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
            ]], projectRoot))
        end
    },
    [5] = {
        name = "View logs",
        run = function()
            print("Opening logs...")
        end
    },
    [6] = {
        name = "Exit",
        run = function()
            return false
        end
    }
}

local selected = 1

local function Main()
    local originalSettings = io.popen("stty -g"):read("*l")

    local function Restore()
        if originalSettings then
            os.execute("stty " .. originalSettings)
        end
    end

    os.execute("stty -echo -icanon min 1 time 0")

    local ok, err = pcall(function()
        while true do
            os.execute("clear")
            print(ShowLogo())

            for i, option in ipairs(actions) do
                print((i == selected and "> " or "  ") .. i .. ". " .. option.name)
            end

            io.write("\nUse Up/Down, 1-" .. #actions .. ", or Enter: ")
            io.flush()

            local key = io.read(1)

            if key == "\27" then
                io.read(1)
                local arrow = io.read(1)

                if arrow == "A" then
                    selected = (selected - 2) % #actions + 1
                elseif arrow == "B" then
                    selected = selected % #actions + 1
                end
            elseif key and tonumber(key) and actions[tonumber(key)] then
                selected = tonumber(key)
            elseif key == "\n" or key == "\r" then
                local result = actions[selected].run()

                if result == false then
                    break
                end

                io.write("\nPress any key to return...")
                io.flush()
                io.read(1)
            end
        end
    end)

    Restore()

    if not ok then
        error(err)
    end
end

Main()
