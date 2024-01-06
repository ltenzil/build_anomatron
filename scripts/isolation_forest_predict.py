import json
import sys
import sklearn
from sklearn.ensemble import IsolationForest
import joblib
import numpy as np
import pandas as pd

def predict_anomalies(data, model_path):
    # anomalies = np.where(predictions == -1)[0].tolist()
    # return anomalies
    # np_data = np.array([list(item.values()) for item in data])
    
    model = joblib.load(model_path)
    anomalies = model.predict(np_data)
    return anomalies

# def model_prediction(model, data):
#     np_data = np.array([list(item.values()) for item in data])
#     anomalies = model.predict(np_data)
#     return anomalies

# def train_model(sample_data):
#     np_data = np.array([list(item.values()) for item in sample_data])
#     iso_forest = IsolationForest(contamination='auto')
#     iso_forest.fit(np_data)
#     return iso_forest

# if __name__ == '__main__':
#     input_data = json.loads(sys.argv[1])
#     # sample_data = json.loads(sys.argv[2])
#     # model = train_model(sample_data)
#     np_data = np.array([list(item.values()) for item in input_data])
#     anomalies = predict_anomalies(np_data, 'scripts/isolation_forest_model.pkl')
#     # anomalies = model_prediction(model, input_data)
#     df = pd.DataFrame(np_data, columns=['estimated_duration', 'execution_time'])
#     df['Anomaly'] = anomalies
#     json_output = df.to_json(orient='records')
#     print(json_output)

if __name__ == '__main__':
    json_data = json.loads(sys.argv[1])
    np_data = np.array([[item['estimated_duration'], item['execution_time']] for item in json_data])
    df_data = np.array([list(item.values()) for item in json_data])
    anomalies = predict_anomalies(np_data, 'scripts/isolation_forest_model.pkl')
    
    df = pd.DataFrame(df_data, columns=['estimated_duration', 'execution_time', 'id'])
    df['anomaly'] = anomalies
    json_output = df.to_json(orient='records')
    print(json_output)

