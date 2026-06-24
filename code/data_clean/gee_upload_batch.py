"""
Author: Google Gemini (edited by Miriam Gold)
Model: 3.5 Thinking
Prompt: I am working with Google Earth Engine and want to programmatically
        upload a GeoTIFF file from my computer to remote Google Earth Engine storage.
        Explain how this works and how I can upload using code, either with the Python
        API or a bash script
"""

import ee
from google.cloud import storage


# --- CONFIGURATION ---
PROJECT_ID = "yield-innovation"  # Your GCP project
BUCKET_NAME = "upload-staging-area"  # Your bucket (no gs:// prefix)
LOCAL_TIFF_DIR = "/Users/miriamgold/Library/CloudStorage/Dropbox/Innovation/data/raw/gaez/attainable/CRUTS32/Hist/8110/"

# 1. Initialize Earth Engine
# Authenticate via terminal first using: earthengine authenticate
ee.Initialize(project=PROJECT_ID)

local_tifs = [
    "ylHr_mze",
    "ylHr_olp",
    "ylHr_rsd",
    "ylHr_sfl",
    "ylHr_soy",
    "ylHr_sub",
    "ylHr_suc",
]


# 2. Upload the file to Google Cloud Storage
def upload_to_gcs(local_file, bucket):

    local_path = f"{LOCAL_TIFF_DIR}/{local_file}.tif"
    blob_name = f"{local_file}.tif"
    print(f"Uploading {local_path} to GCS bucket '{BUCKET_NAME}'...")

    blob = bucket.blob(blob_name)

    blob.upload_from_filename(local_path)
    gcs_uri = f"gs://{BUCKET_NAME}/{blob_name}"
    print(f"Successfully uploaded to: {gcs_uri}")
    return gcs_uri


storage_client = storage.Client(project=PROJECT_ID)
bucket = storage_client.bucket(BUCKET_NAME)

for tif in local_tifs:
    gcs_file_uri = upload_to_gcs(tif, bucket)

    # 3. Create the GEE Ingestion Manifest
    asset_id = f"projects/{PROJECT_ID}/assets/{tif}"

    manifest = {"name": asset_id, "tilesets": [{"sources": [{"uris": [gcs_file_uri]}]}]}

    # 4. Request a Task ID and start ingestion
    task_id = ee.data.newTaskId()[0]
    response = ee.data.startIngestion(task_id, manifest)

    print("\nIngestion task submitted successfully!")
    print(f"Asset ID will be: {asset_id}")
    print(f"Track status in GEE Tasks or via Python using Task ID: {task_id}")

# [b.delete() for b in bucket.list_blobs()]
