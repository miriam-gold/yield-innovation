# ----------------------------------------------------------------------------
#'
#' Description: Clean country-year panel of forest loss
#' Author: Miriam Gold
#' Date: 23 June 2026
#' Last revised: date, mag
#' Notes: notes
#'
# ---------------------------------------------------------------------------- #

# import ee
import pandas as pd
import ast
import re

gfc_loss_by_year_africa_raw = pd.read_csv(
    "~/Google Drive/My Drive/yield-innovation/gfc_loss_by_year_africa.csv"
)

gfc_loss_by_year_africa_clean = gfc_loss_by_year_africa_raw[["country_co", "groups"]]

gfc_loss_by_year_africa_clean[gfc_loss_by_year_africa_clean["groups"] != r"[]"]


def expand_country_timeseries(row):

    country_co = row["country_co"]
    country_data = row["groups"]

    country_key_quote = re.sub(r"(sum|group)", r"'\1'", country_data)
    country_colon = country_key_quote.replace("=", ":")

    country_list = ast.literal_eval(country_colon)

    country_df = pd.DataFrame(country_list)

    if not country_df.empty:
        country_df["country_co"] = country_co
        country_df["year"] = 2000 + country_df["group"]

    return country_df


gfc_loss_panel = pd.concat(
    [
        expand_country_timeseries(row)
        for _, row in gfc_loss_by_year_africa_clean.iterrows()
    ],
    ignore_index=True,
)

gfc_loss_panel[gfc_loss_panel["country_co"] == "EG"]
gfc_loss_panel["loss_km"] = gfc_loss_panel["sum"] * 1e-6

gfc_loss_panel.to_csv(
    "~/Dropbox/Innovation/data/clean/gfc/gfc_loss_by_year_africa_clean.csv"
)
