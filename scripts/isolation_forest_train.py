import json
import sys
import sklearn
from sklearn.ensemble import IsolationForest
import joblib
import numpy as np

def train_isolation_forest(data):
    iso_forest = IsolationForest(contamination='auto')
    iso_forest.fit(data)
    return iso_forest

if __name__ == '__main__':
    # sample_data = "[{\"estimated_duration\":10542772,\"execution_time\":6168247,\"job_id\":2254,\"status\":0},{\"estimated_duration\":7332699,\"execution_time\":1296486,\"job_id\":588,\"status\":0},{\"estimated_duration\":3779367,\"execution_time\":1105994,\"job_id\":2092,\"status\":0},{\"estimated_duration\":4759105,\"execution_time\":6530925,\"job_id\":2561,\"status\":0},{\"estimated_duration\":10542772,\"execution_time\":1424771,\"job_id\":2198,\"status\":0},{\"estimated_duration\":4810990,\"execution_time\":4958321,\"job_id\":293,\"status\":0},{\"estimated_duration\":5661575,\"execution_time\":7752203,\"job_id\":157,\"status\":1},{\"estimated_duration\":5606358,\"execution_time\":4214962,\"job_id\":829,\"status\":1},{\"estimated_duration\":5715825,\"execution_time\":3674145,\"job_id\":1647,\"status\":1},{\"estimated_duration\":5715825,\"execution_time\":5249406,\"job_id\":1610,\"status\":1},{\"estimated_duration\":7896692,\"execution_time\":7035509,\"job_id\":1028,\"status\":1},{\"estimated_duration\":3585763,\"execution_time\":2162870,\"job_id\":1332,\"status\":1},{\"estimated_duration\":5584497,\"execution_time\":25933745,\"job_id\":225,\"status\":3},{\"estimated_duration\":9163114,\"execution_time\":25055421,\"job_id\":754,\"status\":3},{\"estimated_duration\":7964816,\"execution_time\":26458234,\"job_id\":1256,\"status\":3},{\"estimated_duration\":6866731,\"execution_time\":2917530,\"job_id\":1924,\"status\":4},{\"estimated_duration\":5658291,\"execution_time\":4052825,\"job_id\":942,\"status\":4},{\"estimated_duration\":4576457,\"execution_time\":8773945,\"job_id\":1534,\"status\":4}]"
    # sample_json_data = json.load(sample_data)
    # sample_input_data = np.array([list(item.values()) for item in data])
    # sample_iso_forest = IsolationForest(contamination='auto')
    # sample_iso_forest.fit(data)
    # sample_iso_forest
    # data = json.loads(sys.argv[1])
    # input_data = np.array([list(item.values()) for item in data])
    # model = train_isolation_forest(input_data)
    # joblib.dump(model, 'isolation_forest_model.pkl')  # Save the model


    # from VScode
    data = sys.argv[1]
    json_data = json.loads(data)
    input_data = np.array([[item["estimated_duration"], item["execution_time"]] for item in json_data])
    model = train_isolation_forest(input_data)
    joblib.dump(model, 'scripts/isolation_forest_model.pkl')
