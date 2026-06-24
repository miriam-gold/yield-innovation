"""
Description: Import Potapov's cropland expansion data from Google Earth Engine
Author: Miriam Gold
Date: 17 June 2026
Last revised: date, mag
Notes: https://glad.umd.edu/dataset/croplands/

    - Resolution is 30m
    - Pixel values are binary (0=no cropland, 1=cropland). Single band per image
    - Each year is an ImageCollection of 4 images (NE, SE, NW, SW)
"""

import ee

try:
    ee.Initialize(project="yield-innovation")
except Exception as _:
    ee.Authenticate()
    ee.Initialize(project="yield-innovation")

# Read ====================================

## Potapov cropland expansion data
potapov_years = [2003, 2007, 2011, 2015, 2019]

potapov_raw_list = [
    ee.ImageCollection(f"users/potapovpeter/Global_cropland_{year}")
    for year in potapov_years
]

## Country boundaries
countries = ee.FeatureCollection("USDOS/LSIB_SIMPLE/2017")


# Clean ====================================

## Combine all Potapov years into a single multiband image
potapov_image_list = [
    ic.mosaic().rename(str(year)) for ic, year in zip(potapov_raw_list, potapov_years)
]

potapov_all_years = ee.ImageCollection(potapov_image_list).toBands()

## Filter to region
african_countries = countries.filter(ee.Filter.Or(ee.Filter.eq("wld_rgn", "Africa")))

# Analysis ===================================

## Calculate cropland area
potapov_area = potapov_all_years.multiply(ee.Image.pixelArea())

## Sum cropland in each year by country
potapov_cropland_by_country = potapov_area.reduceRegions(
    collection=african_countries,
    reducer=ee.Reducer.sum(),
    scale=30,
    tileScale=4,
    maxPixelsPerRegion=1e20,
).map(lambda feature: feature.setGeometry(None))

# Write =====================================

## Run job on GEE servers
task = ee.batch.Export.table.toDrive(
    collection=potapov_cropland_by_country,
    description="potapov_cropland_by_country",
    folder="yield-innovation",
    fileFormat="CSV",
)

task.start()
