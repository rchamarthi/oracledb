select
   fs.tablespace_name                          Tablespace,
   (df.totalspace - fs.freespace)              Used_MB,
   fs.freespace                                Free_MB,
   df.totalspace                               Total_MB,
   round(100 * (fs.freespace / df.totalspace)) Pct_Free
from
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) TotalSpace
   from
      dba_data_files
   group by
      tablespace_name
   ) df,
   (select
      tablespace_name,
      round(sum(bytes) / 1048576) FreeSpace
   from
      dba_free_space
   group by
      tablespace_name
   ) fs
where
   df.tablespace_name = fs.tablespace_name;

