Config = {}
Config.Unemployed = 'Unemployed'

Config.JobSpecs = {
    ['bahama'] = 'bar',
    ['arcade'] = 'bar',
    ['yellowjack'] = 'bar',
    ['unicorn'] = 'bar',
    ['bennys'] = 'mechanic',
    ['esc'] = 'mechanic',
    ['vgsd'] = 'mechanic',
    ['palcar'] = 'mechanic',
    ['lsc'] = 'mechanic',
    ['thelostmc'] = 'mechanic',
    ['lamesa'] = 'restaurant',
    ['namaste'] = 'restaurant'
}

Config.markers = {
    bahama = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = -450.72497558594, ['y'] = 6011.150390625, ['z'] = 31.716451644898
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -451.65762329102, ['y'] = 6014.5087890625, ['z'] = 31.716449737548
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1390.90, ['y'] = -605.7, ['z'] = 29.80
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1378.37, ['y'] = -617.19, ['z'] = 36.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1391.96, ['y'] = -620.16, ['z'] = 36.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    garbage = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -321.70, ['y'] = -1545.94, ['z'] = 30.02
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00-- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    arcade = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1378.37, ['y'] = -617.19, ['z'] = 36.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 740.56, ['y'] = -813.82, ['z'] = 7.20
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    bennys = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = -206.804779, ['y'] = -1331.245850, ['z'] = 34.894424
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -208.1, ['y'] = -1341.99, ['z'] = 33.89
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -224.37, ['y'] = -1320.21, ['z'] = 29.89
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -203.84, ['y'] = -1334.02, ['z'] = 33.89
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    blackrock = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -788.96, ['y'] = -216.05, ['z'] = 37.08
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    bondurmans = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 95.43, ['y'] = 6356.8, ['z'] = 40.4
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 97.35, ['y'] = 6353.79, ['z'] = 40.0
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 87.94, ['y'] = 6355.54, ['z'] = 40.0
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    government = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = -551.18, ['y'] = -187.01, ['z'] = 38.22
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -541.33, ['y'] = -193.58, ['z'] = 47.42
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -576.2, ['y'] = -147.71, ['z'] = 37.75
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    lamesa = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 361.06, ['y'] = -342.78, ['z'] = 45.37
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 366.39, ['y'] = -335.37, ['z'] = 45.78
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 371.55, ['y'] = -334.60, ['z'] = 47.11
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    lsc = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -345.52, ['y'] = -123.01, ['z'] = 39.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -322.03, ['y'] = -140.87, ['z'] = 39.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -347.54, ['y'] = -133.19, ['z'] = 39.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    airseal = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -950.18, ['y'] = -3056.48, ['z'] = 13.35
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -929.15, ['y'] = -140.87, ['z'] = 39.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -941.16, ['y'] = -2954.04, ['z'] = 19.25
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    malleventservices = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -635.40, ['y'] = 233.54, ['z'] = 81.48
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -634.66, ['y'] = 225.67, ['z'] = 81.40
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -632.56, ['y'] = 226.05, ['z'] = 81.40
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    namaste = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -172.35, ['y'] = 308.02, ['z'] = 96.99
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -176.42, ['y'] = 301.06, ['z'] = 99.92
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -147.41, ['y'] = 295.92, ['z'] = 97.98
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    palcar = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 103.07, ['y'] = 6617.74, ['z'] = 31.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 109.05, ['y'] = 6631.55, ['z'] = 30.79
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 100.07, ['y'] = 6620.27, ['z'] = 31.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    pointview = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 2465.81, ['y'] = 4088.75, ['z'] = 31.44
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 2467.05, ['y'] = 4088.13, ['z'] = 37.04
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 2477.17, ['y'] = 4109.69, ['z'] = 40.64
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    ponsonbys = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 481.15, ['y'] = -1325.59, ['z'] = 29.21
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -170.96, ['y'] = -296.49, ['z'] = 39.13
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -165.07, ['y'] = -303.43, ['z'] = 39.73
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    salonlux = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -808.4, ['y'] = -179.7, ['z'] = 37.07
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -808.4, ['y'] = -181.95, ['z'] = 37.07
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -823.59, ['y'] = -184.3, ['z'] = 37.07
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    scrapr = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -591.04, ['y'] = -1627.37, ['z'] = 33.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -571.88, ['y'] = -1611.59, ['z'] = 27.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -617.53, ['y'] = -1622.83, ['z'] = 33.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    thelostmc = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 997.04, ['y'] = -122.74, ['z'] = 73.06
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 986.86, ['y'] = -92.55, ['z'] = 73.85
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 989.59, ['y'] = -136.45, ['z'] = 73.07
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    unicorn = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 135.478, ['y'] = -1288.615, ['z'] = 28.289
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 106.53, ['y'] = -1298.82, ['z'] = 27.77
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 105.111, ['y'] = -1303.221, ['z'] = 27.788
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1556.38, ['y'] = -574.44, ['z'] = 107.54
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    vgsd = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 978.29, ['y'] = -1833.77, ['z'] = 35.19
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 420.27, ['y'] = -2057.52, ['z'] = 22.28 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 965.90, ['y'] = -1851.80, ['z'] = 30.83
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 105.111, ['y'] = -1303.221, ['z'] = 27.788
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1833.34, ['y'] = -1833.34, ['z'] = 30.86
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    vinice = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1858.75, ['y'] = 2059.7, ['z'] = 135.46
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1900.07, ['y'] = 2079.54, ['z'] = 135.92
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1928.95, ['y'] = 2059.61, ['z'] = 140.24
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -1875.52, ['y'] = 2062.35, ['z'] = 145.27
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    weazelnews = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -585.17, ['y'] = -933.47, ['z'] = 22.87
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -583.53, ['y'] = -937.69, ['z'] = 22.87
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -583.42, ['y'] = -928.79, ['z'] = 27.16
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    esc = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 725.18, ['y'] = -1078.72, ['z'] = 21.80
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 747.45, ['y'] = -1091.25, ['z'] = 21.80
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 726.7, ['y'] = -1066.94, ['z'] = 28.31
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    yellowjack = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 1985.55, ['y'] = 3048.95, ['z'] = 46.80
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 1987.77, ['y'] = 3046.48, ['z'] = 50.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 1995.76, ['y'] = 3046.24, ['z'] = 50.01
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    },

    blackcrown = {
        {
            ["name"] = "duty",
            ["grade"] = 1,
            ["label"] = "Sluzba",
            ["offduty"] = true,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
        },
        {
            ["name"] = "fridge",
            ["grade"] = 2,
            ["label"] = "Lednice",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -561.71, ['y'] = 289.78, ['z'] = 82.18
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "safe",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "vault",
            ["grade"] = 2,
            ["label"] = "Sklad",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -575.82, ['y'] = 291.42, ['z'] = 79.18
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "secretvault",
            ["grade"] = 2,
            ["label"] = "Trezor",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = 0.00, ['y'] = 0.00, ['z'] = 0.00 -- dodělat
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "cloakroom",
            ["grade"] = 2,
            ["label"] = "Prevlekarna",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -567.12, ['y'] = 279.99, ['z'] = 82.98
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        },
        {
            ["name"] = "bossmenu",
            ["grade"] = 4,
            ["label"] = "Boss menu",
            ["offduty"] = false,
            ["coords"] = {
                ['x'] = -568.57, ['y'] = 291.17, ['z'] = 79.18
            },
            ["distance"] = 15.0,
            ['range'] = 2.0
        }
    }
}