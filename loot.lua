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
