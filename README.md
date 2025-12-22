meta.xml

<meta>
    <info
        author="MirandazxBR"
        name="[SCRIPT] Inventario"
        version="1.0.0"
        description="Inventario, itens, armas e loot DAYZ"
        type="script"
    />

    <!-- shared -->
    <script src="items.lua" type="shared" />
    <script src="weapons.lua" type="shared" />

    <!-- server -->
    <script src="server.lua" type="server" />
    <script src="loot.lua" type="server" />

    <!-- client -->
    <script src="client.lua" type="client" />
</meta>

============================================================

items.lua

-- items.lua
-- Definição global de itens do servidor DAYZ
-- NÃO contém lógica, apenas dados
-- Pode ser usado no client e server

ITEMS = {

    -- =========================
    -- 🍖 COMIDAS
    -- =========================
    ["pao"] = {
        name = "Pão",
        type = "food",
        hunger = 5,
        stack = 10,
        rarity = "common"
    },

    ["pizza_fatia"] = {
        name = "Pizza (Fatia)",
        type = "food",
        hunger = 10,
        stack = 5,
        rarity = "common"
    },

    ["cachorro_quente"] = {
        name = "Cachorro-Quente",
        type = "food",
        hunger = 10,
        stack = 5,
        rarity = "common"
    },

    ["hamburguer"] = {
        name = "Hambúrguer",
        type = "food",
        hunger = 25,
        stack = 3,
        rarity = "uncommon"
    },

    ["carne_cozida"] = {
        name = "Carne Cozida",
        type = "food",
        hunger = 25,
        stack = 3,
        rarity = "uncommon"
    },

    ["pizza_inteira"] = {
        name = "Pizza Inteira",
        type = "food",
        hunger = 50,
        stack = 2,
        rarity = "rare"
    },

    ["marmita"] = {
        name = "Marmita",
        type = "food",
        hunger = 50,
        stack = 2,
        rarity = "rare"
    },

    ["banquete"] = {
        name = "Banquete",
        type = "food",
        hunger = 100,
        stack = 1,
        rarity = "veryrare"
    },

    ["carne_crua"] = {
        name = "Carne Crua",
        type = "food",
        hunger = 10,
        diseaseChance = 30,
        stack = 5,
        rarity = "common"
    },

    -- =========================
    -- 🥤 BEBIDAS
    -- =========================
    ["agua"] = {
        name = "Água",
        type = "drink",
        thirst = 10,
        stack = 10,
        rarity = "common"
    },

    ["caldo_cana"] = {
        name = "Caldo de Cana",
        type = "drink",
        thirst = 10,
        stack = 5,
        rarity = "common"
    },

    ["suco"] = {
        name = "Suco",
        type = "drink",
        thirst = 25,
        stack = 5,
        rarity = "uncommon"
    },

    ["coca_cola"] = {
        name = "Coca-Cola",
        type = "drink",
        thirst = 25,
        stack = 5,
        rarity = "uncommon"
    },

    ["pepsi"] = {
        name = "Pepsi",
        type = "drink",
        thirst = 25,
        stack = 5,
        rarity = "uncommon"
    },

    ["cantil"] = {
        name = "Cantil Cheio",
        type = "drink",
        thirst = 100,
        stack = 1,
        rarity = "rare"
    },

    -- =========================
    -- 💉 REMÉDIOS
    -- =========================
    ["curativo"] = {
        name = "Curativo",
        type = "medical",
        health = 10,
        stack = 10,
        rarity = "common"
    },

    ["dipirona"] = {
        name = "Dipirona",
        type = "medical",
        health = 25,
        stack = 5,
        rarity = "uncommon"
    },

    ["kit_medico"] = {
        name = "Kit Médico",
        type = "medical",
        health = 100,
        useTime = 5000,
        stack = 1,
        rarity = "veryrare"
    },

    -- =========================
    -- 🎒 MOCHILAS
    -- =========================
    ["mochila_pequena"] = {
        name = "Mochila Pequena",
        type = "backpack",
        slots = 10,
        stack = 1,
        rarity = "common"
    },

    ["mochila_media"] = {
        name = "Mochila Média",
        type = "backpack",
        slots = 20,
        stack = 1,
        rarity = "uncommon"
    },

    ["mochila_grande"] = {
        name = "Mochila Grande",
        type = "backpack",
        slots = 30,
        stack = 1,
        rarity = "rare"
    },

    ["mochila_trilha"] = {
        name = "Mochila de Trilha",
        type = "backpack",
        slots = 35,
        stack = 1,
        rarity = "rare"
    },

    ["mochila_militar"] = {
        name = "Mochila Militar",
        type = "backpack",
        slots = 50,
        stack = 1,
        rarity = "veryrare"
    },

    -- =========================
    -- 🦺 COLETES
    -- =========================
    ["colete_leve"] = {
        name = "Colete Leve",
        type = "armor",
        protection = 10,
        stack = 1,
        rarity = "common"
    },

    ["colete_medio"] = {
        name = "Colete Médio",
        type = "armor",
        protection = 20,
        stack = 1,
        rarity = "uncommon"
    },

    ["colete_reforcado"] = {
        name = "Colete Reforçado",
        type = "armor",
        protection = 35,
        stack = 1,
        rarity = "rare"
    },

    ["colete_pesado"] = {
        name = "Colete Pesado",
        type = "armor",
        protection = 50,
        stack = 1,
        rarity = "rare"
    },

    ["colete_militar"] = {
        name = "Colete Militar",
        type = "armor",
        protection = 70,
        stack = 1,
        rarity = "veryrare"
    },

    -- =========================
    -- 🧱 MATERIAIS
    -- =========================
    ["tecido"] = { name = "Tecido", type = "material", stack = 50, rarity = "common" },
    ["madeira"] = { name = "Madeira", type = "material", stack = 50, rarity = "common" },
    ["metal"] = { name = "Metal", type = "material", stack = 30, rarity = "uncommon" },
    ["ferro"] = { name = "Ferro", type = "material", stack = 30, rarity = "uncommon" },
    ["vidro"] = { name = "Vidro", type = "material", stack = 20, rarity = "uncommon" },
    ["linha"] = { name = "Linha", type = "material", stack = 50, rarity = "common" },
    ["pedra"] = { name = "Pedra", type = "material", stack = 50, rarity = "common" },
    ["plastico"] = { name = "Plástico", type = "material", stack = 50, rarity = "common" },

    -- =========================
    -- 🔧 ACESSÓRIOS
    -- =========================
    ["binoculos"] = { name = "Binóculos", type = "utility", stack = 1, rarity = "uncommon" },
    ["lanterna"] = { name = "Lanterna", type = "utility", stack = 1, rarity = "common" },
    ["visao_noturna"] = { name = "Visão Noturna", type = "utility", stack = 1, rarity = "veryrare" },
    ["panela"] = { name = "Panela", type = "utility", stack = 1, rarity = "common" },
    ["isqueiro"] = { name = "Isqueiro", type = "utility", stack = 1, rarity = "common" }

}

