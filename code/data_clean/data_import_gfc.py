"""
Description: Import global forest change data from Google Earth Engine
Author: Miriam Gold
Date: 17 June 2026
Last revised: 23 June 2026, mag
Notes: notes
"""

import ee

try:
    ee.Initialize(project="yield-innovation")
except Exception as e:
    ee.Authenticate()
    ee.Initialize(project="yield-innovation")

gfc = ee.Image("UMD/hansen/global_forest_change_2025_v1_13")
countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017")

gfc_cover2000 = gfc.select("treecover2000")
gfc_loss = gfc.select("loss")
gfc_lossyear = gfc.select("lossyear")

# Consider two countries...
african_countries = countries.filter(ee.Filter.Or(ee.Filter.eq("wld_rgn", "Africa")))

gfc_loss_area = gfc_loss.multiply(ee.Image.pixelArea())

# Sum forest cover in 2000 by countries
gfc_cover_by_country = gfc_cover2000.reduceRegions(
    collection=african_countries,
    reducer=ee.Reducer.sum(),
    scale=30,
    tileScale=4,
    maxPixelsPerRegion=1e20,
).map(lambda feature: feature.setGeometry(None))

# Sum lost forest area over countries by loss year
gfc_loss_by_year = (
    gfc_loss_area.addBands(gfc_lossyear)
    .reduceRegions(
        collection=african_countries,
        reducer=ee.Reducer.sum().group(groupField=1),
        scale=30,
        tileScale=4,
        maxPixelsPerRegion=1e20,
    )
    .map(lambda feature: feature.setGeometry(None))
)

task = ee.batch.Export.table.toDrive(
    collection=gfc_loss_by_year,
    description="gfc_loss_by_year_africa",
    folder="yield-innovation",
    fileFormat="CSV",
)

task.start()

task = ee.batch.Export.table.toDrive(
    collection=gfc_cover_by_country,
    description="gfc_cover_by_country",
    folder="yield-innovation",
    fileFormat="CSV",
)

task.start()
