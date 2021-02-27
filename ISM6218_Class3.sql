SELECT COUNT (*)
FROM relmdb.theatres_part
WHERE chain_id BETWEEN 101 and 110;

alter table relmdb.theatres_part parallel (degree 4);

SELECT *
FROM redaction_policies
WHERE object_owner LIKE 'DBERNT';

SELECT *
FROM dberndt.fans_sec;

SELECT * 
FROM redaction_columns
WHERE object_owner LIKE 'DBERNDT';

SELECT *
FROM dberndt.fans_sec
WHERE birth_year = 1975;

SELECT * from dual;

SELECT 'Secret message.' AS plain_text
FROM dual;

SELECT encrypt_varchar2('Secret message.') AS encrypted_text
FROM dual;

SELECT decrypt_varchar2(encrypt_varchar2('Secret message.')) AS plain_text
FROM dual;
