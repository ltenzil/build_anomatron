import numpy as np
import json
from sklearn.neighbors import LocalOutlierFactor
import pandas as pd
import sys

if __name__ == '__main__':
    data = sys.argv[1]
    json_data = json.loads(data)
    neighbors = sys.argv[2]
    neighbors = (len(json_data) * 0.65) if neighbors is None or not neighbors.strip() else int(neighbors)
    np_data = np.array([[item['estimated_duration'], item['execution_time']] for item in json_data])
    df_data = np.array([list(item.values()) for item in json_data])
    
    # Creating the LOF model
    lof = LocalOutlierFactor(int(neighbors), contamination='auto')
    
    # Fitting the model and predicting anomalies
    anomalies = lof.fit_predict(np_data)
    
    # Anomalies are labeled as -1, and normal points are labeled as 1
    df = pd.DataFrame(df_data, columns=['estimated_duration', 'execution_time', 'id'])
    df['anomaly'] = anomalies
    json_output = df.to_json(orient='records')
    print(json_output)

