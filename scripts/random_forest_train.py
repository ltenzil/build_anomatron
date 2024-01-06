import json
import sys
import sklearn
from sklearn.ensemble import RandomForestClassifier
import joblib
import numpy as np

def train_random_forest(data, labels):
    rf = RandomForestClassifier(random_state=42)
    rf.fit(data, labels)
    return rf

if __name__ == '__main__':
    # input_json = json.loads(sys.argv[1])
    # data = json.loads(sys.argv[1])
    # input_json = List(data)[0]
    data = sys.argv[1]
    labels = sys.argv[2]
    json_data = json.loads(data)
    labels = json.loads(labels)
    np_data = np.array([[item['estimated_duration'], item['execution_time']] for item in json_data])
    # df_data = np.array([list(item.values()) for item in json_data])
    
    model = train_random_forest(np_data, labels)
    joblib.dump(model, 'scripts/random_forest_model.pkl')  # Save the model