================================================================================================================

weapons.lua

-- weapons.lua
-- Definição de armas e munições
-- NÃO contém lógica

WEAPONS = {

    -- =========================
    -- 🔪 ARMAS BRANCAS
    -- =========================
    ["faca"] = {
        name = "Faca",
        weaponID = 4,
        ammo = false,
        stack = 1,
        rarity = "common"
    },

    ["bastao"] = {
        name = "Bastão",
        weaponID = 5,
        ammo = false,
        stack = 1,
        rarity = "common"
    },

    ["machado"] = {
        name = "Machado",
        weaponID = 15,
        ammo = false,
        stack = 1,
        rarity = "uncommon"
    },

    ["katana"] = {
        name = "Katana",
        weaponID = 8,
        ammo = false,
        stack = 1,
        rarity = "rare"
    },

    -- =========================
    -- 🔫 PISTOLAS
    -- =========================
    ["pistola_9mm"] = {
        name = "Pistola 9mm",
        weaponID = 22,
        ammo = "9mm",
        stack = 1,
        rarity = "common"
    },

    ["desert_eagle"] = {
        name = "Desert Eagle",
        weaponID = 24,
        ammo = ".50",
        stack = 1,
        rarity = "rare"
    },

    -- =========================
    -- 🔫 SMGs
    -- =========================
    ["uzi"] = {
        name = "Uzi",
        weaponID = 28,
        ammo = "9mm",
        stack = 1,
        rarity = "uncommon"
    },

    ["mp5"] = {
        name = "MP5",
        weaponID = 29,
        ammo = "9mm",
        stack = 1,
        rarity = "rare"
    },

    ["tec9"] = {
        name = "TEC-9",
        weaponID = 32,
        ammo = "9mm",
        stack = 1,
        rarity = "uncommon"
    },

    -- =========================
    -- 🔫 RIFLES
    -- =========================
    ["ak47"] = {
        name = "AK-47",
        weaponID = 30,
        ammo = "7.62",
        stack = 1,
        rarity = "rare"
    },

    ["m4"] = {
        name = "M4",
        weaponID = 31,
        ammo = "5.56",
        stack = 1,
        rarity = "veryrare"
    },

    -- =========================
    -- 🎯 SNIPERS
    -- =========================
    ["rifle_caca"] = {
        name = "Rifle de Caça",
        weaponID = 33,
        ammo = ".308",
        stack = 1,
        rarity = "rare"
    },

    ["sniper_militar"] = {
        name = "Sniper Militar",
        weaponID = 34,
        ammo = ".50",
        stack = 1,
        rarity = "veryrare"
    }
}

