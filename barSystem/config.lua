Config = {}
Config.Wait = 60000 * 30
Config.CraftTime = 200
Config.Debug = true
Config.setup_scriptHandlerName = 'barSystem'

Config.Categories = {
    "Beverages",
    "Alcohol",
    "Drinks",
    "Food"
}

Config.Price = {
    ["restaurant_menu"] = 500,
    ["alcohol_menu"] = 1000
}


Config.Menus = {
    ['namaste'] = {
        Img = 'img/namaste.png',
        Rest = 'Dragon Temple'
    },
    ['bahama'] = {
        Img = 'img/default.png',
        Rest = 'Bahama Mamas'
    }
}

Config.PapersPlease = vector3(66.55, -803.66, 31.53)