-- ══════════════════════════════════════════════════════════════
--  TAB: MÚSICA (REFATORADA)
-- ══════════════════════════════════════════════════════════════
local MGL = Tabs.Music:AddLeftGroupbox("Player de Música", "music")
MGL:AddLabel("Tocando: None", true, "NowPlaying")

-- Campo para Asset ID
MGL:AddInput("MusicURL", {
    Text = "Asset ID / rbxassetid://",
    Placeholder = "ex: 9120381428",
    ClearTextOnFocus = false,
    Callback = function() end
})
MGL:AddInput("MusicTitle", {
    Text = "Título Personalizado",
    Placeholder = "opcional",
    ClearTextOnFocus = false,
    Callback = function() end
})
MGL:AddButton({ Text = "▶  Tocar URL", Func = function()
    local url = getOpt("MusicURL", "")
    local title = getOpt("MusicTitle", "")
    if url == "" then
        notify("Música", "Digite um Asset ID.")
        return
    end
    playMusic(url, title)
end })

-- Arquivos locais
MGL:AddDivider()
MGL:AddLabel("Arquivos locais (pasta R3dHub/Music):")

-- Dropdown para selecionar arquivo local
local musicFiles = scanMusicFolder()
local fileOptions = #musicFiles > 0 and musicFiles or { "Nenhum arquivo" }
MGL:AddDropdown("LocalMusicFile", {
    Values = fileOptions,
    Default = 1,
    Text = "Selecione um arquivo",
    Callback = function() end
})

MGL:AddButton({ Text = "▶ Tocar Selecionado", Func = function()
    local selected = getOpt("LocalMusicFile")
    if not selected or selected == "Nenhum arquivo" then
        notify("Música", "Selecione um arquivo válido.")
        return
    end
    playMusic(selected, selected)
end })

MGL:AddButton({ Text = "🔄 Recarregar Lista", Func = function()
    local newFiles = scanMusicFolder()
    if #newFiles == 0 then
        Options.LocalMusicFile:SetValues({ "Nenhum arquivo" })
        Options.LocalMusicFile:SetValue("Nenhum arquivo")
    else
        Options.LocalMusicFile:SetValues(newFiles)
        Options.LocalMusicFile:SetValue(newFiles[1])
    end
    notify("Música", "Lista recarregada.", 2)
end })

MGL:AddDivider()
MGL:AddButton({ Text = "⏹ Parar", Func = stopMusic })
MGL:AddSlider("MusicVolume", {
    Text = "Volume",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Suffix = "%",
    Callback = function(v) setMusicVolume(v) end
})

local MGR = Tabs.Music:AddRightGroupbox("Uso", "info")
MGR:AddLabel([[Digite um Asset ID do Roblox (apenas números) ou rbxassetid://...

Para arquivos locais, coloque-os na pasta R3dHub/Music (MP3, OGG, WAV) e use o dropdown acima.]], false)
