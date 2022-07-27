Config = Config or {}

Config.CurrentItems = {}

Config.SmeltTime = 300

Config.CanTake = true

Config.Smelting = true

Config.Locations = {
    ['PawnShops'] = {
        [1] = {['X'] = 182.26, ['Y'] = -1319.10, ['Z'] = 29.31, ['Open-Time'] = 6, ['Close-Time'] = 12, ['Sell-Value'] = 1.0, ['Type'] = 'Gold'},
        [2] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81, ['Open-Time'] = 12, ['Close-Time'] = 16, ['Sell-Value'] = 1.0, ['Type'] = 'Bars'},
    },
    ['Smeltery'] = {
        [1] = {['X'] = 1109.91, ['Y'] = -2008.23, ['Z'] = 31.08},
    },
    ['Gold-Sell'] = {
      [1] = {['X'] = -1468.99, ['Y'] = -406.36, ['Z'] = 36.81},
  },
}

Config.ItemPrices = {
  ['rolex'] = 2000,
  ['goldchain'] = 1500,
  ['diamond_ring'] = 1000,
  ['10kgoldchain'] = 1000,
}

Config.SmeltItems = {
  ['rolex'] = 16,
  ['goldbar'] = 26,
}