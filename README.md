# Write-to-IFS-with-SQL
Character and XML data (data type XML) directly to the IFS with SQL 

## Description
This tool includes: 
<Table>
<tr><th>Program Type</th><th>Program/<br>Procedure Name</th><th>Description</th></tr>  
<tr><td>Service Program       </td><td><b>SNDMSG    </b></td><td>contains the (RPG) prodecures 
                                                                 for sending escape messages</td><tr>
<tr><td>SQLRPGLE Program      </td><td><b>WRT2IFS   </b></td><td>for writing any character data to the IFS</td></tr>
<tr><td>SQLRPGLE Program      </td><td><b>WRTXML2IFS</b></td><td>for writing XML data (Data type XML) to the IFS</td></tr>
<tr><td>SQL Stored Procedures </td><td><b>WRT2IFSxxxx</b></td><td>for writing any character data into the IFS.</br> 
                                                                 xxxx = File Operation <br>
                                                                 i.e. Create/CreateReplace/Append</td></tr>
<tr><td>SQL Stored Procedures </td><td><b>WRTXML2IFSxxxx</b></td><td>for writing XML data (data type XML) into the IFS.</br> 
                                                                 xxxx = File Operation 
                                                                 <br>i.e. Create/CreateReplace/Append</td></tr>
</Table>

## Author
<strong>Birgitta Hauser</strong> is Software and Database Engineer, focusing on RPG, SQL and Web development on IBM i at Toolmaker Advanced Efficiency GmbH in Germany. She also works in consulting with regard to modernizaing legacy IBM i applications IBM i as well as in education as a trainer for RPG and SQL developers. 

Since 2002 she has frequently spoken at the COMMON User Groups and other IBM i and Power Conferences in Germany, other European Countries, USA and Canada. 

In addition, she is co-author of two IBM Redbooks and also the author of several articles and papers focusing on RPG and SQL for a German publisher, IBM DeveloperWorks and IT Jungle.

## Compile
### SNDMSG Service Program
<ul><li>Create a module with the same name using the <strong>CRTRPGMOD</strong> CL command
      <pre>CRTRPGMOD MODULE(YOURSCHEMA/SNDMSG)       
                     SRCFILE(YOURSCHEMA/QSRVPGMSRC)  
                     SRCMBR(SNDMSG)      
      </pre>
  </li>
  <li>Create the service Program with the <strong>CRTSRVPGM</strong CL command</br>
      <pre>CRTSRVPGM SRVPGM(YOURSCHEMA/SNDMSG)                                                   
                     MODULE(SNDMSG)                                                            
                     SRCFILE(YOURSCHEMA/QSRVSRC)
                     SRCMBR(SNDMSG)
      </pre>
   </li>
  <li>Delete the module after having successfully created the service program.</li> 
</ul>

### RPG Programs
If you create a binder directory with the name <b>HSBNDDIR</b> in your schema and <b>add the SNDMSG service program</b> to this binder directory, the RPG programs can be compiled with the the <b>CRTSQLRPGI command</b>.
<pre>CRTSQLRPGI OBJ(YOURSCHEMA/WRTUT82IFS)     
                SRCFILE(YOURSCHEMA/QRPGLESRC)    
                SRCMBR(WRTUT82IFS)             
                OBJTYPE(*PGM)               
</pre>


### SQL Stored Procedures and User Defined Functions
The SQL Scripts containing the source code for the stored procedures, can be run with the <b>RUNSQLSTM command</b>:
<pre>RUNSQLSTM SRCFILE(YOURSCHEMA/QSQLSRC)   
               SRCMBR(TABLE2JSON)          
               COMMIT(*NONE)               
               NAMING(*SYS)                
               MARGINS(132)                
               DFTRDBCOL(YOURSCHEMA)</pre>  
               
It is also possible to run the SQL scripts from the b>RUN SQL SCRIPTING facility</b> in Client Access or (even better) ACS (Access Client Solution). 

