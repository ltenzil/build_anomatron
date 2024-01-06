import numpy as np
from sklearn.svm import OneClassSVM
import matplotlib.pyplot as plt
import pandas as pd
import json
import sys


if __name__ == '__main__':
    data = sys.argv[1]
    json_data = json.loads(data)

    nu_value = sys.argv[2]
    nu_value = 0.2 if nu_value is None or not nu_value.strip() else float(nu_value)
    
    np_data = np.array([[item['estimated_duration'], item['execution_time']] for item in json_data])
    df_data = np.array([list(item.values()) for item in json_data])

    # Requires Sample data was not sufficient
    # sample_data = sys.argv[2]
    # sample_json_data = json.loads(sample_data)
    # sample_np_data = np.array([list(item.values()) for item in sample_json_data])
    
    # Creating the One-Class SVM model
    oc_svm = OneClassSVM(nu=nu_value, kernel='rbf', gamma='auto')
    # Fitting the model
    oc_svm.fit(np_data)

    # Predicting anomalies
    anomalies = oc_svm.predict(np_data)
    df = pd.DataFrame(df_data, columns=['estimated_duration', 'execution_time', 'id'])
    df['anomaly'] = anomalies
    json_output = df.to_json(orient='records')
    print(json_output)