AMMO = {

    ["9mm"] = {
        name = "Munição 9mm",
        stack = 100,
        rarity = "common"
    },

    ["5.56"] = {
        name = "Munição 5.56",
        stack = 60,
        rarity = "rare"
    },

    ["7.62"] = {
        name = "Munição 7.62",
        stack = 60,
        rarity = "rare"
    },

    [".50"] = {
        name = "Munição .50",
        stack = 30,
        rarity = "veryrare"
    },

    [".308"] = {
        name = "Munição .308",
        stack = 40,
        rarity = "rare"
    }
}

====================================================================

server.lua

----------------------------------------------------
-- INVENTÁRIO + LOOT (SERVER)
-- VERSÃO ESTÁVEL / BACKUP SEGURO
----------------------------------------------------

local inventarios = {}
local loots = {}
local lootID = 0

----------------------------------------------------
-- CRIAR INVENTÁRIO BASE
----------------------------------------------------
local function criarInventario(player)

    inventarios[player] = {

        ARMAS = {
            { nome = "AK", qtd = 1 },
        },

        COMIDAS = {
            { nome = "PAO", qtd = 2 },
        },

        REMEDIOS = {},

        OUTROS = {}
    }
end

----------------------------------------------------
-- PLAYER JOIN / QUIT
----------------------------------------------------
addEventHandler("onPlayerJoin", root, function()
    criarInventario(source)
end)

addEventHandler("onPlayerQuit", root, function()
    inventarios[source] = nil
end)

----------------------------------------------------
-- FUNÇÃO: ADICIONAR ITEM
----------------------------------------------------
local function adicionarItem(player, categoria, nome, qtd)

    if not inventarios[player] then return end
    if not inventarios[player][categoria] then return end

    for _, item in ipairs(inventarios[player][categoria]) do
        if item.nome == nome then
            item.qtd = item.qtd + qtd
            return
        end
    end

    table.insert(inventarios[player][categoria], {
        nome = nome,
        qtd = qtd
    })
end

----------------------------------------------------
-- FUNÇÃO: REMOVER ITEM
----------------------------------------------------
local function removerItem(player, categoria, nome, qtd)

    if not inventarios[player] then return false end
    if not inventarios[player][categoria] then return false end

    for i, item in ipairs(inventarios[player][categoria]) do
        if item.nome == nome then
            item.qtd = item.qtd - qtd

            if item.qtd <= 0 then
                table.remove(inventarios[player][categoria], i)
            end

            return true
        end
    end

    return false
end

----------------------------------------------------
-- ENVIAR INVENTÁRIO AO CLIENT
----------------------------------------------------
addEvent("inventario:pedir", true)
addEventHandler("inventario:pedir", root, function()

    if not inventarios[source] then
        criarInventario(source)
    end

    triggerClientEvent(
        source,
        "inventario:receber",
        source,
        inventarios[source]
    )
end)

