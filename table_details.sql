/*
pl/sql Script to list the space occupied by a given table and it's indexes and other details. 
*/

declare
   l_owner      dba_tables.owner%type := 'SCOTT';
   l_table_name dba_tables.table_name%type := 'EMP';
   l_table_size dba_segments.bytes%type;
   l_partitioned dba_tables.partitioned%type;
   l_index_size dba_segments.bytes%type;
begin

  dbms_output.put_line(rpad('Table:',50,' ') || l_owner || '.' || l_table_name);

  --check if table is partitioned or not.
  select partitioned
  into   l_partitioned
  from   dba_tables
  where  owner = l_owner
    and  table_name = l_table_name;

  dbms_output.put_line(rpad('Partitioned?:',50,' ') || l_partitioned);

-- Table Size
  
   select sum(bytes)
   into   l_table_size
   from   dba_segments
   where  owner = l_owner
     and  segment_name = l_table_name;
  
  dbms_output.put_line('');
  dbms_output.put_line(rpad('Table Size:',50,' ') || trunc(l_table_size/1024/1024/1024,2) || ' GB');
  dbms_output.put_line('');
  
  dbms_output.put_line('Index details:');
  dbms_output.put_line('--------------');
  -- are indexes partitioned? (to see if there are any global indexes)
  for v_rec in (
    select index_name, 
           case when partitioned = 'YES' then 'local' else 'global' end index_type
    from   dba_indexes
    where  owner = l_owner
      and  table_name = l_table_name
  ) loop
    dbms_output.put_line(rpad('INDEX: ' || v_rec.index_name, '50') || v_rec.index_type);
  end loop;
  
  dbms_output.put_line('');
  
  -- index size
  select trunc(sum(bytes)/1024/1024/1024,2)
  into  l_index_size
  from dba_segments
  where (owner, segment_name) in (
    select owner, index_name
    from dba_indexes
    where owner = l_owner
      and table_name = l_table_name
  );
  
  dbms_output.put_line(rpad('INDEX Size: ',50) || l_index_size || ' GB');

end;
/
