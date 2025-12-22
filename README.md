server.lua

----------------------------------------------------
-- INVENTÁRIO + LOOT (SERVER)
-- VERSÃO ESTÁVEL / BACKUP SEGURO
----------------------------------------------------

-- CARREGAR SISTEMA DE LOOT DO MAPA
dofile("loot.lua")

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
-- ABRIR / PEGAR / FECHAR LOOT
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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
-- ANIMAÇÃO SEGURA (NUNCA TRAVA)
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

    -- EQUIPAR ARMA (NOVA ANIMAÇÃO)
    if source == GUIEditor.button[1] and item and item.categoria == "ARMAS" then
        playAnim("COLT45","colt45_reload",1200)
        setTimer(function()
            triggerServerEvent("inventario:equipar", localPlayer, item)
        end,1200,1)

    -- DESEQUIPAR ARMA (SÓ SE TIVER ARMA)
    elseif source == GUIEditor.button[5] then

        if not getElementData(localPlayer, "arma:equipada") then return end

        playAnim("PED","phone_in",1000)
        setTimer(function()
            triggerServerEvent("inventario:desequipar", localPlayer)
        end,1000,1)

    -- USAR ITEM
    elseif source == GUIEditor.button[2] and item and item.categoria == "COMIDAS" then
        playAnim("FOOD","EAT_Burger",1500)
        setTimer(function()
            triggerServerEvent("inventario:usar", localPlayer, item)
        end,1500,1)

    -- DROPAR ITEM
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
-- PEGAR ITEM DO LOOT (RÁPIDO)
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

loot.lua

----------------------------------------------------
-- LOOT SPAWN SYSTEM
----------------------------------------------------

LootSystem = {}

----------------------------------------------------
-- PERFIS DE LOOT
----------------------------------------------------
LootSystem.perfis = {

    LANCHONETE = {
        maxItens = 3,
        chanceVazio = 20,
        categorias = {
            COMIDAS = 60,
            BEBIDAS = 60,
            ARMAS   = 5,
            OUTROS  = 35
        }
    },

    DELEGACIA = {
        maxItens = 4,
        chanceVazio = 10,
        categorias = {
            ARMAS   = 50,
            COMIDAS = 30,
            BEBIDAS = 20,
            OUTROS  = 20
        }
    }
}

----------------------------------------------------
-- ITENS DISPONÍVEIS
----------------------------------------------------
LootSystem.itens = {

    COMIDAS = {
        { nome = "PAO", min = 1, max = 2 }
    },

    BEBIDAS = {
        { nome = "AGUA", min = 1, max = 2 }
    },

    ARMAS = {
        { nome = "FACA", min = 1, max = 1 }
    },

    OUTROS = {
        { nome = "ISQUEIRO", min = 1, max = 1 }
    }
	
	
}

----------------------------------------------------
-- CORDENADAS DOS LOOTS
----------------------------------------------------
LootSystem.spawns = {
    { x = -2414.3,   y = -600.954, z = 132.562, perfil = "LANCHONETE" },
    { x = -2421.626, y = -606.013, z = 132.562, perfil = "LANCHONETE" }
}

----------------------------------------------------
-- FUNÇÕES
----------------------------------------------------
local function sortearCategoria(categorias)
    local total = 0
    for _,v in pairs(categorias) do total = total + v end

    local r = math.random(1,total)
    local soma = 0

    for cat,chance in pairs(categorias) do
        soma = soma + chance
        if r <= soma then return cat end
    end
end

function LootSystem.gerarItens(perfilNome)

    local perfil = LootSystem.perfis[perfilNome]
    if not perfil then return {} end

    if math.random(100) <= perfil.chanceVazio then
        return {}
    end

    local itens = {}
    local qtd = math.random(1, perfil.maxItens)

    for i=1,qtd do
        local categoria = sortearCategoria(perfil.categorias)
        local lista = LootSystem.itens[categoria]

        if lista then
            local base = lista[math.random(#lista)]
            table.insert(itens,{
                nome = base.nome,
                categoria = categoria,
                qtd = math.random(base.min, base.max)
            })
        end
    end

    return itens
end

----------------------------------------------------
-- SPAWNAR LOOTS NO MAPA
----------------------------------------------------
function LootSystem.spawnar(loots, lootID)

    for _,info in ipairs(LootSystem.spawns) do

        local obj = createObject(2358, info.x, info.y, info.z - 0.9)
        setElementFrozen(obj,true)

        lootID.value = lootID.value + 1
        local id = lootID.value

        loots[id] = {
            object = obj,
            aberto = false,
            itens = LootSystem.gerarItens(info.perfil)
        }

        setElementData(obj,"loot:id",id)
    end
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

meta.xml

<meta>
    <info author="Miranda_ZX" name="Inventário + Loot" type="script" />

    <script src="server.lua" type="server" />
    <script src="loot.lua" type="server" />
    <script src="client.lua" type="client" />
</meta>
