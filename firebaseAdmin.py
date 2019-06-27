import firebase_admin
from firebase_admin import db
from firebaseCreds import cred

def getTotals(ml_inputs):
    total = 0
    total_correct = 0
    total_incorrect = 0

    item_accuracy_dict = {}

    for item in ml_inputs:
        if int(ml_inputs[item]["correct"])+int(ml_inputs[item]["incorrect"]) != 0:
            item_accuracy_dict[item] = int(ml_inputs[item]["correct"])/(int(ml_inputs[item]["correct"])+int(ml_inputs[item]["incorrect"]))
        else:
            item_accuracy_dict[item] = 0
        total_correct += int(ml_inputs[item]["correct"])
        total += int(ml_inputs[item]["correct"])
        total_incorrect += int(ml_inputs[item]["incorrect"])
        total += int(ml_inputs[item]["incorrect"])
        print("--------------\n{}\nCorrect: {}, Incorrect: {}".format(item, ml_inputs[item]["correct"], ml_inputs[item]["incorrect"]))

    return total, total_correct, total_incorrect, item_accuracy_dict

def main():

    # Initialize the app with a service account, granting admin privileges
    firebase_admin.initialize_app(cred, {
        'databaseURL': 'https://cherrypik-26900.firebaseio.com/'
    })

    # As an admin, the app has access to read and write all data, regradless of Security Rules
    ref = db.reference('MLAccuracy')
    ml_inputs = ref.get()
    total_inputs, total_correct, total_incorrect, item_accuracy_dict = getTotals(ml_inputs)

    ml_accuracy = total_correct/total_inputs
    ml_inaccuracy = total_incorrect/total_inputs

    print("--------------\nML Accuracy is {}%\nML Inaccuracy is {}%\n--------------".format(ml_accuracy*100, ml_inaccuracy*100))
    for k,v in item_accuracy_dict.items():
        print("ML Accuracy for {} is {:.2f}%".format(k, v*100))


if __name__ == "__main__":
    main()