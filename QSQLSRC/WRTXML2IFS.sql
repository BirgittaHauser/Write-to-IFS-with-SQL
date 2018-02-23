--------------------------------------------------------------------------------                                        
-- Stored Procedure: Write Textes containing XML Data to an IFS File                                                    
--------------------------------------------------------------------------------                                        
Create Or Replace Procedure WrtXML2IFSChar                                                                              
                                      (In ParXML           Clob(16M),                                                   
                                       In PARIFSFILE       Varchar(1024),                                               
                                       In PARFILEOPERATION Smallint Default 8)                                          
       Language RPGLE                                                                                                   
       Parameter Style General                                                                                          
       Modifies Sql Data                                                                                                
       External Name WrtXML2IFS                                                                                         
       Program Type Main                                                                                                
       Dynamic Result Sets 0;                                                                                           
                                                                                                                        
Label On Routine WrtXML2IFSChar(Clob(), Varchar(), Smallint)                                                            
   Is 'Write Character XML data to the IFS';                                                                            
                                                                                                                        
Comment On Parameter Routine WrtXML2IFSChar(Clob(), Varchar(), Smallint)                                                
   (ParXML           Is 'Character XML Data to be written to the IFS',                                                  
    PARIFSFILE       Is 'IFS File',                                                                                     
    PARFILEOPERATION Is 'File Operation 8=Create,16=Create/Replace,32=Append');                                         
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write XML Data to the IFS - Create File and do not override                                        
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFSChar_Create (In ParXML       Clob(16M),                                           
                                                   In PARIFSFILE   Varchar(1024))                                       
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFSChar_Create                                                                                   
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
     Call WrtXML2IFSChar(ParXML, ParIFSFile, 8);                                                                        
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFSChar_Create                                                                      
    Is 'Write Char. XML data to the IFS/Create File';                                                                   
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFSChar_Create                                                                    
  is 'Write Character XML Data to IFS - Create New File /                                                               
      Do not replace an existing one';                                                                                  
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write XML data to the IFS - Create File and replace an existing one                                
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFSChar_CreateReplace                                                                
                                          (In ParXML    Clob(16M),                                                      
                                           In PARIFSFILE Varchar(1024))                                                 
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFSChar_CreateReplace                                                                            
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
     Call WrtXML2IFSChar(ParXML, ParIFSFile, 16);                                                                       
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFSChar_CreateReplace                                                               
  is 'Write Char.XML Data to IFS - Create/Replace File';                                                                
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFSChar_CreateReplace                                                             
  is 'Write Character XML Data to IFS - Create New File /                                                               
      Replace an existing one';                                                                                         
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write Textes to the IFS - Create File and append to an existing one                                
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFSChar_Append                                                                       
                                       (In ParXML     Clob(16M),                                                        
                                        In PARIFSFILE Varchar(1024))                                                    
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFSChar_Append                                                                                   
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
     Call WrtXML2IFSChar(ParXML, ParIFSFile, 32);                                                                       
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFSChar_Append                                                                      
  is 'Write Char.XML data to IFS - Create/Append to File';                                                              
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFSChar_Append                                                                    
  is 'Write Character XML data to an IFS File - Create New File and                                                     
      Append to an existing one';                                                                                       
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write Textes to the IFS - Create File and append to an existing one                                
--                   Parameter XML Data Type                                                                            
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFS(In ParXML           XML,                                                         
                                       In PARIFSFILE       Varchar(1024),                                               
                                       In PARFILEOPERATION Smallint Default 8)                                          
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFSXML                                                                                           
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
     Declare LocCLOBData  Clob(16 M) Default '';                                                                        
     Set LocClobData = XMLSerialize(ParXML as CLOB(16 M));                                                              
     Call WrtXML2IFSChar(LocClobData, ParIFSFile, ParFileOperation);                                                    
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFSXML                                                                              
  is 'Write XML data to IFS - Create New File';                                                                         
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFSXML                                                                            
  is 'Write XML data to an IFS File - Create a New File /                                                               
      Do not replace an existing one';                                                                                  
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write XML Data to the IFS - Create File and do not override                                        
--                   Parameter XML Data Type                                                                            
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFS_Create (In ParXML       XML,                                                     
                                               In PARIFSFILE   Varchar(1024))                                           
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFS_CreateXML                                                                                    
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
     Call WrtXML2IFS(ParXML, ParIFSFile, 8);                                                                            
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFS_CreateXML                                                                       
  is 'Write XML data to IFS - Create new File';                                                                         
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFS_CreateXML                                                                     
  is 'Write XML data to an IFS File - Create New File /                                                                 
      Do not replace an existing one';                                                                                  
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write XML data to the IFS - Create File and replace an existing one                                
--                   Parameter XML Data Type                                                                            
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFS_CreateReplace                                                                    
                                             (In ParXML     XML,                                                        
                                              In PARIFSFILE Varchar(1024))                                              
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFS_CreateReplaceXML                                                                             
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
     Call WrtXML2IFS(ParXML, ParIFSFile, 16);                                                                           
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFS_CreateReplaceXML                                                                
  is 'Write XML to IFS - Create/Replace File';                                                                          
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFS_CreateReplaceXML                                                              
  is 'Write XML Data to an IFS File - Create New File                                                                   
     and Replace an existing one';                                                                                      
                                                                                                                        
--******************************************************************************                                        
-- Stored Procedure: Write Textes to the IFS - Create File and append to an existing one                                
--                   Parameter XML Data Type                                                                            
--******************************************************************************                                        
Create Or Replace Procedure WrtXML2IFS_Append (In ParXML     XML,                                                       
                                               In PARIFSFILE Varchar(1024))                                             
       Language SQL                                                                                                     
       Modifies SQL Data                                                                                                
       Specific WrtXML2IFS_AppendXML                                                                                    
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
     Call WrtXML2IFS(ParXML, ParIFSFile, 32);                                                                           
   End;                                                                                                                 
                                                                                                                        
 Label On Specific Procedure WrtXML2IFS_AppendXML                                                                       
  is 'Write XML to IFS - Create/Append to File';                                                                        
                                                                                                                        
 Comment On Specific Procedure WrtXML2IFS_AppendXML                                                                     
  is 'Write XML Data to an IFS File - Create New File and                                                               
      Append to an existing one';                                                                      
