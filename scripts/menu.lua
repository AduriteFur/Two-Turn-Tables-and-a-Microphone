local function ShowLogo()
    return [[
  __________________      __  ___
 /_  __/_  __/_  __/___ _/  |/  /
  / /   / /   / / / __ `/ /|_/ /
 / /   / /   / / / /_/ / /  / /
/_/   /_/   /_/  \__,_/_/  /_/
]]
end

local pkgManagers = {
    linuxmint = {
        command = "apt",
        install = "sudo apt install -y",
        luarocks = "luarocks",
        buildDeps = { "libsqlite3-dev", "build-essential" },
        docker = "docker.io",
        search = "apt-cache show docker.io"
    },
    mint = {
        command = "apt",
        install = "sudo apt install -y",
        luarocks = "luarocks",
        buildDeps = { "libsqlite3-dev", "build-essential" },
        docker = "docker.io",
        search = "apt-cache show docker.io"
    },
    ubuntu = {
        command = "apt",
        install = "sudo apt install -y",
        luarocks = "luarocks",
        buildDeps = { "libsqlite3-dev", "build-essential" },
        docker = "docker.io",
        search = "apt-cache show docker.io"
    },
    debian = {
        command = "apt",
        install = "sudo apt install -y",
        luarocks = "luarocks",
        buildDeps = { "libsqlite3-dev", "build-essential" },
        docker = "docker.io",
        search = "apt-cache show docker.io"
    },
    fedora = {
        command = "dnf",
        install = "sudo dnf install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite-devel", "gcc", "make" },
        docker = "moby-engine",
        search = "dnf info moby-engine"
    },
    arch = {
        command = "pacman",
        install = "sudo pacman -S --needed --noconfirm",
        luarocks = "luarocks",
        buildDeps = { "sqlite", "base-devel" },
        docker = "docker",
        search = "pacman -Si docker"
    },
    manjaro = {
        command = "pacman",
        install = "sudo pacman -S --needed --noconfirm",
        luarocks = "luarocks",
        buildDeps = { "sqlite", "base-devel" },
        docker = "docker",
        search = "pacman -Si docker"
    },
    alpine = {
        command = "apk",
        install = "sudo apk add",
        luarocks = "luarocks",
        buildDeps = { "sqlite-dev", "build-base", "lua5.1-dev" },
        runtimeDeps = { "ffmpeg", "yt-dlp" },
        luaVersion = "5.1",
        docker = "docker",
        search = "apk search -x docker"
    },
    opensuse = {
        command = "zypper",
        install = "sudo zypper install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite3-devel", "gcc", "make" },
        docker = "docker",
        search = "zypper search -s docker"
    },
    ["opensuse-leap"] = {
        command = "zypper",
        install = "sudo zypper install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite3-devel", "gcc", "make" },
        docker = "docker",
        search = "zypper search -s docker"
    },
    ["opensuse-tumbleweed"] = {
        command = "zypper",
        install = "sudo zypper install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite3-devel", "gcc", "make" },
        docker = "docker",
        search = "zypper search -s docker"
    },
    suse = {
        command = "zypper",
        install = "sudo zypper install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite3-devel", "gcc", "make" },
        docker = "docker",
        search = "zypper search -s docker"
    },
    solus = {
        command = "eopkg",
        install = "sudo eopkg install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite-devel", "gcc", "make" },
        docker = "docker",
        search = "eopkg info docker"
    },
    void = {
        command = "xbps-install",
        install = "sudo xbps-install -y",
        luarocks = "luarocks",
        buildDeps = { "sqlite-devel", "base-devel" },
        docker = "docker",
        search = "xbps-query -Rs docker"
    }
}

local function commandSuccess(ok, _, code)
    return ok == true or ok == 0 or code == 0
end

local function runPackageCommand(command)
    local process = io.popen("id -u 2>/dev/null")
    local uid = process and process:read("*l")

    if process then
        process:close()
    end

    if uid == "0" then
        command = command:gsub("^sudo%s+", "")
    end

    return os.execute(command)
end

local function shellQuote(value)
    return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

local function getOS()
    local file = io.open("/etc/os-release", "r")

    if not file then
        return nil, "Cannot read /etc/os-release"
    end

    local info = {}

    for line in file:lines() do
        local key, value = line:match("^([%w_]+)=(.*)$")

        if key then
            value = value:gsub('^"', ""):gsub('"$', "")
            value = value:gsub("^'", ""):gsub("'$", "")
            info[key] = value
        end
    end

    file:close()

    if not info.ID then
        return nil, "Could not determine distribution ID"
    end

    return {
        id = info.ID:lower(),
        like = info.ID_LIKE and info.ID_LIKE:lower() or ""
    }
end

local function getPackageManager(osInfo)
    if not osInfo then
        return nil
    end

    if pkgManagers[osInfo.id] then
        return pkgManagers[osInfo.id]
    end

    for distro in osInfo.like:gmatch("%S+") do
        if pkgManagers[distro] then
            return pkgManagers[distro]
        end
    end

    return nil
end

local function commandExists(command)
    local ok = os.execute("command -v " .. shellQuote(command) .. " >/dev/null 2>&1")
    return commandSuccess(ok)
end

local function installSystemPackages(manager, packages)
    if #packages == 0 then
        return true
    end

    local command = manager.install .. " " .. table.concat(packages, " ")
    local ok = runPackageCommand(command)

    return commandSuccess(ok)
end

local function dockerAvailable(manager)
    local ok = os.execute(manager.search .. " >/dev/null 2>&1")
    return commandSuccess(ok)
end

local function checkDocker(manager)
    print("[Docker] Checking installation...")

    if commandExists("docker") then
        print("[Docker] Already installed.")
        return true
    end

    print("[Docker] Not installed.")
    print("[Docker] Checking package repositories...")

    if dockerAvailable(manager) then
        print("[Docker] Available in repositories.")
        return false
    end

    print("[Docker] Not found in repositories.")
    return nil
end

local function installDocker(manager)
    print("[Docker] Installing " .. manager.docker .. "...")

    local ok = runPackageCommand(manager.install .. " " .. manager.docker)

    if commandSuccess(ok) then
        print("[Docker] Installation completed.")
        return true
    end

    print("[Docker] Installation failed.")
    return false
end


local function installLuaRocks(manager, projectRoot, packages)
    print("[LuaRocks] Checking installation...")

    if not commandExists("luarocks") then
        print("[LuaRocks] Not installed. Installing...")

        if not installSystemPackages(manager, { manager.luarocks }) then
            print("[LuaRocks] Failed to install LuaRocks.")
            return false
        end
    end

    if not commandExists("luarocks") then
        print("[LuaRocks] Installation could not be verified.")
        return false
    end

    print("[LuaRocks] Installing native build dependencies...")

    if not installSystemPackages(manager, manager.buildDeps) then
        print("[LuaRocks] Failed to install build dependencies.")
        return false
    end

    local depsDir = projectRoot .. "/deps"

    local mkdirStatus = os.execute("mkdir -p " .. shellQuote(depsDir))

    if not commandSuccess(mkdirStatus) then
        print("[LuaRocks] Failed to create deps directory.")
        return false
    end

    for _, package in ipairs(packages) do
        print("[LuaRocks] Installing " .. package .. " into deps...")

        local luaVersion = manager.luaVersion and ("--lua-version=" .. manager.luaVersion .. " ") or ""

        local command = string.format(
            "cd %s && luarocks %s--tree=%s install %s",
            shellQuote(projectRoot),
            luaVersion,
            shellQuote(depsDir),
            shellQuote(package)
        )

        local ok = os.execute(command)

        if not commandSuccess(ok) then
            print("[LuaRocks] Failed to install: " .. package)
            return false
        end
    end

    print("[LuaRocks] All packages installed into " .. depsDir)
    return true
end


local installSucceeded = false

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
            installSucceeded = false

            local source = debug.getinfo(1, "S").source
            local scriptPath = source:sub(1, 1) == "@" and source:sub(2) or source
            local cwd = os.getenv("PWD") or "."

            if scriptPath:sub(1, 1) ~= "/" then
                scriptPath = cwd .. "/" .. scriptPath
            end

            local scriptDir = scriptPath:match("^(.*[/])") or "./"
            local projectRoot = scriptDir:gsub("scripts/?$", "")

            if projectRoot == "" then
                projectRoot = "."
            end

            print("[Install] Project root: " .. projectRoot)

            local osInfo, err = getOS()

            if not osInfo then
                print("[Install] " .. tostring(err))
                return
            end

            local manager = getPackageManager(osInfo)

            if not manager then
                print("[Install] Unsupported distribution: " .. osInfo.id)
                return
            end

            if not commandExists(manager.command) then
                print("[Install] Package manager not found: " .. manager.command)
                return
            end

            if not commandExists("curl") then
                print("[Install] curl is required but was not found.")
                return
            end

            if manager.runtimeDeps then
                print("[System] Installing runtime dependencies...")
                if not installSystemPackages(manager, manager.runtimeDeps) then
                    print("[System] Failed to install runtime dependencies.")
                    return
                end
            end

            print("[0/4] Installing Lit")

            local litStatus = os.execute(string.format(
                "cd %s && curl -fL https://github.com/luvit/lit/raw/master/get-lit.sh -o get-lit.sh && sh get-lit.sh && rm -f get-lit.sh",
                shellQuote(projectRoot)
            ))

            if not commandSuccess(litStatus) then
                print("[Install] Failed to install Lit.")
                return
            end

            local litPath = projectRoot .. "/lit"

            if not commandExists("lit") then
                local file = io.open(litPath, "r")

                if not file then
                    print("[Install] Lit executable could not be found.")
                    return
                end

                file:close()
            end

            print("[1/4] Installing Lit packages")

            local packages = {
                "SinisterRectus/discordia",
                "Bilal2453/discordia-interactions",
                "Bilal2453/discordia-components",
                "GitSparTV/discordia-slash",
                "creationix/secure-socket",
                "creationix/sha1",
                "creationix/base64",
                "creationix/coro-channel",
                "creationix/coro-fs",
                "creationix/coro-http",
                "creationix/coro-net",
                "creationix/coro-websocket",
                "creationix/coro-wrapper",
                "creationix/http-codec",
                "luvit/json",
                "creationix/los",
                "luvit/pathjoin",
                "luvit/pretty-print",
                "luvit/fs",
                "luvit/timer",
                "creationix/resource",
                "creationix/websocket-codec"
            }

            for _, package in ipairs(packages) do
                print("[Lit] Installing " .. package .. "...")

                local command = string.format(
                    "cd %s && ./lit install %s",
                    shellQuote(projectRoot),
                    shellQuote(package)
                )

                local ok = os.execute(command)

                if not commandSuccess(ok) then
                    print("[Lit] Failed to install: " .. package)
                    return
                end
            end

            print("[2/4] Installing LuaRocks packages")

            local luarocksPackages = {
                "lsqlite3",
                "tinytoml"
            }

            if not installLuaRocks(manager, projectRoot, luarocksPackages) then
                return
            end

            if os.getenv("TTTAM_CONTAINER") == "1" then
                print("[3/4] Skipping Docker installation inside container.")
            else
                print("[3/4] Checking Docker")
                print("But first lemme get details of your machine")

                local dockerStatus = checkDocker(manager)

                if dockerStatus == true then
                    print("[Docker] Docker is already installed.")
                elseif dockerStatus == false then
                    print("[Docker] Docker is available. Installing...")

                    if not installDocker(manager) then
                        return
                    end
                else
                    print("[Docker] Docker is unavailable.")
                    return
                end
            end

            print("[4/4] Installation complete.")
            installSucceeded = true
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
    local terminal = io.popen("stty -g")
    local originalSettings = terminal and terminal:read("*l")

    if terminal then
        terminal:close()
    end

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

if arg and arg[1] == "--install" then
    actions[4].run()

    if not installSucceeded then
        os.exit(1)
    end
else
    Main()
end
