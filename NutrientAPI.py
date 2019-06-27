import urllib.request, json
from usdaAPIKey import APIKey, food_keys, nutrientIDs
import firebase_admin
from firebase_admin import db
from firebaseCreds import cred

def uploadToDB(foods):
    # Initialize the app with a service account, granting admin privileges
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://cherrypik-26900.firebaseio.com/'
    })

    ref = db.reference('Produce')
    for food in foods:
        ref.update(food)

def main():

    foods = []

    for foodNum, foodName in food_keys.items():
        with urllib.request.urlopen("https://api.nal.usda.gov/ndb/V2/reports?ndbno=" + foodNum + "&type=b&format=json&api_key=" + APIKey) as url:
            data = json.loads(url.read().decode())
            nutrients_list = data["foods"][0]["food"]["nutrients"]
            nutrient_info = {}
            foodinfo = {}
            for nutrient in nutrients_list:
                if nutrient["nutrient_id"] in nutrientIDs:
                    nutrient_name = nutrientIDs[nutrient["nutrient_id"]]
                    nutrient_info["Quantity"] = "100 grams"
                    if nutrient["nutrient_id"] == "318":
                        vit_a_val = int(nutrient["value"]) * 0.3
                        nutrient_info[nutrient_name] = "{:.2f} ug".format(vit_a_val)
                    else:
                        nutrient_info[nutrient_name] = nutrient["value"] + " " + nutrient["unit"]

            foodinfo[foodName] = nutrient_info
            foods.append(foodinfo)

    uploadToDB(foods)



if __name__ == "__main__":
    main()