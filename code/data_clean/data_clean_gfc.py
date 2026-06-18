"""
Description: Clean GAEZ crop suitability data
Author: Miriam Gold
Date: 17 June 2026
Last revised: date, mag
Notes: notes
"""

import ee
import geemap
import pandas as pd

try:
    ee.Initialize(project="yield-innovation")
except Exception as e:
    ee.Authenticate()
    ee.Initialize(project="yield-innovation")

gfc = ee.Image("UMD/hansen/global_forest_change_2025_v1_13")
countries = ee.FeatureCollection("FAO/GAUL/2015/level0")

forest = gfc.select(["treecover2000"])
loss_year = gfc.select(["lossyear"])

# Consider a single country...
tza = countries.filter(ee.Filter.stringContains("ADM0_NAME", "Tanzania"))

#
mask = loss_year.eq(24)

area_mask = mask.multiply(ee.Image.pixelArea())

area_mask

# TODO:
# 1. Create annual masks, so each deforestation year gets its own band (Band 1: 0/1 indicators for deforestation in 2000, etc., multiplied by the pixel area)
# 2. Use `reduceRegions` to sum the deforested pixels in each country-band (i.e., country-year)
# 3. Convert to a DataFrame that has a row for each country-year and a variable DeforestedArea
