import json
import sys
import sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import joblib
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt

def predict(data, model_path):
    model = joblib.load(model_path)
    predictions = model.predict(data)
    return predictions.tolist()

if __name__ == '__main__':
    # input_data = json.loads(sys.argv[1])
    # np_data = np.array([list(item.values()) for item in input_data])
    # predictions = predict(np.array(input_data), 'random_forest_model.pkl')
    # print(json.dumps(predictions))

    json_data = json.loads(sys.argv[1])
    np_data = np.array([[item['estimated_duration'], item['execution_time']] for item in json_data])
    df_data = np.array([list(item.values()) for item in json_data])
    
    anomalies = predict(np_data, 'scripts/random_forest_model.pkl')
    
    df = pd.DataFrame(df_data, columns=['estimated_duration', 'execution_time', 'id'])
    df['anomaly'] = anomalies
    json_output = df.to_json(orient='records')
    print(json_output)
