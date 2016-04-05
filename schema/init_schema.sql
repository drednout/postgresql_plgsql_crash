DROP TABLE IF EXISTS test;
CREATE TABLE IF NOT EXISTS test 
(
    id BIGSERIAL PRIMARY KEY,
    amount BIGINT,
    counter BIGINT DEFAULT 0
);
CREATE INDEX ON test (counter) where counter > 0;
INSERT INTO test (amount) VALUES (1);
INSERT INTO test (amount) VALUES (2);
INSERT INTO test (amount) VALUES (3);
INSERT INTO test (amount) VALUES (4);
INSERT INTO test (amount) VALUES (5);


CREATE OR REPLACE FUNCTION test_plpy_postgres_crash(record_id INTEGER)
    RETURNS boolean
AS $$
    select_query = """
        SELECT * FROM test WHERE id = $1
    """
    if "select_plan" in GD:
        select_plan = GD["select_plan"]
    else:
        select_plan = plpy.prepare(select_query, ["integer"])
        GD["select_plan"] = select_plan

    select_cursor = plpy.cursor(select_plan, [record_id])
    return True
$$ LANGUAGE plpythonu;
