      //*********************************************************************************************
      // Program:    WrtUT82IFS
      // Purpose:    Write UTF-8 Data into the IFS
      // Parameters: ParUTF8     => UTF-8 data to be written into the IFS
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
                    ActGrp('WrtUT82IFS')
                /EndIf
                Main(WrtUT82IFS);
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
      // Main Procedure: WrtUT82IFS
      //*********************************************************************************************
       DCL-Proc WrtUT82IFS;

         DCL-PI WrtUT82IFS;
           ParUTF8     VarChar(16000000) CCSID(1208) Const;                    //Text to be written into the IFS
           ParIFSFile  VarChar(1024)                 Const;                    //IFS File Name
           PInOper     Int(5)                        Const  Options(*NoPass);  //File Operation
         End-Pi;

         DCL-S  ParOper         Int(5);                                        //File Operation

         DCL-S  LocErrMsg       Char(132);                                     //Error Message
         DCL-S  LocClobText     SQLType(Clob: 16000000) CCSID 1208;
         DCL-S  LocUTF8File     SQLTYPE(Clob_File);                            //IFS Reference File
       //  DCL-DS LocUTF8File     Inz;
       //     LOCUTF8FILE_NL      UNS(10);
       //     LOCUTF8FILE_DL      UNS(10);
       //     LOCUTF8FILE_FO      UNS(10);
       //     LOCUTF8FILE_NAME    CHAR(255) CCSID(1208);
       //  End-Ds;
         //--------------------------------------------------------------------------------------------
         Monitor;
            // Check in incoming paramters
            If %Len(%Trim(ParUTF8)) = *Zeros;
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
            Clear LocUTF8File;
            LocUTF8File_Name = %Trim(ParIFSFile);                              //IFS file Name
            LocUTF8File_NL   = %Len(%Trim(LocUTF8File_Name));                  //IFS file Name Length
            LocUTF8File_FO   = ParOper;                                        //File Operation

            LocClobText_Data = %TrimR(ParUTF8);
            LocClobText_Len  = %Len(%TrimR(LocClobText_Data));

            Exec SQL  Set :LocUTF8File = :LocClobText;
            If SQLCODE < *Zeros;
               Exec SQL Get Diagnostics Condition 1 :LocErrMsg = MESSAGE_TEXT;
               SndEscMsgLinMain(LocErrMsg);
            EndIf;

         On-Error;
            SndEscMsgLinMain(PGMSDS.MsgTxt);
         EndMon;
       End-Proc WrtUT82IFS; 
