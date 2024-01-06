import pandas as pd
import json
import sys
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.preprocessing import LabelEncoder
import joblib


def train_random_forest(data, labels):
    model = RandomForestClassifier(random_state=42)
    model.fit(data, labels)
    return model


if __name__ == '__main__':
    json_data = json.loads(sys.argv[1])
    input_label = sys.argv[2]
    
    df = pd.DataFrame(json_data)
    label_encoder = LabelEncoder()
    df['job_name'] = label_encoder.fit_transform(df['job_name'])
    df['status'] = label_encoder.fit_transform(df['status'])
    threshold = 1200000 # 20 mins
    df['time'] = [1 if abs(row['estimated_duration'] - row['execution_time']) > threshold else 0 for index, row in df.iterrows()]


    X = df.drop('status', axis=1)
    X = df.drop('job_number', axis=1)
    y = df[input_label]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = train_random_forest(X_train, y_train)

    # Making predictions
    y_pred = model.predict(X_test)
    
    # Evaluating the model
    accuracy = accuracy_score(y_test, y_pred)    
    
    # Collecting Anomalies
    anomaly_indices = [i for i, pred in enumerate(y_pred) if pred == 1]
    anomalous_data = X_test.iloc[anomaly_indices]
    
    # JSON response
    df = pd.DataFrame(anomalous_data)    
    json_output = df.to_json(orient='records')
    print(json_output)


