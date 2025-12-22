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
