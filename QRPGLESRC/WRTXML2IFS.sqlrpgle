      //*********************************************************************************************                   
      // Program:    WrtXML2IFS                                                                                         
      // Purpose:    Write XML Data into the IFS                                                                        
      // Parameters: ParXML     => XML data to be written into the IFS                                                  
      //             ParIFSFile  => Qualified IFS File name (e.g. /home/Hauser/MyIFSFile.txt')                          
      //             ParFileOpt  => File Operation: 8 = Create a new file, return an error if already exists            
      //                                           16 = Create a new file, override if already exists                   
      //                                           32 = Create a new file, append at the end if already exists          
      //                            Optional: Not Passed = File Operation 8 = SQFCRT                                    
      // Programmer: B.Hauser                                                                                           
      // Creation:   2017-01-20                                                                                         
      //*********************************************************************************************                   
      // H E A D E R    S P E C I F I C A T I O N S                                                                     
      //*********************************************************************************************                   
        Ctl-Opt DatFmt(*ISO)  BNDDIR('HSBNDDIR')                                                                        
                /If Defined (*CRTBNDRPG)                                                                                
                    ActGrp('WrtXML2IFS')                                                                                
                /EndIf                                                                                                  
                Main(WrtXML2IFS);                                                                                       
                //CCSID(*Char: *UTF8)                                                                                   
      //*********************************************************************************************                   
      // P R O T O T Y P E S                                                                                            
      //*********************************************************************************************                   
      /Include QPROLESRC,SNDMSG                                                                                         
      //*********************************************************************************************                   
      // G L O B A L   V A R I A B L E S   A N D   D A T A   S T R U C T U R E S                                        
      //*********************************************************************************************                   
        DCL-DS PGMSDS   PSDS       Qualified;                                                                           
          MsgTxt        Char(80)   Pos(91);                                                                             
        End-Ds;                                                                                                         
      //*********************************************************************************************                   
      // S Q L   O P T I O N S                                                                                          
      //*********************************************************************************************                   
       Exec SQL   Set Option  Commit=*None, DatFmt=*ISO, TimFmt=*ISO,                                                   
                              Naming=*SYS,  CloSQLCsr=*EndActGrp;                                                       
      //*********************************************************************************************                   
      // M A I N   P R O G R A M                                                                                        
      //*********************************************************************************************                   
      // Main Procedure: WrtXML2IFS                                                                                     
      //*********************************************************************************************                   
       DCL-Proc WrtXML2IFS;                                                                                             
                                                                                                                        
         DCL-PI WrtXML2IFS;                                                                                             
           ParXML          VarChar(16000000)  Const;                           //Text to be written into the IFS        
           ParIFSFile      VarChar(1024)      Const;                           //IFS File Name                          
           PInOper         Int(5)             Const  Options(*NoPass);         //File Operation                         
         End-Pi;                                                                                                        
                                                                                                                        
         DCL-S  ParOper         Int(5);                                        //File Operation                         
                                                                                                                        
         DCL-S  LocErrMsg       Char(132);                                     //Error Message                          
         DCL-S  LocClobText     SQLType(Clob: 16000000);                                                                
         DCL-S  LocXMLFile      SQLTYPE(XML_Clob_File)    CCSID 1208;          //IFS Reference File                     
         //--------------------------------------------------------------------------------------------                 
         Monitor;                                                                                                       
            // Check in incoming paramters                                                                              
            If %Len(%Trim(ParXML)) = *Zeros;                                                                            
               SndEscMsgLinMain('No Text passed');                                                                      
            EndIf;                                                                                                      
                                                                                                                        
            If %Len(%Trim(ParIFSFile)) = *Zeros;                                                                        
               SndEscMsgLinMain('No IFS File specified');                                                               
            EndIf;                                                                                                      
                                                                                                                        
            If %Parms >= %ParmNum(PInOper);                                    //With Operation                         
               If PInOper = SQFCRT or PInOper = SQFOVR or PInOper = SQFAPP;                                             
                  ParOper = PInOper;                                           //Valid Operation                        
               ElseIf PInOper <> *Zeros;                                       //Invalid Operation                      
                  SndEscMsgLinMain('Invalid File Operation');                                                           
               EndIf;                                                                                                   
            Else;                                                                                                       
               ParOper = SQFCRT;                                               //Default = Create                       
            EndIf;                                                                                                      
                                                                                                                        
            //Initialize File Information                                                                               
            Clear LocXMLFile;                                                                                           
            LocXMLFile_Name = %Trim(ParIFSFile);                               //IFS file Name                          
            LocXMLFile_NL   = %Len(%Trim(LocXMLFile_Name));                    //IFS file Name Length                   
            LocXMLFile_FO   = ParOper;                                         //File Operation                         
                                                                                                                        
            LocClobText_Data = ParXML;                                                                                  
            LocClobText_Len  = %Len(ParXML);                                                                            
            Exec SQL  Set :LocXMLFile = XMLParse(Document :LocClobText);                                                
            If SQLCODE < *Zeros;                                                                                        
               Exec SQL Get Diagnostics Condition 1 :LocErrMsg = MESSAGE_TEXT;                                          
               SndEscMsgLinMain(LocErrMsg);                                                                             
            EndIf;                                                                                                      
                                                                                                                        
         On-Error;                                                                                                      
            SndEscMsgLinMain(PGMSDS.MsgTxt);                                                                            
         EndMon;                                                                                                        
       End-Proc WrtXML2IFS;                                                                                                             
