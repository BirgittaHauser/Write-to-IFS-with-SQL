      //*********************************************************************************************                   
      // H E A D E R    S P E C I F I C A T I O N S                                                                     
      //*********************************************************************************************                   
      // Create Service-Program                                                                                         
      // 1. Create Module:          CRTRPGMOD                                                                           
      // 2. Create Service Program: CRTSRVPGM SRVPGM(HSWRTIFS/SNDMSG)                                                   
      //                                      MODULE(SNDMSG)                                                            
      //                                      SRCFILE(HSWRTIFS/QSRVSRCBND)                                              
      //                                      BNDDIR(HSWRTIFS/HSBNDDIR)                                                 
      //  3. Delete Module                                                                                              
      //*********************************************************************************************                   
        Ctl-Opt DatFmt(*ISO)       DecEdit('0,')    DatEdit(*DMY.)    Debug                                             
                Option(*NoDebugIO: *ShowCpy: *Ext: *SRCSTMT: *NoUnref)                                                  
                ExtBinInt(*YES)    ExprOpts(*ResDecPos)                                                                 
                Thread(*SERIALIZE) CCSID(*CHAR: *JOBRUN)  AlwNull(*UsrCtl)                                              
                                                                                                                        
                NoMain;                                                                                                 
      //*********************************************************************************************                   
      // P R O T O T Y P E S                                                                                            
      //*********************************************************************************************                   
         /Include QPROLESRC,SndMsg                                                                                      
      //*********************************************************************************************                   
      // QMHSNDPM - Send Program Message                                                                                
      //*********************************************************************************************                   
       DCL-DS RefDSAPIError1  Qualified          Template;                                                              
         ByteProv             Int(10)            inz(%size(RefDSAPIError1));   //Bytes Provided                         
         ByteAvail            Int(10)            inz(*Zeros);                  //Bytes Available                        
         MsgId                Char(7)            inz(*Blanks);                 //Error-Id                               
         Reserved             Char(1)            inz(*Blanks);                 //Reserved                               
         ExceptData           Char(32767);                                     //Exeption Data                          
       End-Ds;                                                                                                          
                                                                                                                        
       DCL-PR QMHSNDPM   ExtPgm;                                                                                        
         ParMSGI         Char(7)    Const;                                     //Message Id                             
         ParFileLib      Char(20)   Const;                                     //Message Lib/File                       
         ParMsgData      Char(1024) Const  Options(*VarSize);                  //Var.Message Textes                     
         ParLenMsgD      Int(10)    Const;                                     //Length Var.Msg Textes                  
         ParMsgType      Char(10)   Const;                                     //Message Lib/File                       
         ParStackEntry   Char(10)   Const;                                     //Call Stack Entry                       
         ParStackCount   Int(10)    Const;                                     //Call Stack Counter                     
         ParMsgKey       Char(4)    Const;                                     //Message Key                            
         ParError1       LikeDS(RefDSAPIError1);                               //Error                                  
                                                                                                                        
         ParLenStackE    Int(10)    Const  Options(*NoPass);                   //Length all Stack Entry                 
         ParStackQual    Char(20)   Const  Options(*NoPass);                   //Call Stack Entry Qualification         
         ParDspWait      Int(10)    Const  Options(*NoPass);                   //Display Wait Time                      
                                                                                                                        
         ParStackType    Char(10)   Const  Options(*NoPass);                   //Call Stack Entry Data Type             
         ParCharSetI     Int(10)    Const  Options(*NoPass);                   //Coded Char. Set Identifier             
       End-PR;                                                                                                          
      //*********************************************************************************************                   
      // G L O B A L   V A R I A B L E S   A N D   D A T A   S T R U C T U R E S                                        
      //*********************************************************************************************                   
       //*********************************************************************************************                  
       // Procedure name: SndEscMsg                                                                                     
       // Purpose:        Send Escape Message from within a procedure                                                   
       // Returns:                                                                                                      
       // Parameter:      ParMsgText      => Message Text                                                               
       // Parameter:      ParStackCounter => Linear Main Procedures = 3                                                 
       //                                    Otherwise / Default    = 2                                                 
       // Programmer:     B.Hauser                                                                                      
       // Creation:       2018-01-21                                                                                    
       //*********************************************************************************************                  
       DCL-PROC SndEscMsg   EXPORT;                                                                                     
                                                                                                                        
         DCL-PI SndEscMsg;                                                                                              
           PInMsgText      VarChar(132) Const   Options(*Trim);                //Message Text                           
           PInStackCounter Int(10)      Const   Options(*NoPass);              //Call Stack Counter                     
         END-PI ;                                                                                                       
                                                                                                                        
         DCL-S  ParMsgText      Char(132);                                     //Error Data Structure                   
         DCL-S  ParStackCounter Int(10)     Inz(2);                            //Call Stack Counter                     
                                                                                                                        
         DCL-DS LocErrDS   LikeDS(RefDSAPIError1) Inz(*LikeDS);                //Error Data Structure                   
       //---------------------------------------------------------------------------------------------                  
         Monitor;                                                                                                       
                                                                                                                        
         ParMsgText = %Trim(PInMsgText);                                       //Message Text                           
                                                                                                                        
         If     %Parms >= %ParmNum(PInStackCounter)                            //With Call Stack Counter                
            and PInStackCounter > *Zeros;                                                                               
            ParSTackCounter = PInSTackCounter;                                                                          
         EndIf;                                                                                                         
                                                                                                                        
         QMHSNDPM('CPF9898':  'QCPFMSG   *LIBL':                                                                        
                  ParMsgText:  %Len(%Trim(ParMsgText)):    '*ESCAPE':                                                   
                  '*':         ParSTackCounter:  *Blanks:  LocErrDS);                                                   
         On-Error;                                                                                                      
         EndMon;                                                                                                        
                                                                                                                        
         Return ;                                                                                                       
                                                                                                                        
       END-PROC SndEscMsg;                                                                                              
       //*********************************************************************************************                  
       // Procedure name: SndEscMsgLinMain                                                                              
       // Purpose:        Send Escape Message from within a linear Main Procedure                                       
       // Returns:                                                                                                      
       // Parameter:      ParMsgText      => Message Text                                                               
       // Programmer:     B.Hauser                                                                                      
       // Creation:       2018-01-21                                                                                    
       //*********************************************************************************************                  
       DCL-PROC SndEscMsgLinMain   EXPORT;                                                                              
                                                                                                                        
         DCL-PI SndEscMsgLinMain;                                                                                       
           ParMsgText      VarChar(132) Const  Options(*Trim);                 //Message Text                           
         END-PI ;                                                                                                       
       //---------------------------------------------------------------------------------------------                  
         Monitor;                                                                                                       
                                                                                                                        
           SndEscMsg(ParMsgText: 4);                                                                                    
                                                                                                                        
         On-Error;                                                                                                      
         EndMon;                                                                                                        
                                                                                                                        
         Return ;                                                                                                       
                                                                                                                        
       END-PROC SndEscMsgLinMain;                                                                                          