----------------------------------------------------
-- EQUIPAR ARMA
----------------------------------------------------
addEvent("inventario:equipar", true)
addEventHandler("inventario:equipar", root, function(item)

    if not item then return end
    if item.categoria ~= "ARMAS" then return end

    if not removerItem(source, "ARMAS", item.nome, 1) then
        return
    end

    takeAllWeapons(source)

    if item.nome == "AK" then
        giveWeapon(source, 30, 90, true)
        setElementData(source, "arma:equipada", "AK")
    end

    triggerClientEvent(
        source,
        "inventario:receber",
        source,
        inventarios[source]
    )
end)

----------------------------------------------------
-- DESEQUIPAR ARMA
----------------------------------------------------
addEvent("inventario:desequipar", true)
addEventHandler("inventario:desequipar", root, function()

    local arma = getElementData(source, "arma:equipada")
    if not arma then return end

    takeAllWeapons(source)
    adicionarItem(source, "ARMAS", arma, 1)
    setElementData(source, "arma:equipada", nil)

    triggerClientEvent(
        source,
        "inventario:receber",
        source,
        inventarios[source]
    )
end)

----------------------------------------------------
-- USAR ITEM
----------------------------------------------------
addEvent("inventario:usar", true)
addEventHandler("inventario:usar", root, function(item)

    if not item then return end

    if item.categoria == "COMIDAS" then
        if removerItem(source, item.categoria, item.nome, 1) then
            outputChatBox("Você comeu "..item.nome, source, 0, 255, 0)
        end
    end

    triggerClientEvent(
        source,
        "inventario:receber",
        source,
        inventarios[source]
    )
end)

----------------------------------------------------
-- DROPAR ITEM
----------------------------------------------------
addEvent("inventario:dropar", true)
addEventHandler("inventario:dropar", root, function(item)

    if not item then return end
    if not removerItem(source, item.categoria, item.nome, 1) then return end

    local x, y, z = getElementPosition(source)
    local ang = math.random() * math.pi * 2
    local dist = math.random(80,120)/100

    local dx = x + math.cos(ang)*dist
    local dy = y + math.sin(ang)*dist

    local obj = createObject(2358, dx, dy, z - 0.9)
    setElementFrozen(obj, true)

    lootID = lootID + 1
    loots[lootID] = {
        object = obj,
        aberto = false,
        itens = {
            { nome = item.nome, qtd = 1, categoria = item.categoria }
        }
    }

    setElementData(obj, "loot:id", lootID)

    triggerClientEvent(source,"inventario:receber",source,inventarios[source])
end)

----------------------------------------------------
-- LOOT
----------------------------------------------------
addEvent("loot:abrir", true)
addEventHandler("loot:abrir", root, function(id)

    local loot = loots[id]
    if not loot or loot.aberto then return end

    loot.aberto = true
    triggerClientEvent(source,"loot:mostrar",source,id,loot.itens)
end)

addEvent("loot:pegar", true)
addEventHandler("loot:pegar", root, function(id,index)

    local loot = loots[id]
    if not loot then return end

    local item = loot.itens[index]
    if not item then return end

    adicionarItem(source,item.categoria,item.nome,1)
    table.remove(loot.itens,index)

    if #loot.itens == 0 then
        destroyElement(loot.object)
        loots[id] = nil
        triggerClientEvent(source,"loot:fechar",source)
    else
        triggerClientEvent(source,"loot:mostrar",source,id,loot.itens)
    end

    triggerClientEvent(source,"inventario:receber",source,inventarios[source])
end)

addEvent("loot:fechar", true)
addEventHandler("loot:fechar", root, function(id)
    if loots[id] then
        loots[id].aberto = false
    end
end)

----------------------------------------------------
-- SPAWN DE LOOT DO MAPA
----------------------------------------------------
addEventHandler("onResourceStart", resourceRoot, function()
    LootSystem.spawnar(loots, { value = lootID })
end)

================================================================================================

client.lua

----------------------------------------------------
-- INVENTÁRIO + LOOT (CLIENT) - ANIMAÇÕES AJUSTADAS
----------------------------------------------------

GUIEditor = { window = {}, gridlist = {}, button = {} }