<Table>
<tr><td><b>Attention:</b></td><td>The database objects are <b>not qualified</b> in the SQL script, <br>
                                   so you need to <b>add YOURSCHEMA</b> to the script by yourself.</td><tr>
</Table>
   
## Program and Procedure Descriptions:
### SNDMSG (RPG Service Program) – Sending Program Messages from within RPG
<Table>
  <tr><th>Function Name</th><th>Description</th></tr>
  <tr><td><b>SndEscMsg       </b></td><td>Send Escape message from within an RPG internal or exported procedure.</td></tr>
  <tr><td><b>SndEscMsgLinMain</b></td><td>Send Escape message from within an RPG linear main procedure</td></tr>
</Table>  
    
Both procedures are needed for signaling errors in the WRT2IFS and WRTXML2IFS RPG Programs. 

### WRT2IFS (RPG Program) – Write Character Data to the IFS
Parameter:  
<table>
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>
<tr><td><b>ParText     </b></td><td>VarChar(16000000)</td><td>Text to be written into the IFS</td></tr>
<tr><td><b>ParIFSFile  </b></td><td>VarChar(1024)    </td><td>IFS File to be written, replaced or appended</td></tr>
<tr><td><b>ParOperation</b></td><td>Integer          </td><td>8=Create / 16=Replace / 32=Append<td></tr>
</table>  

With the WRT2IFS program any character data can be written to the IFS into the passed IFS file.
Depening on the file operation a new file will be created, or replaced or the data is added to an existing IFS file.
The program WRT2IFS is registered as SQL Stored Procedure.
                    
### WRTXML2IFS (RPG Program) – Write XML Data to the IFS
Parameter:  
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParXML        </b></td><td>VarChar(16000000)</td><td>Serialized XML data to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile    </b></td><td>VarChar(1024)    </td><td>IFS File to be written, replaced or appended</td><tr>
<tr><td><b>ParOperation  </b></td><td>Integer          </td><td>8=Create / 16=Replace / 32=Append</td><tr>
</table>  

With the WRTXML2IFS program wellformed XML data can be written to the IFS.
epening on the file operation a new file will be created, or replaced or the data is added to an existing IFS file.
The program WRTXML2IFS is registered as SQL Stored Procedure.

### WRT2IFSxxxxx (Stored Procedures) – Write Character Data into the IFS
### WRT2IFS - Write Data to the IFS
Parameter: 
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParText        </b></td><td>CLOB(16 M)       </td><td>Text to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile     </b></td><td>VarChar(1024)    </td><td>IFS File to be written, replaced or appended</td><tr>
<tr><td><b>ParOperation   </b></td><td>Integer          </td><td>8=Create / 16=Replace / 32=Append</td><tr>
</table>  

The WRT2IFS stored procedure is a wrapper around the WRT2IFS RPG Program.
The WRT2IFSxxxxx stored procedures call the WRTIFS stored procedure with a specific File Operation.

Example:  
<pre>
Call wrt2IFS('This is a test for checking whether data is written to the IFS', 
             '/home/Hauser/Test20180224', 8);</pre>

### WRT2IFS_CREATE – Write Character Data to the IFS – Create a New File
Parameter: 
<table>
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>    
<tr><td><b>ParText      </b></td><td>CLOB(16 M)           </td><td>Text to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)        </td><td>IFS File to be written, replaced or appended</td><tr>
</table>

Calls the WRT2IFS Procedure, the File Operation is passed fix with 8.
A new IFS file will be created. If the file already exists an error will be returned.

Example: 
<pre>
Call Wrt2IFS_Create(Cast('{"root": {"Name": "Hauser", 
                                    "FirstName": "Birgitta"}' as VarChar(256) CCSID 1208), 
                         '/home/Hauser/Tst20180224');</pre>

