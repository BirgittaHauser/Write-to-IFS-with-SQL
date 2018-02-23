      /If Not Defined (SndEscMsg)                                                                                       
      /Define SndEscMsg                                                                                                 
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
         DCL-PR SndEscMsg;                                                                                              
           ParMsgText      VarChar(132) Const   Options(*Trim);                //Message Text                           
           PInStackCounter Int(10)      Const   Options(*NoPass);              //Call Stack Counter                     
         END-PR ;                                                                                                       
      /EndIf                                                                                                            
                                                                                                                        
      /If Not Defined (SndEscMsgLinMain)                                                                                
      /Define SndEscMsgLinMain                                                                                          
       //*********************************************************************************************                  
       // Procedure name: SndEscMsgLinMain                                                                              
       // Purpose:        Send Escape Message from within a linear Main Procedure                                       
       // Returns:                                                                                                      
       // Parameter:      ParMsgText      => Message Text                                                               
       // Programmer:     B.Hauser                                                                                      
       // Creation:       2018-01-21                                                                                    
       //*********************************************************************************************                  
         DCL-PR SndEscMsgLinMain;                                                                                       
           ParMsgText      VarChar(132) Const  Options(*Trim);                 //Message Text                           
         END-PR ;                                                                                                       
      /EndIf                                                                  
