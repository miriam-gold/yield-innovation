"""
Description: Import and aggregate attainable yield from Google Earth Engine
Author: Miriam Gold
Date: 29 June 2026
Last revised: date, mag
Notes: notes
"""

import ee

try:
    ee.Initialize(project="yield-innovation")
except Exception as e:
    ee.Authenticate()
    ee.Initialize(project="yield-innovation")

PROJECT_ID = "yield-innovation"

local_tifs = [
    "ylHr_mze",
    "ylHr_olp",
    "ylHr_rsd",
    "ylHr_sfl",
    "ylHr_soy",
    "ylHr_sub",
    "ylHr_suc",
]


def image_gaez_img(tif):

    asset_id = f"projects/{PROJECT_ID}/assets/{tif}"

    return ee.Image(asset_id).rename([tif])


gaez_all_bands = ee.ImageCollection(
    [image_gaez_img(tif) for tif in local_tifs]
).toBands()

countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017")

african_countries = countries.filter(ee.Filter.Or(ee.Filter.eq("wld_rgn", "Africa")))

gaez_avg_yield_by_country = gaez_all_bands.reduceRegions(
    collection=african_countries,
    reducer=ee.Reducer.mean(),
    scale=30,
    tileScale=4,
    maxPixelsPerRegion=1e20,
).map(lambda feature: feature.setGeometry(None))

task = ee.batch.Export.table.toDrive(
    collection=gaez_avg_yield_by_country,
    description="gaez_avg_yield_by_country",
    folder="yield-innovation",
    fileFormat="CSV",
)

task.start()