local inventarioAberto = false
local lootAberto = false
local lootIDAtual = nil
local lootPertoID = nil
local lootEmProgresso = false

----------------------------------------------------
-- ANIMAÇÃO SEGURA
----------------------------------------------------
local function playAnim(block, anim, tempo)
    setPedAnimation(localPlayer, block, anim, tempo, false, false, false, false)
    setTimer(function()
        setPedAnimation(localPlayer)
    end, tempo, 1)
end

----------------------------------------------------
-- FECHAR LOOT
----------------------------------------------------
local function fecharLoot()
    lootAberto = false
    lootIDAtual = nil
    lootEmProgresso = false
    guiSetVisible(GUIEditor.window[2], false)
    showCursor(inventarioAberto)
end

----------------------------------------------------
-- GUI
----------------------------------------------------
addEventHandler("onClientResourceStart", resourceRoot, function()

    GUIEditor.window[1] = guiCreateWindow(477,149,400,343,"INVENTARIO",false)
    guiWindowSetSizable(GUIEditor.window[1], false)
    guiSetVisible(GUIEditor.window[1], false)

    GUIEditor.gridlist[1] = guiCreateGridList(10,30,260,300,false,GUIEditor.window[1])
    guiGridListAddColumn(GUIEditor.gridlist[1],"Item",0.4)
    guiGridListAddColumn(GUIEditor.gridlist[1],"Qtd",0.2)
    guiGridListAddColumn(GUIEditor.gridlist[1],"Categoria",0.3)

    GUIEditor.button[1] = guiCreateButton(280,60,100,40,"EQUIPAR",false,GUIEditor.window[1])
    GUIEditor.button[2] = guiCreateButton(280,110,100,40,"USAR",false,GUIEditor.window[1])
    GUIEditor.button[3] = guiCreateButton(280,160,100,40,"DROPAR",false,GUIEditor.window[1])
    GUIEditor.button[5] = guiCreateButton(280,210,100,40,"DESEQUIPAR",false,GUIEditor.window[1])

    GUIEditor.window[2] = guiCreateWindow(136,278,338,360,"LOOT",false)
    guiWindowSetSizable(GUIEditor.window[2], false)
    guiSetVisible(GUIEditor.window[2], false)

    GUIEditor.gridlist[2] = guiCreateGridList(10,30,250,310,false,GUIEditor.window[2])
    guiGridListAddColumn(GUIEditor.gridlist[2],"Item",0.4)
    guiGridListAddColumn(GUIEditor.gridlist[2],"Qtd",0.2)
    guiGridListAddColumn(GUIEditor.gridlist[2],"Categoria",0.3)

    GUIEditor.button[4] = guiCreateButton(270,150,50,40,">",false,GUIEditor.window[2])
end)

----------------------------------------------------
-- INVENTÁRIO TAB
----------------------------------------------------
bindKey("tab","down",function()
    inventarioAberto = not inventarioAberto
    guiSetVisible(GUIEditor.window[1], inventarioAberto)
    showCursor(inventarioAberto or lootAberto)

    if inventarioAberto then
        triggerServerEvent("inventario:pedir", localPlayer)
    end
end)

----------------------------------------------------
-- RECEBER INVENTÁRIO
----------------------------------------------------
addEvent("inventario:receber", true)
addEventHandler("inventario:receber", root, function(dados)

    if type(dados) ~= "table" then return end
    guiGridListClear(GUIEditor.gridlist[1])

    for categoria, itens in pairs(dados) do
        for _, item in ipairs(itens) do
            local row = guiGridListAddRow(GUIEditor.gridlist[1])
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 1, item.nome, false, false)
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 2, tostring(item.qtd), false, false)
            guiGridListSetItemText(GUIEditor.gridlist[1], row, 3, categoria, false, false)
        end
    end
end)

----------------------------------------------------
-- ITEM SELECIONADO
----------------------------------------------------
local function getItemSelecionado()
    local row = guiGridListGetSelectedItem(GUIEditor.gridlist[1])
    if row == -1 then return nil end

    return {
        nome = guiGridListGetItemText(GUIEditor.gridlist[1], row, 1),
        categoria = guiGridListGetItemText(GUIEditor.gridlist[1], row, 3)
    }
end