### WRT2IFS_CREATEREPLACE – Write Character Data to the IFS – Replace an existing files
Parameter: 
<table>
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>    
<tr><td><b>ParText      </b></td><td>CLOB(16 M)           </td><td>Text to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)        </td><td>IFS File to be written, replaced or appended</td><tr>
</table>

Calls the WRT2IFS Procedure, the File Operation is passed fix with 16.
A new IFS file will be created. If the file already exists the existing one is replaced.

Example: 
<pre>
Call Wrt2IFS_CreateReplace(Cast('{"root": {"Name": "Hauser", 
                                           "FirstName": "Birgitta", 
                                           "City": "Kaufering"}' as VarChar(256) CCSID 1208), 
                           '/home/Hauser/Tst20180224');</pre>

### WRT2IFS_APPEND – Write Character Data to the IFS – Append data to an existing one
Parameter: 
<table>
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>    
<tr><td><b>ParText      </b></td><td>CLOB(16 M)           </td><td>Text to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)        </td><td>IFS File to be written, replaced or appended</td><tr>
</table>

Calls the WRT2IFS Procedure, the File Operation is passed fix with 32
A new IFS file will be created. If the file already exists the text is appended at the end.

Example: 
<pre>
Call Wrt2IFS_Append(Cast(', {"Street": "Dr.-Gerbl-Str.", 
                             "HausNr": 20}}' as VarChar(256) CCSID 1208), 
                    '/home/Hauser/Tst20180224');</pre>

### WRTXML2IFSxxxx (Stored Procedures) – Write XML Data to the IFS
### WRTXML2IFS
Parameter: 
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParText        </b></td><td>XML              </td><td>XML data to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile     </b></td><td>VarChar(1024)    </td><td>IFS File to be written, replaced or appended</td><tr>
<tr><td><b>ParOperation   </b></td><td>Integer          </td><td>8=Create / 16=Replace / 32=Append</td><tr>
</table>  

The WRTXML2IFS stored procedure is a Wrapper around the WRTXML2IFS RPG Program.
The WRTXML2IFSxxxxx stored procedure call the WRTXML2IFS stored procedure with a specific File Operation.

Example:
<pre>
Call WrtXML2IFS(XMLElement(Name "root", XMLElement(Name "Name", 'Hauser')), 
                           '/home/Hauser/TstXML20180224.xml', 16);</pre>

### WRTXML2IFS_CREATE – Write XML Data to the IFS – Create a New File
Parameter: 
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParText      </b></td><td>XML                 </td><td>XML Data to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)       </td><td>IFS File to be written, replaced or appended</td><tr>
</table>  
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 8
A new IFS file will be created. If the file already exists an error will be returned

Example: 
<pre>
Call WrtXML2IFS_Create(XMLElement(Name "root", XMLElement(Name "Name", 'Hauser')), 
                      '/home/Hauser/TstXML20180224.xml');</pre>

### WRT2IFS_CREATEREPLACE – Write XML Data to the IFS – Replace an existing file
Parameter: 
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParText      </b></td><td>XML                 </td><td>XML Data to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)       </td><td>IFS File to be written, replaced or appended</td><tr>
</table>  
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 16
A new IFS file will be created. If the file already exists the existing one is replaced.

Example: 
<pre>
Call WrtXML2IFS_CreateReplace(XMLElement(Name "root", 
                                         XMLElement(Name "Name", 'Hauser'), 
                                         XMLElement(Name "FirstName", 'Birgitta')), 
                              '/home/Hauser/TstXML20180224.xml');```</pre>

### WRT2IFS_APPEND – Write XML Data to the IFS – Append data to an existing file
Parameter: 
<table>  
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>  
<tr><td><b>ParText      </b></td><td>XML                 </td><td>XML Data to be written into the IFS</td><tr>
<tr><td><b>ParIFSFile   </b></td><td>VarChar(1024)       </td><td>IFS File to be written, replaced or appended</td><tr>
</table>  
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 32
A new IFS file will be created. If the file already exists the text is appended at the end.

