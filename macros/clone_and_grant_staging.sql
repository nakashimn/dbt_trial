{% macro clone_and_grant_staging() %}
// cloning
;
create or replace database staging clone production;

-- // grant privileges to DEVELOPER
-- grant USAGE on all schemas in database staging to role DEVELOPER;               -- 既存全Schemeの使用権限
-- grant USAGE on future schemas in database staging to role DEVELOPER;            -- 将来作られるSchemeの使用権限
-- grant USAGE on all stages in schema staging.raw to role DEVELOPER;              -- 既存Stageの私用権限
-- grant USAGE on future stages in schema staging.raw to role DEVELOPER;           -- 将来作られるStageの私用権限
-- grant SELECT on all tables  in schema staging.raw to role DEVELOPER;            -- 既存TableのSELECT権限
-- grant SELECT on future tables in schema staging.raw to role DEVELOPER;          -- 将来作られるTableのSELECT権限
-- grant SELECT on all views in schema staging.raw to role DEVELOPER;              -- 既存ViewのSELECT権限
-- grant SELECT on future views in schema staging.raw to role DEVELOPER;           -- 将来作られるViewのSELECT権限
-- grant SELECT on all tables  in schema staging.core to role DEVELOPER;           -- 既存TableのSELECT権限
-- grant SELECT on future tables in schema staging.core to role DEVELOPER;         -- 将来作られるTableのSELECT権限
-- grant SELECT on all views in schema staging.core to role DEVELOPER;             -- 既存ViewのSELECT権限
-- grant SELECT on future views in schema staging.core to role DEVELOPER;          -- 将来作られるViewのSELECT権限
-- grant SELECT on all tables  in schema staging.integration to role DEVELOPER;    -- 既存TableのSELECT権限
-- grant SELECT on future tables in schema staging.integration to role DEVELOPER;  -- 将来作られるTableのSELECT権限
-- grant SELECT on all views in schema staging.integration to role DEVELOPER;      -- 既存ViewのSELECT権限
-- grant SELECT on future views in schema staging.integration to role DEVELOPER;   -- 将来作られるViewのSELECT権限


-- // grant privileges to ADMINISTRATOR
-- grant ALL on database staging to role ADMINISTRATOR;
-- grant ALL on all schemas in database staging to role ADMINISTRATOR;             -- 既存全Schemeの使用権限
-- grant ALL on future schemas in database staging to role ADMINISTRATOR;          -- 将来作られるSchemeの使用権限
-- grant ALL on all stages in schema staging.raw to role ADMINISTRATOR;            -- 既存Stageの私用権限
-- grant ALL on future stages in schema staging.raw to role ADMINISTRATOR;         -- 将来作られるStageの私用権限
-- grant ALL on all tables in schema staging.raw to role ADMINISTRATOR;            -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.raw to role ADMINISTRATOR;         -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.raw to role ADMINISTRATOR;             -- 既存Viewの全権限
-- grant ALL on future views in schema staging.raw to role ADMINISTRATOR;          -- 将来作られるViewの全権限
-- grant ALL on all tables in schema staging.core to role ADMINISTRATOR;           -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.core to role ADMINISTRATOR;        -- 将来作られるTableの全権限
-- grant ALL on all tables in schema staging.core to role ADMINISTRATOR;           -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.core to role ADMINISTRATOR;        -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.core to role ADMINISTRATOR;            -- 既存Viewの全権限
-- grant ALL on future views in schema staging.core to role ADMINISTRATOR;         -- 将来作られるViewの全権限
-- grant ALL on all tables in schema staging.integration to role ADMINISTRATOR;    -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.integration to role ADMINISTRATOR; -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.integration to role ADMINISTRATOR;     -- 既存Viewの全権限
-- grant ALL on future views in schema staging.integration to role ADMINISTRATOR;  -- 将来作られるViewの全権限

-- // grant privileges to DBT_JOB
-- grant ALL on database staging to role DBT_JOB;
-- grant ALL on all schemas in database staging to role DBT_JOB;                   -- 既存全Schemeの使用権限
-- grant ALL on future schemas in database staging to role DBT_JOB;                -- 将来作られるSchemeの使用権限
-- grant ALL on all stages in schema staging.raw to role DBT_JOB;                  -- 既存Stageの私用権限
-- grant ALL on future stages in schema staging.raw to role DBT_JOB;               -- 将来作られるStageの私用権限
-- grant ALL on all tables in schema staging.raw to role DBT_JOB;                  -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.raw to role DBT_JOB;               -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.raw to role DBT_JOB;                   -- 既存Viewの全権限
-- grant ALL on future views in schema staging.raw to role DBT_JOB;                -- 将来作られるViewの全権限
-- grant ALL on all tables in schema staging.core to role DBT_JOB;                 -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.core to role DBT_JOB;              -- 将来作られるTableの全権限
-- grant ALL on all tables in schema staging.core to role DBT_JOB;                 -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.core to role DBT_JOB;              -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.core to role DBT_JOB;                  -- 既存Viewの全権限
-- grant ALL on future views in schema staging.core to role DBT_JOB;               -- 将来作られるViewの全権限
-- grant ALL on all tables in schema staging.integration to role DBT_JOB;          -- 既存Tableの全権限
-- grant ALL on future tables in schema staging.integration to role DBT_JOB;       -- 将来作られるTableの全権限
-- grant ALL on all views in schema staging.integration to role DBT_JOB;           -- 既存Viewの全権限
-- grant ALL on future views in schema staging.integration to role DBT_JOB;        -- 将来作られるViewの全権限
{% endmacro %}