----------------------------------------------------
-- BOTÕES INVENTÁRIO
----------------------------------------------------
addEventHandler("onClientGUIClick", root, function()

    local item = getItemSelecionado()

    if source == GUIEditor.button[1] and item and item.categoria == "ARMAS" then
        playAnim("COLT45","colt45_reload",1200)
        setTimer(function()
            triggerServerEvent("inventario:equipar", localPlayer, item)
        end,1200,1)

    elseif source == GUIEditor.button[5] then
        if not getElementData(localPlayer, "arma:equipada") then return end
        playAnim("PED","phone_in",1000)
        setTimer(function()
            triggerServerEvent("inventario:desequipar", localPlayer)
        end,1000,1)

    elseif source == GUIEditor.button[2] and item and item.categoria == "COMIDAS" then
        playAnim("FOOD","EAT_Burger",1500)
        setTimer(function()
            triggerServerEvent("inventario:usar", localPlayer, item)
        end,1500,1)

    elseif source == GUIEditor.button[3] and item then
        playAnim("BOMBER","BOM_Plant",1200)
        setTimer(function()
            triggerServerEvent("inventario:dropar", localPlayer, item)
        end,1200,1)
    end
end)

----------------------------------------------------
-- DETECTAR LOOT
----------------------------------------------------
addEventHandler("onClientRender", root, function()

    lootPertoID = nil
    local px,py,pz = getElementPosition(localPlayer)

    for _, obj in ipairs(getElementsByType("object")) do
        local id = getElementData(obj, "loot:id")
        if id then
            local ox,oy,oz = getElementPosition(obj)
            if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) <= 2 then
                lootPertoID = id
                local sx,sy = getScreenFromWorldPosition(ox,oy,oz+0.6)
                if sx then
                    dxDrawText("Pressione E para lootear",
                        sx-150,sy,sx+150,sy,
                        tocolor(255,255,255),1,"default-bold","center")
                end
            end
        end
    end
end)

----------------------------------------------------
-- ABRIR LOOT
----------------------------------------------------
bindKey("e","down",function()

    if lootAberto then
        triggerServerEvent("loot:fechar", localPlayer, lootIDAtual)
        fecharLoot()
        return
    end

    if lootPertoID and not lootEmProgresso then
        lootEmProgresso = true
        playAnim("BOMBER","BOM_Plant",2000)

        setTimer(function()
            triggerServerEvent("loot:abrir", localPlayer, lootPertoID)
            lootEmProgresso = false
        end,2000,1)
    end
end)

----------------------------------------------------
-- MOSTRAR LOOT
----------------------------------------------------
addEvent("loot:mostrar", true)
addEventHandler("loot:mostrar", root, function(id, itens)

    lootAberto = true
    lootIDAtual = id
    guiSetVisible(GUIEditor.window[2], true)
    showCursor(true)

    guiGridListClear(GUIEditor.gridlist[2])

    for i,item in ipairs(itens) do
        local row = guiGridListAddRow(GUIEditor.gridlist[2])
        guiGridListSetItemText(GUIEditor.gridlist[2], row, 1, item.nome, false, false)
        guiGridListSetItemText(GUIEditor.gridlist[2], row, 2, tostring(item.qtd), false, false)
        guiGridListSetItemText(GUIEditor.gridlist[2], row, 3, item.categoria, false, false)
        guiGridListSetItemData(GUIEditor.gridlist[2], row, 1, i)
    end
end)

----------------------------------------------------
-- PEGAR ITEM DO LOOT
----------------------------------------------------
addEventHandler("onClientGUIClick", root, function()

    if source ~= GUIEditor.button[4] then return end
    local row = guiGridListGetSelectedItem(GUIEditor.gridlist[2])
    if row == -1 then return end

    playAnim("BOMBER","BOM_Plant",600)

    local index = guiGridListGetItemData(GUIEditor.gridlist[2], row, 1)
    setTimer(function()
        triggerServerEvent("loot:pegar", localPlayer, lootIDAtual, index)
    end,600,1)
end)

----------------------------------------------------
-- FECHAR LOOT SERVER
----------------------------------------------------
addEvent("loot:fechar", true)
addEventHandler("loot:fechar", root, fecharLoot)
