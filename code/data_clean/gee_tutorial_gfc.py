# ----------------------------------------------------------------------------
#'
#' Description: Download Global Forest Change (Hansen) data
#' Author: Miriam Gold
#' Date: 16 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #


import ee
import geemap
import pandas as pd
import matplotlib.pyplot as plt
# import numpy as np
# from scipy import optimize
# from IPython.display import Image

# Trigger the authentication flow.
ee.Authenticate()

# Initialize the library.
ee.Initialize(project="yield-innovation")

# Read =====================================
"""
loss = 1 if loss ever happened in that pixel
lossyear = 0 if loss never occured, and is 1-indexed from 2001 to 2025
treecover2000 = percentage cover of pixel in 2000
"""

gfc = ee.Image("UMD/hansen/global_forest_change_2025_v1_13")
countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017")
congo = countries.filter(ee.Filter.eq("country_na", "Rep of the Congo"))
congo_feat = ee.Feature(congo.first())

protected_areas = ee.FeatureCollection("WCMC/WDPA/current/polygons")
protected_areas = protected_areas.filter(
    ee.Filter.And(
        ee.Filter.bounds(congo.geometry()),
        ee.Filter.neq("IUCN_CAT", "VI"),
        ee.Filter.neq("STATUS", "proposed"),
        ee.Filter.lt("STATUS_YR", 2010),
    )
)

protected_areas = protected_areas.map(lambda feat: congo_feat.intersection(feat))

gfc_loss = gfc.select("loss")
gfc_gain = gfc.select("gain")
gfc_lossyear = gfc.select("lossyear")
# Image.eq() returns Boolean for each pixel
gfc_loss_2012 = gfc_lossyear.eq(12)

# Map areas that experienced both gain and loss
gfc_gainandloss = gfc_gain.And(gfc_loss)

lat, lon = 34.746483, -92.289597
test_map = geemap.Map(center=[lat, lon], zoom=10)

test_map.addLayer(ee.Image.pixelArea())
test_map.addLayer(
    gfc_gainandloss.updateMask(gfc_gainandloss), {"palette": "FF00FF"}, "Gain and Loss"
)
test_map

# Quantify forest loss ======================
# This reducer will sum across all the pixels in an image that intersect with the `geometry` (Congo)
# It will tell you how many pixels ever experienced loss
stats = gfc_loss.reduceRegion(
    reducer=ee.Reducer.sum(), geometry=congo, scale=30, maxPixels=1e9
)

## Calculate pixel area ====================

gfc_area = gfc_loss.multiply(ee.Image.pixelArea())

# Sum the values of forest loss pixels in DRC
stats = gfc_area.reduceRegion(
    reducer=ee.Reducer.sum(), geometry=congo, scale=30, maxPixels=1e9
)

print(stats.get("loss").getInfo())

## Calculate forest loss in 2012 ========================
gfc_loss_2012_area = gfc_loss_2012.multiply(ee.Image.pixelArea())

total_loss_2012 = gfc_loss_2012_area.reduceRegion(
    reducer=ee.Reducer.sum(), geometry=congo.geometry(), scale=30, maxPixels=1e9
)

print(total_loss_2012.get("lossyear").getInfo())

# Chart yearly forest loss =======================

gfc_loss_by_year = gfc_area.addBands(gfc_lossyear).reduceRegion(
    reducer=ee.Reducer.sum().group(
        groupField=1
    ),  # groupField specifies which band will determine the groups
    geometry=congo,
    scale=30,
    maxPixels=2e9,
)


def dict_formatter(el):
    d = ee.Dictionary(el)
    return [ee.Number(d.get("group")).format("20%02d"), d.get("sum")]


loss_formatted = ee.List(gfc_loss_by_year.get("groups")).map(dict_formatter)

loss_dict = ee.Dictionary(loss_formatted.flatten())

years = loss_dict.getInfo().keys()
loss = loss_dict.getInfo().values()

fig, ax = plt.subplots(figsize=(14, 6))

ax.bar(years, loss)
