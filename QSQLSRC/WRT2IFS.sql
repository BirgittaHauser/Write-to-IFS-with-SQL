-----------------------------------------------------------------                                                       
-- Stored Procedure: Write Textes to the IFS                                                                            
-----------------------------------------------------------------                                                       
Create Or Replace Procedure WRT2IFS(In PARTEXT Clob(16M),                                                               
                                    In PARIFSFILE Varchar(1024),                                                        
                                    In PARFILEOPERATION Smallint Default 8)                                             
       Language RPGLE                                                                                                   
       Parameter Style General                                                                                          
       Modifies Sql Data                                                                                                
       External Name WRT2IFS                                                                                            
       Program Type Main                                                                                                
       Dynamic Result Sets 0;                                                                                           
                                                                                                                        
Label On Specific Procedure WRT2IFS                                                                                     
   Is 'Write Textes to an IFS File';                                                                                    
                                                                                                                        
Comment On Parameter Specific Procedure WRT2IFS                                                                         
   (PARTEXT          Is 'Text to be written to the IFS',                                                                
    PARIFSFILE       Is 'IFS File',                                                                                     
    PARFILEOPERATION Is 'File Operation 8=Create,16=Create/Replace,32=Append');                                         
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write Textes to an IFS File - Create File and do not override                                      
--******************************************************************************                                        
Create Or Replace Procedure Wrt2IFS_Create (In PARTEXT          Clob(16M),                                              
                                            In PARIFSFILE       Varchar(1024))                                          
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific Wrt2IFS_Create                                                                                          
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
     Declare Exit Handler for SQLException                                                                              
         Resignal SQLSTATE 'TME99' Set Message_Text = 'SQL Error';                                                      
     Declare Exit Handler for SQLWarning                                                                                
         Resignal SQLSTATE 'TMW99' Set Message_Text = 'SQL Warning';                                                    
     Call Wrt2IFS(ParText, ParIFSFile, 8);                                                                              
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure Wrt2IFS_Create                                                                             
  is 'Write Text to IFS - Create New File';                                                                             
                                                                                                                        
 Comment On Specific Procedure Wrt2IFS_Create                                                                           
  is 'Write Text to an IFS File - Create New File /                                                                     
      Do not override an existing one';                                                                                 
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write Textes to an IFS File - Create File and replace an existing one                              
--******************************************************************************                                        
Create Or Replace Procedure Wrt2IFS_CreateReplace (In PARTEXT    Clob(16M),                                             
                                                   In PARIFSFILE Varchar(1024))                                         
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific Wrt2IFS_CreateReplace                                                                                   
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
     Call Wrt2IFS(ParText, ParIFSFile, 16);                                                                             
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure Wrt2IFS_CreateReplace                                                                      
  is 'Write Text to IFS - Create/Replace File';                                                                         
                                                                                                                        
 Comment On Specific Procedure Wrt2IFS_CreateReplace                                                                    
  is 'Write Text to an IFS File - Create New File                                                                       
      and Replace an existing one';                                                                                     
--******************************************************************************                                        
-- Stored Procedure: Write Textes to an IFS File - Create File and append to an existing one                            
--******************************************************************************                                        
Create Or Replace Procedure Wrt2IFS_Append (In PARTEXT    Clob(16M),                                                    
                                            In PARIFSFILE Varchar(1024))                                                
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific Wrt2IFS_Append                                                                                          
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
     Call Wrt2IFS(ParText, ParIFSFile, 32);                                                                             
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure Wrt2IFS_Append                                                                             
  is 'Write to IFS - Create/Append to File';                                                                            
                                                                                                                        
 Comment On Specific Procedure Wrt2IFS_Append                                                                           
  is 'Write Textes to an IFS File - Create New File                                                                     
      and Append to an existing one';                                                                
