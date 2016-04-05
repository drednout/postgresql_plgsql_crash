Howto reproduce an issue with PosgreSQL crash? 

1. Install PosgreSQL on your system
2. Create user for performing crash test:  

```$ createuser -p 5434 test -s -d -P```

set password `1` for avoiding source code editing. 

3. Init database schema: 

```psql -h localhost -p 5434 -U test < init_schema.sql```

4. Install Erlang 17.X or 18.X using kerl or some system package
5. Compile code: 

```$ make``

6. Run code and wait about 10 seconds, until PostgreSQL will crash:

```$ make console```
