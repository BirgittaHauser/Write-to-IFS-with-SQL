--------------------------------------------------------------------------------
-- Stored Procedure: Write UTF-8 data to an IFS File
--------------------------------------------------------------------------------
Create Or Replace Procedure WrtUTF82IFS
                                      (In ParUTF8          Clob(16M) CCSID 1208,
                                       In PARIFSFILE       Varchar(1024),
                                       In PARFILEOPERATION Smallint Default 8)
       Language RPGLE
       Parameter Style General
       Modifies Sql Data
       Specific WRTUTF82IFS
       External Name WrtUT82IFS
       Program Type Main
       Dynamic Result Sets 0;

Label On specific Routine WrtUTF82IFS
   Is 'Write Character UTF8 data to the IFS';

Comment On Parameter specific Routine WrtUTF82IFS
   (ParUTF8          Is 'UTF-8 Data to be written to the IFS',
    PARIFSFILE       Is 'IFS File',
    PARFILEOPERATION Is 'File Operation 8=Create,16=Create/Replace,32=Append');

--******************************************************************************
-- Stored Procedure: Write UTF-8 Data to the IFS - Create File and do not override
--******************************************************************************
Create Or Replace Procedure WrtUTF82IFS_Create
                                       (In ParUTF8      Clob(16M) CCSID 1208,
                                        In PARIFSFILE   Varchar(1024))
       Language SQL
       Modifies SQL Data
       Specific WrtUTF82IFS_Create
       Dynamic Result Set 0
       Commit On Return No

       Set Option DatFmt  = *ISO,
                  DbgView = *Source,
                  DLYPRP  = *Yes,
                  OptLOB  = *Yes
   ---------------------------------------------------------------------------------
   -- Routine Body
   --------------------------------------------------------------------------------
   Begin
     Call WrtUTF82IFS(ParUTF8, ParIFSFile, 8);
   End;

 Label On Specific Procedure WrtUTF82IFS_Create
    Is 'Write UTF-8 data to the IFS/Create File';

 Comment On Specific Procedure WrtUTF82IFS_Create
  is 'Write UTF-8 Data to IFS - Create New File /
      Do not replace an existing one';

--******************************************************************************
-- Stored Procedure: Write XML data to the IFS - Create File and replace an existing one
--******************************************************************************
Create Or Replace Procedure WrtUT82IFS_CreateReplace
                                          (In ParUTF8    Clob(16M) CCSID 1208,
                                           In PARIFSFILE Varchar(1024))
       Language SQL
       Modifies SQL Data
       Specific WrtUTF82IFS_CreateReplace
       Dynamic Result Set 0
       Commit On Return No

       Set Option DatFmt  = *ISO,
                  DbgView = *Source,
                  DLYPRP  = *Yes,
                  OptLOB  = *Yes
   ---------------------------------------------------------------------------------
   -- Routine Body
   --------------------------------------------------------------------------------
   Begin
     Call WrtUTF82IFS(ParUTF8, ParIFSFile, 16);
   End;

 Label On Specific Procedure WrtUTF82IFS_CreateReplace
  is 'Write UTF-8 Data to IFS - Create/Replace File';

 Comment On Specific Procedure WrtUTF82IFS_CreateReplace
  is 'Write UTF-8 Data to IFS - Create New File /
      Replace an existing one';

--******************************************************************************
-- Stored Procedure: Write Textes to the IFS - Create File and append to an existing one
--******************************************************************************
Create Or Replace Procedure WrtUTF82IFS_Append
                                       (In ParUTF8    Clob(16M) CCSID 1208,
                                        In PARIFSFILE Varchar(1024))
       Language SQL
       Modifies SQL Data
       Specific WrtUTF82IFS_Append
       Dynamic Result Set 0
       Commit On Return No

       Set Option DatFmt  = *ISO,
                  DbgView = *Source,
                  DLYPRP  = *Yes,
                  OptLOB  = *Yes
   ---------------------------------------------------------------------------------
   -- Routine Body
   --------------------------------------------------------------------------------
   Begin
     Call WrtUTF82IFS(ParUTF8, ParIFSFile, 32);
   End;

 Label On Specific Procedure WrtUTF82IFS_Append
  is 'Write UTF-8 data to IFS - Create/Append to File';

 Comment On Specific Procedure WrtUTF82IFS_Append
  is 'Write UTF-8 data to an IFS File - Create New File and
      Append to an existing one';                        
