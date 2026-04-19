SELECT * FROM {{ ref('bronze_hosts') }}
WHERE IS_SUPERHOST = 'true' 