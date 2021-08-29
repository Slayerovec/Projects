Config              = {}
Config.license 		= true  --jenom koukaní na auta pokud nemáš licenci
Config.Collors 		= true
Config.Stats 		= true
Config.PlayersPlate = false
Config.ShowRoom 	= false

-- sellers ('a_m_m_business_01','a_m_y_business_01', 'a_m_y_business_02', 'a_m_y_business_03', 'a_m_y_cyclist_01',
-- 'a_f_y_business_01', 'a_f_y_business_02', 'a_f_y_business_03', 'a_f_y_business_04', 'ig_bankman', 'ig_barry',
-- 'ig_josh', 'ig_molly', 'ig_paper', 'ig_solomon', 's_m_m_movprem_01', 'u_f_y_jewelass_01'
--)

Config.debug        = {
	ambulance = 'emergency',
	police = 'emergency',
	marshal = 'emergency',
	fire = 'emergency',
	beeker = 'fraction_utility',
	thelostmc = 'fraction_utility',
	bennys = 'fraction_utility',
	esc = 'fraction_utility',
	vgsd = 'fraction_utility',
	pbc = 'fraction_utility',
	taxi = 'taxi',
	weazelnews = 'weazelnews',
}

Config.Zones = {

Premium_Deluxe_Motorsport = {
		Type  	 	= 'car',
		Permision 	= 'all',
		Category  	= {'compacts', 'coupes', 'muscle', 'dlcsum', 'offroad', 'sedans', 'utility', 'suvs', 'vans'},
		Enter 		= {
			[1]     = {
			Coord 		= {x = -57.00, y = -1097.22, z = 26.42, z2 = 26.02},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 206.22,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
			[2]     = {
			Coord 		= {x = -31.31, y = -1104.66, z = 26.42, z2 = 26.02},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 183.6,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
			[3]     = {
			Coord 		= {x = -32.07, y = -1112.64, z = 26.42, z2 = 26.02},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 210.0,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1]     = {
			hash  		= 'ig_molly',
			Coords 		= {x = -56.54, y = -1098.54, z = 26.42, h = 019.46},
			['Status'] = true
			},

		    [2]  	= {
			hash  		= 'ig_siemonyetarian',
			Coords 		= {x = -31.04, y = -1106.59, z = 26.42, h = 348.73},
			},
		    [3]  	= {
			hash  		= 'ig_bankman',
			Coords 		= {x = -31.98, y = -1113.8, z = 26.42, h = 024.73},
			},
		},
		View 		= {
			Pos     	= { x = -41.94, y = -1096.07, z = 26.43 },
			Heading 	= 274.0,
		},
		SpawnPoints = {
            { coords 	= vector3(-49.67, -1096.84, 26.42), heading = 288.01, radius = 2.0 },
            { coords 	= vector3(-48.28, -1101.41, 26.42), heading = 302.80, radius = 4.0 },
            { coords 	= vector3(-42.23, -1101.62, 26.42), heading = 294.00, radius = 4.0 },
            { coords 	= vector3(-36.59, -1101.85, 26.42), heading = 331.98, radius = 4.0 },
            { coords 	= vector3(-33.03, -1088.99, 26.42), heading = 287.99, radius = 4.0 },

		},
		SpawnPoint  = {
            coords 		= vector3(-45.05, -1081.90, 26.42), heading = 66.81
		},
		ShowRoom 	= {
			Active  	= true,
			SpawnPoints = {
			},
		},
	},

Sanders_Motorcycles = {
		Type  	  	= 'motorcycles',
		Permision 	= 'all',
		Category  	= {'motorcycles'},
		Enter 	  	= {
			[1]     = {
			Coord 		= {x = 285.58, y = -1163.3, z = 29.27, z2 = 28.67},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 193.5,
			Status 		= false,
			Text 		= '~s~Katalog motorek ~b~[E]~s~'
			},
			[2]     = {
			Coord 		= {x = 282.39, y = -1163.37, z = 29.27, z2 = 28.67},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 148.84,
			Status 		= false,
			Text 		= '~s~Katalog motorek ~b~[E]~s~'
			},
		},
		Seller 	  	= {
		    [1]  	= {
			hash  		= 'ig_barry',
			Coords 		= {x = 286.14, y = -1164.91, z = 29.27, h = 007.6},
			},
		  	[2]  	= {
			hash  		= 'ig_josh',
			Coords 		= {x = 281.64, y = -1164.94, z = 29.27, h = 319.39},
			},
		},
		View 	    = {
			Pos     	= { x = 294.42, y = -1158.01, z = 29.01 },
			Show3DText 	= false,
			Heading 	= 199.71
		},
		SpawnPoints = {
            { coords 	= vector3(317.59, -1166.30, 27.7), heading = 008.71, radius = 4.0 },
            { coords 	= vector3(314.27, -1166.85, 27.7), heading = 000.71, radius = 4.0 },
            { coords 	= vector3(310.57, -1166.88, 27.7), heading = 001.48, radius = 4.0 },
            { coords 	= vector3(307.53, -1166.87, 27.7), heading = 004.43, radius = 4.0 },

		},
		SpawnPoint  = {
             coords 	= vector3(438.4, -1018.3, 27.7), heading = 90.0
		},
		ShowRoom 	= {
			Active  	= true,
			SpawnPoints = {
		},
		},
	},
Benefactor = {
		Type  	  	= 'car',
		Permision 	= 'all',
		Category  	= {'benefactor', 'sportsclassics', 'super', 'sports'},
		Enter 	  	= {
			[1]     = {
			Coord 		= {x = -53.94, y = 68.22, z = 71.67, z2 = 71.87},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 342.75,
			Status 		= false,
			Text 		= '~s~Katalog Benefactoru ~b~[E]~s~'
			},
			[2]     = {
			Coord 		= {x = -54.08, y = 73.74, z = 71.67, z2 = 71.87},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 244.84,
			Status 		= false,
			Text 		= '~s~Katalog Benefactoru ~b~[E]~s~'
			},
			[3]     = {
			Coord 		= {x = -53.31, y = 76.39, z = 71.67, z2 = 71.87},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 258.89,
			Status 		= false,
			Text 		= '~s~Katalog Benefactoru ~b~[E]~s~'
			},
		},
		Seller 	  	= {
		    [1]  	= {
			hash  		= 'a_m_y_business_02',
			Coords 		= {x = -53.48, y = 70.04, z = 71.88, h = 161.24},
			},
		  	[2]  	= {
			hash  		= 'a_f_y_business_03',
			Coords 		= {x = -52.48, y = 73.29, z = 71.87, h = 68.64},
			},
		  	[3]  	= {
			hash  		= 'a_m_m_business_01',
			Coords 		= {x = -51.39, y = 76.31, z = 71.87, h = 78.99},
			},
		},
		View 	    = {
			Pos     	= { x = -67.63, y = 71.03, z = 71.73 },
			Show3DText 	= false,
			Heading 	= 254.96
		},
		SpawnPoints = {
            { coords 	= vector3(-61.02, 68.00, 71.75), heading = 029.61, radius = 4.0 },
            { coords 	= vector3(-75.11, 77.20, 71.75), heading = 208.61, radius = 2.0 },
            { coords 	= vector3(-78.03, 73.14, 71.75), heading = 272.84, radius = 2.0 },
            { coords 	= vector3(-72.02, 68.44, 71.75), heading = 241.79, radius = 2.0 },
            { coords 	= vector3(-68.62, 75.23, 71.75), heading = 238.98, radius = 2.0 },

		},
		SpawnPoint  = {
             coords 	= vector3(-67.37, 82.3, 71.42), heading = 063.37
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},
--[[PDM = {
		Type  	  	= 'car',
		Permision 	= 'all',
		Category  	= {'sportsclassics', 'super', 'sports'},
		Enter 	  	= {
			[1]     = {
			Coord 		= {x = -794.90, y = -221.3, z = 37.08, z2 = 36.48},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 304.14,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
			[2]     = {
			Coord 		= {x = -791.77, y = -216.85, z = 37.08, z2 = 36.48},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 212.25,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
			[3]     = {
			Coord 		= {x = -789.88, y = -215.65, z = 37.08, z2 = 36.48},
			Size  		= {x = 0.5, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 225.62,
			Status 		= false,
			Text 		= '~s~Katalog vozidel ~b~[E]~s~'
			},
		},
		Seller 	  	= {
		    [1]  	= {
			hash  		= 'ig_paper',
			Coords 		= {x = -793.40, y = -220.33, z = 37.08, h = 120.76},
			},
		  	[2]  	= {
			hash  		= 's_m_m_movprem_01',
			Coords 		= {x = -791.45, y = -218.31, z = 37.08, h = 350.54},
			},
		  	[3]  	= {
			hash  		= 'a_f_y_business_02',
			Coords 		= {x = -788.73, y = -216.45, z = 37.08, h = 61.49},
			},
		},
		View 	    = {
			Pos     	= { x = -792.03, y = -227.26, z = 36.49 },
			Show3DText 	= false,
			Heading 	= 144.37
		},
		SpawnPoints = {
			{ coords 	= vector3(-783.60, -223.61, 36.49), heading = 136.47, radius = 2.0 },
            { coords 	= vector3(-793.55, -233.47, 36.49), heading = 254.26, radius = 2.0 },
            { coords 	= vector3(-791.49, -237.37, 36.49), heading = 266.08, radius = 2.0 },
            { coords 	= vector3(-788.33, -241.47, 36.49), heading = 307.17, radius = 2.0 },
            { coords 	= vector3(-785.77, -245.50, 36.49), heading = 322.49, radius = 2.0 },

		},
		SpawnPoint  = {
             coords 	= vector3(-771.68, -231.59, 36.49), heading = 207.01
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},]]
Bike_Shop = {
		Type  	 	= 'cycles',
		Permision 	= 'all',
		Category  	= {'cycles'},
		Enter 		= {
			[1] 	= {
			Coord 		= {x = -1108.58, y = -1693.53, z = 4.42, z2 = 4.22},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 119.83,
			Status 		= false,
			Text 		= '~s~Katalog kol ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
			hash  		= 'a_m_y_cyclist_01',
			Coords 		= {x = -1109.49, y = -1694.13, z = 4.42, h = 303.97},
			}
		},
		View 		= {
			Pos     	= { x = -1105.02, y = -1691.03, z = 4.33 },
			Heading 	= 38.23,
		},
		SpawnPoints = {
            { coords 	= vector3(-1105.32, -1700.74, 4.37), heading = 288.7, radius = 2.0 },
            { coords 	= vector3(-1100.12, -1703.27, 4.37), heading = 005.83, radius = 4.0 },

		},
		SpawnPoint  = {
             coords 	= vector3(-1105.02, -1691.03, 4.33), heading = 303.97
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},

Boat_Shop = {
		Type  	 	= 'boat',
		Permision 	= 'all',
		Category  	= {'boat'},
		Enter 		= {
			[1] 	= {
			Coord 		= {x = 397.57, y = -1177.32, z = 29.40, z2 = 29.00},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 183.37,
			Status 		= false,
			Text 		= '~s~Katalog lodí ~b~[E]~s~'
			},
			[2] 	= {
			Coord 		= {x = 390.09, y = -1181.37, z = 29.40, z2 = 29.00},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 122.08,
			Status 		= false,
			Text 		= '~s~Katalog lodí ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
			hash  		= 'a_m_y_surfer_01',
			Coords 		= {x = 397.57, y = -1178.76, z = 29.40, h = 001.90},
			},
			[2] 	= {
			hash  		= 'a_m_y_sunbathe_01',
			Coords 		= {x = 388.44, y = -1182.34, z = 29.40, h = 310.46},
			},
		},
		View 		= {
			Pos     	= { x = -810.17, y = -1507.99, z = -0.09 },
			Heading 	= 86.16,
		},
		SpawnPoints = {
            { coords 	= vector3(-770.17, -1540.99, -0.09), heading = 86.16, radius = 2.0 },

		},
		SpawnPoint  = {
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},

Fraction_EMERGENCY = {
		Type  	 	= 'fraction',
		Permision 	= 'emergency',
		Category  	= {'police', 'ambulance', 'marshal', 'fire'},
		Enter 		= {
			[1] 	= {
			Coord 		= {x = 2460.2, y = -384.26, z = 93.33, z2 = 92.78},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 266.85,
			Status 		= 'infinite',
			Text 		= '~s~Katalog emergency aut ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
			--hash  		= 'a_m_y_surfer_01',
			--Coords 		= {x = -803.1, y = -204.44, z = 37.08, z2 = 36.48},
			},
		},
		View 		= {
			Pos     	= { x = 2446.76, y = -383.11, z = 92.6 },
			Heading 	= 166.28,
		},
		SpawnPoints = {
            { coords 	= vector3(-801.88, -214.4, 36.57), heading = 273.86, radius = 2.0 },

		},
		SpawnPoint  = {
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},

Fraction_UTILITIES = {
		Type  	 	= 'fraction',
		Permision 	= 'fraction',
		Category  	= {'beeker', 'thelostmc', 'bennys', 'taxi', 'weazelnews', 'esc', 'pbc', 'vgsd'},
		Enter 		= {
			[1] 	= {
				Coord 		= {x = 926.21, y = -1560.18, z = 30.74, z2 = 30.75},
				Size  		= {x = 1.0, y = 1.0, z = 1},
				Show3DText 	= true,
				Heading     = 93.94,
				Status 		= 'infinite',
				Text 		= '~s~Katalog utility aut ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
				--hash  		= 'a_m_y_surfer_01',
				--Coords 		= {x = -803.1, y = -204.44, z = 37.08, z2 = 36.48},
			},
		},
		View 		= {
			Pos     	= { x = 899.81, y = -1566.92, z = 30.83 },
			Heading 	= 93.94,
		},
		SpawnPoints = {
			{ coords 	= vector3(899.81, -1566.92, 30.83), heading = 93.94, radius = 2.0 },

		},
		SpawnPoint  = {
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
			},
		},
	},

Utility_shop = {
		Type  	 	= 'truck',
		Permision 	= 'all',
		Category  	= {'utilities', 'industrial'},
		Enter 		= {
			[1] 	= {
			Coord 		= {x = 797.68, y = -1628.36, z = 31.56, z2 = 31.00},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 174.16,
			Status 		= false,
			Text 		= '~s~Katalog utility vozidel ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
			--hash  		= 'a_m_y_surfer_01',
			--Coords 		= {x = 797.68, y = -1628.36, z = 31.56, h = 353.74},
			},
		},
		View 		= {
			Pos     	= { x = 787.39, y = -1614.98, z = 31.09 },
			Heading 	= 86.16,
		},
		SpawnPoints = {
            { coords 	= vector3(795.54, -1603.16, 31.51), heading = 228.25, radius = 2.0 },
            { coords 	= vector3(787.54, -1608.57, 31.51), heading = 224.44, radius = 2.0 },
            { coords 	= vector3(781.70, -1612.58, 31.51), heading = 227.16, radius = 2.0 },
            { coords 	= vector3(785.81, -1624.22, 31.51), heading = 332.00, radius = 2.0 },
            { coords 	= vector3(806.42, -1622.20, 31.51), heading = 068.01, radius = 2.0 },
            { coords 	= vector3(808.36, -1603.88, 31.51), heading = 173.48, radius = 2.0 },
            { coords 	= vector3(800.19, -1593.32, 31.51), heading = 190.17, radius = 2.0 },

		},
		SpawnPoint  = {
			{ coords 	= vector3(-1675.38, -3140.74, 14.51), heading = 246.01, radius = 2.0 },
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},
Plane_shop = {
		Type  	 	= 'planes',
		Permision 	= 'all',
		Category  	= {'helicopters', 'planes'},
		Enter 		= {
			[1] 	= {
			Coord 		= {x = -1621.31, y = -3152.86, z = 13.99, z2 = 13.00},
			Size  		= {x = 1.0, y = 1.0, z = 1},
			Show3DText 	= true,
			Heading     = 230.35,
			Status 		= false,
			Text 		= '~s~Katalog leteckých vozidel ~b~[E]~s~'
			},
		},
		Seller 		= {
			[1] 	= {
			--hash  		= 'a_m_y_surfer_01',
			--Coords 		= {x = 797.68, y = -1628.36, z = 31.56, h = 353.74},
			},
		},
		View 		= {
			Pos     	= { x = -1660.37, y = -3169.1, z = 14.76 },
			Heading 	= 243.01,
		},
		SpawnPoints = {
            { coords 	= vector3(-1675.38, -3140.74, 14.51), heading = 246.01, radius = 2.0 },
            { coords 	= vector3(-1669.08, -3124.71, 14.76), heading = 240.00, radius = 2.0 },
            { coords 	= vector3(-1653.23, -3132.37, 14.76), heading = 234.00, radius = 2.0 },
            { coords 	= vector3(-1660.20, -3143.39, 14.76), heading = 240.00, radius = 2.0 },

		},
		SpawnPoint  = {
		},
		ShowRoom 	= {
			Active  	= false,
			SpawnPoints = {
		},
		},
	},
}
