-----------------------------------------------------------------                                                       
-- UDF: Convert a Table into a XML Document                                                                             
-- Parameters: ParTable         --> Table (SQL Name) to be converted                                                    
--             ParSchema        --> Schema (SQL Name) of the table to be converted                                      
--             ParWhere         --> Optional:  WHERE conditions for reducing the data                                   
--                                             leading WHERE must not be specified                                      
--             ParOrderBy       --> Optional:  ORDER BY clause for returning the data in a predefined sequence          
--                                             leading ORDER BY must not be specified                                   
--             ParRoot          --> Optional:  Name of the root element                                                 
--                                             Default = "rowset"                                                       
--             ParRow           --> Optional:  Name of the row element                                                  
--                                             Default = "row"                                                          
--             ParAsAttribute   --> Optional:  Y = a single empty element per row                                       
--                                                 all column values are included as attributes                         
-----------------------------------------------------------------                                                       
Create or Replace Function TABLE2XML(                                                                                   
                           PARTABLE         VARCHAR(128),                                                               
                           PARSCHEMA        Varchar(128),                                                               
                           PARWHERE         VarChar(4096) Default '',                                                   
                           PARORDERBY       VarChar(1024) Default '',                                                   
                           PARRoot          VarChar(128)  Default '"rowset"',                                           
                           PARRow           VarChar(128)  Default '"row"',                                              
                           PARAsAttributes  VarChar(1)    Default '')                                                   
       Returns XML                                                                                                      
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific Table2XML                                                                                               
       Not Fenced                                                                                                       
       Not Deterministic                                                                                                
       Called On Null Input                                                                                             
       No External Action                                                                                               
       Not Secured                                                                                                      
       Set Option Datfmt  = *Iso,                                                                                       
                  Dbgview = *Source,                                                                                    
                  Decmpt  = *COMMA,                                                                                      
                  DLYPRP  = *Yes,                                                                                        
                  Optlob  = *Yes                                                                                         
                                                                                                                        
   Begin                                                                                                                
     Declare LocColList Clob(1 M) Default '';                                                                           
     Declare LocSQLCmd  Clob(2 M) Default '';                                                                           
     Declare LocAsAttributes VarChar(20) Default '';                                                                    
     Declare RtnXML     XML;                                                                                            
                                                                                                                        
     Declare Continue Handler for SQLException                                                                          
             Begin                                                                                                      
                Declare LocErrText VarChar(128) Default '';                                                             
                Get Diagnostics Condition 1 LocErrText = MESSAGE_TEXT;                                                  
                Return XMLElement(Name "rowset",                                                                        
                             XMLElement(Name "Error", LocErrText));                                                     
             End;                                                                                                       
                                                                                                                        
     Set (ParTable, ParSchema) = (Upper(ParTable), Upper(ParSchema));                                                   
                                                                                                                        
     If Trim(ParWhere) > ''                                                                                             
        Then Set ParWhere   = ' WHERE '    concat Trim(ParWhere)   concat ' ';                                          
     End If;                                                                                                            
                                                                                                                        
     If Trim(ParOrderBy) > ''                                                                                           
        Then Set ParOrderBY = ' ORDER BY ' concat Trim(ParOrderBy) concat ' ';                                          
     End If;                                                                                                            
                                                                                                                        
     If Trim(ParRoot) = '' Then Set ParRoot = '"rowset"';                                                               
     End If;                                                                                                            
                                                                                                                        
     If Trim(ParRow)  = '' Then Set ParRoot = '"row"';                                                                  
     End If;                                                                                                            
                                                                                                                        
     If Upper(ParAsAttributes) = 'Y'                                                                                    
        Then Set LocAsAttributes = ' as Attributes ';                                                                   
     End If;                                                                                                            
                                                                                                                        
     -- Build a List containing all columns of the specified columns                                                    
     -- separated by a comma                                                                                            
     Select ListAgg(Trim(Column_Name), ', ')                                                                            
            Into LocColList                                                                                             
        From QSYS2.SysColumns                                                                                           
        Where     Table_Schema = ParSchema                                                                              
              and Table_Name   = ParTable;                                                                              
     If Length(Trim(LocColList)) = 0 Then Signal SQLSTATE 'TMS95'                                                       
        Set Message_Text = 'Table or Schema not Found';                                                                 
     End If;                                                                                                            
                                                                                                                        
     Set LocSQLCmd =                                                                                                    
         'Values(Select XMLGROUP(' concat Trim(LocColList)        concat                                                
                                   ParOrderBy                     concat                                                
                                 ' Option Row  '   concat ParRow  Concat                                                
                                        ' Root '   concat ParRoot Concat                                                
                                   LocAsAttributes concat ')                                                            
                   From ' concat Trim(ParSchema)   concat '.'     concat                                                
                                 Trim(ParTable)    concat                                                               
                   ParWhere                        Concat                                                               
                ' ) into ?';                                                                                            
                                                                                                                        
     Prepare DynSQL From LocSQLCmd;                                                                                     
     Execute DynSQL using RtnXML;                                                                                       
     Return RtnXML;                                                                                                     
   End;                                                                                                                 
                                                                                                                        
Begin                                                                                                                   
  Declare Continue Handler For SQLEXCEPTION Begin End;                                                                  
   Label On Specific Function TABLE2XML                                                                                 
      Is 'Convert a complete table into XML';                                                                           
                                                                                                                        
   Comment On Parameter Specific Routine TABLE2XML                                                                      
     (PARTABLE         Is 'Table - SQL Name',                                                                           
      PARSCHEMA        Is 'Table Schema',                                                                               
      PARWHERE         Is 'Additional WHERE conditions without leading WHERE',                                          
      PARORDERBY       Is 'ORDER BY for sorting the output                                                              
                           without leading ORDER BY',                                                                   
      PARRoot          Is 'Root element name --> Default "rowset"',                                                     
      PARRow           Is 'Row element name --> Default "row"',                                                         
      PARAsAttributes  Is 'Y = Return a single element per row                                                          
                               all column values are returned as attributes');                                          
                                                                                                                        
End;                                                                                                                     
