-----------------------------------------------------------------                                                       
-- UDF: Convert a Table into a JSON Document                                                                            
-- Parameters: ParTable         --> Table (SQL Name) to be converted                                                    
--             ParSchema        --> Schema (SQL Name) of the table to be converted                                      
--             ParWhere         --> Optional:  WHERE conditions for reducing the data                                   
--                                             leading WHERE must not be specified                                      
--             ParOrderBy       --> Optional:  ORDER BY clause for returning the data in a predefined sequence          
--                                             leading ORDER BY must not be specified                                   
-----------------------------------------------------------------                                                       
Create or Replace Function TABLE2JSON(                                                                                  
                           PARTABLE         VARCHAR(128),                                                               
                           PARSCHEMA        Varchar(128),                                                               
                           PARWHERE         VarChar(4096) Default '',                                                   
                           PARORDERBY       VarChar(1024) Default '')                                                   
       Returns CLOB(16 M) CCSID 1208                                                                                    
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific Table2JSON                                                                                              
       Not Fenced                                                                                                       
       Not Deterministic                                                                                                
       Called On Null Input                                                                                             
       No External Action                                                                                               
       Not Secured                                                                                                      
       Set Option Datfmt  = *Iso,                                                                                       
                  Dbgview = *Source,                                                                                    
                  Decmpt = *PERIOD,                                                                                     
                  DLYPRP = *Yes,                                                                                        
                  Optlob = *Yes                                                                                         
                                                                                                                        
   Begin                                                                                                                
     Declare LocColList Clob(1 M)             Default '';                                                               
     Declare LocSQLCmd  Clob(2 M)             Default '';                                                               
     Declare RtnJSON    Clob(16 M) CCSID 1208 Default '';                                                               
                                                                                                                        
     Declare Continue Handler for SQLException                                                                          
             Begin                                                                                                      
                Declare LocErrText VarChar(132) Default '';                                                             
                Get Diagnostics Condition 1 LocErrText = MESSAGE_TEXT;                                                  
           --   Return JSON_Object('Error': LocErrText);                                                                
                Return JSON_Object('Error': LocSQLCMD);                                                                 
             End;                                                                                                       
                                                                                                                        
     Set (ParTable, ParSchema) = (Upper(ParTable), Upper(ParSchema));                                                   
                                                                                                                        
     If Trim(ParWhere) > ''                                                                                             
        Then Set ParWhere   = ' WHERE '    concat Trim(ParWhere)   concat ' ';                                          
     End If;                                                                                                            
                                                                                                                        
     If Trim(ParOrderBy) > ''                                                                                           
        Then Set ParOrderBY = ' ORDER BY ' concat Trim(ParOrderBy) concat ' ';                                          
     End If;                                                                                                            
                                                                                                                        
     -- Build a List containing all columns of the specified columns                                                    
     -- separated by a comma                                                                                            
     Select ListAgg('''' concat Column_Name concat ''' : 'concat Column_Name,                                           
                    ', ')                                                                                               
            Into LocColList                                                                                             
        From QSYS2.SysColumns                                                                                           
        Where     Table_Schema = ParSchema                                                                              
              and Table_Name   = ParTable;                                                                              
     If Length(Trim(LocColList)) = 0 Then Signal SQLSTATE 'TMS95'                                                       
        Set Message_Text = 'Table or Schema not Found';                                                                 
     End If;                                                                                                            
                                                                                                                        
     Set LocSQLCmd =                                                                                                    
         'Values(Select JSON_Object(''Table''  : ''' concat ParTable  concat ''',                                       
                                    ''Schema'' : ''' concat ParSchema concat ''',                                       
                                    ''Data''   : '   concat                                                               
                         ' JSON_ArrayAgg(                                                                               
                              JSON_Object(' concat Trim(LocColList) concat ')'                                          
                                            concat ParOrderBy       concat '))                                          
                   From ' concat Trim(ParSchema) concat '.'         concat                                              
                                 Trim(ParTable)  concat                                                                 
                   ParWhere                      Concat                                                                 
                ' ) into ?';                                                                                            
                                                                                                                        
     Prepare DynSQL From LocSQLCmd;                                                                                     
     Execute DynSQL using RtnJSON;                                                                                      
     Return RtnJSON;                                                                                                    
   End;                                                                                                                 
                                                                                                                        
Begin                                                                                                                   
  Declare Continue Handler For SQLEXCEPTION Begin End;                                                                  
   Label On Specific Function TABLE2JSON                                                                                
      Is 'Convert a complete table into JSON data';                                                                     
                                                                                                                        
   Comment On Parameter Specific Routine TABLE2JSON                                                                     
     (PARTABLE         Is 'Table - SQL Name',                                                                           
      PARSCHEMA        Is 'Table Schema',                                                                               
      PARWHERE         Is 'Additional WHERE conditions without leading WHERE',                                          
      PARORDERBY       Is 'ORDER BY for sorting the output                                                              
                           without leading ORDER BY');                                                                  
                                                                                                                        
End;                                                                                                                                 
