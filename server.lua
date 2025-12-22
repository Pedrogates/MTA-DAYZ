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
