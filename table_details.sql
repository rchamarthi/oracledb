/*
pl/sql Script to list the space occupied by a given table and it's indexes. 
*/

set serveroutput on;
set feedback off;

declare
   l_owner      dba_tables.owner%type := 'SCOTT';
   l_table_name dba_tables.table_name%type := 'EMP';
   l_table_size dba_segments.bytes%type;
begin
   select bytes
   into   l_table_size
   from   dba_segments
   where  owner = l_owner
     and  segment_name = l_table_name;
     
  dbms_output.put_line(rpad('Table Size:',30,' ') || l_table_size/1024/1024 || ' GB');
end;
/
