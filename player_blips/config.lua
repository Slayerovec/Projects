Config                            = {}

Config.Emergency = {
  lspd = true,
  sahp = true,
  bcso = true,
  marshal = true,
  ems = true,
  fire = true,
  government = true,
  plane = false
}

Config.BlipColors = {
  lspd = 3,
  sahp = 3,
  bcso = 3,
  marshal = 10,
  ems = 37,
  fire = 75,
  government = 70,
  plane = 20
}

Config.Markers = {
  ['car'] = 225,
  ['motorcycle'] = 226,
  ['cycle'] = 226,
  ['boat'] = 404,
  ['heli'] = 574,
  ['plane'] = 307,
  ['emergency'] = {
    lspd = 56,
    sahp = 56,
    bcso = 56,
    marshal = 56,
    ems = 659,
    fire = 635,
    plane = 307
  },
  ['foot'] = {
    lspd = 60,
    sahp = 60,
    bcso = 60,
    marshal = 60,
    ems = 61,
    fire = 648,
    plane = 1
  }
}

Config.Zones = {

  plane = {
    Blips = { 'plane' }
  },

  lspd = {
    Blips = { 'lspd', 'sahp', 'bcso', 'ems'}
  },

  sahp = {
    Blips = { 'lspd', 'sahp', 'bcso', 'ems'}
  },

  bcso = {
    Blips = { 'lspd', 'sahp', 'bcso', 'ems'}
  },

  ems = {
    Blips = { 'lspd', 'sahp', 'bcso', 'ems', 'fire'}
  },

  marshal = {
    Blips = { 'marshal', 'lspd', 'sahp', 'bcso', 'ems', 'fire'}
  },

  fire = {
    Blips = { 'ems', 'fire'}
  },

  government = {
    Blips = { 'government' }
  }
}
