"""Real MySQL tests. A unique disposable schema is created and removed.
Enable explicitly: RUN_MYSQL_TESTS=1 python -m pytest -q
The application's kindergarten_lab3 database is never used by these tests.
"""
import json
import os
import uuid
from pathlib import Path
import mysql.connector
import pytest
from app import create_app

pytestmark = pytest.mark.skipif(os.getenv("RUN_MYSQL_TESTS") != "1", reason="MySQL integration tests are opt-in")

@pytest.fixture()
def client():
    options = dict(host=os.getenv("MYSQL_HOST","127.0.0.1"), port=int(os.getenv("MYSQL_PORT","3306")),
                   user=os.getenv("MYSQL_USER","root"), password=os.getenv("MYSQL_PASSWORD",""))
    name = "kindergarten_test_" + uuid.uuid4().hex
    connection = mysql.connector.connect(**options, autocommit=True)
    cursor = connection.cursor(buffered=True)
    sql = (Path(__file__).parent/"lab3_fixture.sql").read_text(encoding="utf-8")
    sql = sql.replace("kindergarten_lab3", name)
    try:
        # This particular seed file has no semicolons inside quoted values.
        for statement in sql.split(";"):
            if statement.strip():
                cursor.execute(statement)
                if cursor.with_rows: cursor.fetchall()
        config = {"TESTING":True,"MYSQL_DATABASE":name, **{"MYSQL_"+k.upper():v for k,v in options.items()}}
        yield create_app(config).test_client()
    finally:
        cursor.execute(f"DROP DATABASE IF EXISTS `{name}`")
        cursor.close()
        connection.close()

def test_crud_all_tables(client):
    data = json.loads((Path(__file__).parent/"scenarios.json").read_text(encoding="utf-8"))
    ids = {}
    paths = {}
    payloads = {}
    assert client.get("/api/health").status_code == 200
    for entity, original in data["payloads"].items():
        body = {k:ids[v[1:]] if isinstance(v,str) and v.startswith("@") else v.replace("{{run_id}}","pytest") if isinstance(v,str) else v for k,v in original.items()}
        payloads[entity] = body
        response = client.post("/api/"+entity,json=body)
        assert response.status_code == 201, response.json
        result = response.json["data"]
        if entity == "employee_groups":
            suffix = f"/{result['employee_id']}/{result['group_id']}"
        else:
            ids[entity] = result[data["keys"][entity]]
            suffix = "/"+str(ids[entity])
        paths[entity] = "/api/"+entity+suffix
        assert client.get(response.headers["Location"]).json["data"] == result
        assert client.get("/api/"+entity).status_code == 200
    for entity, body in payloads.items():
        if entity in data["updates"]:
            field, value = data["updates"][entity]
            body = {**body, field:value}
        result = client.put(paths[entity],json=body)
        assert result.status_code == 200, result.json
        assert client.put(paths[entity],json=body).status_code == 200
    assert client.get(f"/api/kindergartens/{ids['kindergartens']}/child_groups").json["data"][0]["group_id"] == ids["child_groups"]
    assert client.get(f"/api/employees/{ids['employees']}/groups").json["data"][0]["group_id"] == ids["child_groups"]
    assert client.get(f"/api/child_groups/{ids['child_groups']}/employees").json["data"][0]["employee_id"] == ids["employees"]
    assert client.delete(paths["addresses"]).status_code == 409
    assert client.post("/api/employee_groups",json=payloads["employee_groups"]).status_code == 409
    assert client.get(paths["addresses"]).status_code == 200
    order = ["employee_groups","group_enrollments","salary_payments","bonus_payments","employment_history","child_groups","children","employees","positions","kindergartens","addresses"]
    for entity in order:
        assert client.delete(paths[entity]).status_code == 204
        assert client.get(paths[entity]).status_code == 404
    assert client.get("/api/children").json["count"] == 10

def test_relations_and_error_recovery(client):
    assert [x["group_id"] for x in client.get("/api/employees/1/groups").json["data"]] == [1,2]
    assert [x["employee_id"] for x in client.get("/api/child_groups/1/employees").json["data"]] == [1,2]
    all_rows = client.get("/api/relations/employees_groups").json["data"]
    assert len(all_rows) == 10 and all_rows[-1]["groups"] == []
    assert client.get("/api/employees/999999/groups").status_code == 404
    assert client.get("/api/addresses/10/kindergartens").json["count"] == 1
    assert client.post("/api/employee_groups",json={"employee_id":999999,"group_id":1}).status_code == 409
    assert client.get("/api/employee_groups").json["count"] == 10
    for field, text in [("city", "Львів' OR 1=1 --"), ("street", "Вулиця; DROP TABLE children; --")]:
        body = {"city":"Львів","street":"Тестова","building_number":"1",field:text}
        response = client.post("/api/addresses",json=body)
        assert response.status_code == 201
        assert response.json["data"][field] == text
    assert client.get("/api/children").json["count"] == 10
    assert client.get("/api/salary_payments/1").json["data"]["amount"] == "15500.00"
    assert client.get("/api/children/1").json["data"]["birth_date"] == "2019-11-10"

def test_composite_key_put(client):
    result = client.put("/api/employee_groups/5/5",json={"employee_id":5,"group_id":6})
    assert result.status_code == 200
    assert client.get("/api/employee_groups/5/5").status_code == 404
    assert client.get("/api/employee_groups/5/6").status_code == 200
    assert client.put("/api/employee_groups/5/6",json={"employee_id":1,"group_id":1}).status_code == 409
    assert client.get("/api/employee_groups/5/6").status_code == 200
