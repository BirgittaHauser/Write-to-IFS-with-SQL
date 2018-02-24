# Write-to-IFS-with-SQL
Generate XML and JSON data and write them directly to the IFS with SQL 

## Description
This tool includes: 
<Table>
<tr><th>Program Type</th><th>Program/Procedure Name</th><th>Description</th></tr>  
<tr><td>Service Program       </td><td><b>SNDMSG    </b></td><td>contains the (RPG) prodecures 
                                                                 for sending escape messages</td><tr>
<tr><td>RPGLE Program         </td><td><b>WRT2IFS   </b></td><td>for writing any text to the IFS</td></tr>
<tr><td>RPG Program           </td><td><b>WRTXML2IFS</b></td><td>for writing XML data (Data type XML) to the IFS</td></tr>
<tr><td>SQL Stored Procedures </td><td><b>WRTIFSxxxx</b></td><td>for writing any character data into the IFS.</br> 
                                                                 xxxx = File Operation <br>
                                                                 i.e. Create/CreateReplace/Append</td></tr>
<tr><td>SQL Stored Procedures </td><td><b>WRTIFSxxxx</b></td><td>for writing XML data (data type XML) into the IFS.</br> 
                                                                 xxxx = File Operation 
                                                                 <br>i.e. Create/CreateReplace/Append</td></tr>
<tr><td>SQL Stored Procedure  </td><td><b>TABLE2XML </b></td><td> for generating the XML data for a complete Db2 table</td></tr>
<tr><td>SQL Stored Procedure  </td><td><b>JSON2XML  </b></td><td> for generating the XML data for a complete Db2 table</td></tr>
</Table>

## Author
<strong>Birgitta Hauser</strong> has been a Software and Database Engineer since 2008, focusing on RPG, SQL and Web development on IBM i at Toolmaker Advanced Efficiency GmbH in Germany. She also works in consulting with regard to modernizaing applications on the IBM i as well as in education as a trainer for RPG and SQL developers. 

Since 2002 she has frequently spoken at the COMMON User Groups and other IBM i and Power Conferences in Germany, other European Countries, USA and Canada. 

In addition, she is co-author of two IBM Redbooks and also the author of several articles and papers focusing on RPG and SQL for a German publisher, iPro Developer and IBM DeveloperWorks.

## Compile
### SNDMSG Service Program
<ul><li>Create a module with the <strong>CRTRPGMOD</strong> CL command</li>
  <li>Create the service Program with the <strong>CRTSRVPGM</strong CL command</br>
      <pre>CRTSRVPGM SRVPGM(YOURSCHEMA/SNDMSG)                                                   
                MODULE(SNDMSG)                                                            
                SRCFILE(YOURSCHEMA/QSRVSRC)</pre>
   </li></ul>
   
If you create a binder directory with the name <b>HSBNDDIR<b> in your schema and <b>add the SNDMSG service program</b> to this binder directory, the RPG programs can be compiled with the the <b>CRTBNDRPG command</b>.

The SQL Scripts containing the source code for the stored procedures, can be run with the RUNSQLSTM command:
<pre>RUNSQLSTM SRCFILE(YOURSCHEMA/QSQLSRC)   
               SRCMBR(TABLE2JSON)          
               COMMIT(*NONE)               
               NAMING(*SYS)                
               MARGINS(132)                
               DFTRDBCOL(YOURSCHEMA)</pre>  
               
It is also possible to run the SQL scripts from the RUN SQL SCRIPTING facility in Client Access or (even better) ACS (Access Client Solution). 
<Table>
<tr><td>
  <b>Attention:</b></td><td>The database objects are <b>not qualified</b> in the SQL script, <br>so you need to <b>add YOURSCHEMA</b> to the script by yourself.</td><tr>
   
## Programs and Procedures:
### SNDMSG (RPG Service Program) – Sending Program Messages from within RPG
<Table>
  <tr><th>Function Name</th><th>Description</th></tr>
  <tr><td><b>SndEscMsg</b></td><td>Send Escape message from within an RPG internal or exported procedure.</td></tr>
  <tr><td><b>SndEscMsgLinMain</b></td><td>Send Escape message from within an RPG linear main procedure</td></tr>
</Table>  
    
Both procedures are necessary for signaling errors in the WRT2IFS RPG Program. 

### WRT2IFS (RPG Program) – Write Character Data to the IFS
Parameter:  
<Table>
<tr><th>Parameter Name</th><th>Data Type/Length</th><th>Description</th></tr>
<tr><td><b>ParText</b></td><td>VarChar(16000000)</td><td>Text to be written into the IFS</td></tr>
<tr><td><b>ParIFSFile</b></td><td>VarChar(1024)</td><td>IFS File to be written, replaced or appended</td></tr>
<tr><td><b>ParOperation</b></td><td>Integer</td><td>8=Create / 16=Replace / 32=Append<td></tr>
</table>  
                    
### WRTXML2IFS (RPG Program) – Write XML Data to the IFS
  Parameter:  ParXML        – VarChar(16000000) – Serialized XML data to be written into the IFS
              ParIFSFile    – VarChar(1024)     – IFS File to be written, replaced or appended
              ParOperation  – Integer           – 8=Create / 16=Replace / 32=Append

### WRT2IFSxxxxx (Stored Procedures) – Write Character Data into the IFS
  WRT2IFS – Write Character Data to the IFS --> Wrapper around the RPG Program WRT2IFS
  Parameter: ParText        – CLOB(16 M)       - Text to be written into the IFS
             ParIFSFile     – VarChar(1024)    – IFS File to be written, replaced or appended
             ParOperation   – Integer          – 8=Create / 16=Replace / 32=Append

      Example:  
<pre>
Call wrt2IFS('This is a test for checking whether data is written to the IFS', 
             '/home/Hauser/Test20180224', 8);</pre>

### WRT2IFS_CREATE – Write Character Data to the IFS – Create a New File
Parameter: ParText      – CLOB(16 M)           - Text to be written into the IFS
           ParIFSFile   – VarChar(1024)        – IFS File to be written, replaced or appended
   
Calls the WRT2IFS Procedure, the File Operation is passed fix with 8
A new IFS file will be created. If the file already exists an error will be returned.

Example: 
<pre>
Call Wrt2IFS_Create(Cast('{"root": {"Name": "Hauser", 
                                    "FirstName": "Birgitta"}' as VarChar(256) CCSID 1208), 
                         '/home/Hauser/Tst20180224');</pre>

### WRT2IFS_CREATEREPLACE – Write Character Data to the IFS – Replace an existing files
Parameter: ParText      – CLOB(16 M)         - Text to be written into the IFS
           ParIFSFile   – VarChar(1024)      – IFS File to be written, replaced or appended
   
Calls the WRT2IFS Procedure, the File Operation is passed fix with 16
A new IFS file will be created. If the file already exists the existing one is replaced.

Example: 
<pre>
Call Wrt2IFS_CreateReplace(Cast('{"root": {"Name": "Hauser", 
                                           "FirstName": "Birgitta", 
                                           "City": "Kaufering"}' as VarChar(256) CCSID 1208), 
                           '/home/Hauser/Tst20180224');</pre>

### WRT2IFS_APPEND – Write Character Data to the IFS – Append data to an existing one
Parameter: ParText      – CLOB(16 M)      - Text to be written into the IFS
           ParIFSFile   – VarChar(1024)   – IFS File to be written, replaced or appended
               
Calls the WRT2IFS Procedure, the File Operation is passed fix with 32
A new IFS file will be created. If the file already exists the text is appended at the end.

Example: 
<pre>
Call Wrt2IFS_Append(Cast(', {"Street": "Dr.-Gerbl-Str.", 
                             "HausNr": 20}}' as VarChar(256) CCSID 1208), 
                    '/home/Hauser/Tst20180127');</pre>

### WRTXML2IFSxxxx (Stored Procedures) – Write XML Data to the IFS
WRTXML2IFS – Write XML Data to the IFS --> Wrapper around the RPG Program WRT2IFS
Parameter: ParText          – XML             – XML Data to be written into the IFS
           ParIFSFile       – VarChar(1024)   – IFS File to be written, replaced or appended
           ParOperation     – Integer         – 8=Create / 16=Replace / 32=Append

Example: 
<pre>
Call WrtXML2IFS(XMLElement(Name "root", XMLElement(Name "Name", 'Hauser')), 
                           '/home/Hauser/TstXML20180127.xml', 16);</pre>

### WRTXML2IFS_CREATE – Write XML Data to the IFS – Create a New File
Parameter: ParText      – XML                 – XML Data to be written into the IFS
           ParIFSFile   – VarChar(1024)       – IFS File to be written, replaced or appended
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 8
A new IFS file will be created. If the file already exists an error will be returned

Example: 
<pre>
Call WrtXML2IFS_Create(XMLElement(Name "root", XMLElement(Name "Name", 'Hauser')), 
                      '/home/Hauser/TstXML20180127.xml');</pre>

### WRT2IFS_CREATEREPLACE – Write XML Data to the IFS – Replace an existing file
Parameter: ParText       – XML               – XML Data to be written into the IFS
           ParIFSFile    – VarChar(1024)     – IFS File to be written, replaced or appended
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 16
A new IFS file will be created. If the file already exists the existing one is replaced.

Example: 
<pre>
Call WrtXML2IFS_CreateReplace(XMLElement(Name "root", 
                                         XMLElement(Name "Name", 'Hauser'), 
                                         XMLElement(Name "FirstName", 'Birgitta')), 
                              '/home/Hauser/TstXML20180224.xml');```</pre>

### WRT2IFS_APPEND – Write XML Data to the IFS – Append data to an existing file
Parameter: ParText     – XML                 – XML Data to be written into the IFS
           ParIFSFile  – VarChar(1024)       - IFS File to be written, replaced or appended
   
Calls the WRTXML2IFS Procedure, the File Operation is passed fix with 32
A new IFS file will be created. If the file already exists the text is appended at the end.

### TABLE2XML – Create an XML Document for a table with all columns
Parameter: ParTable     – VarChar(128)    – Table (SQL Name) to be converted into XML
            ParSchema    – VarChar(128)    – Schema (SQL Name) of  the table to be converted into XML
            ParWhere     – VarChar(4096)   – Additional Where Conditions (without leading WHERE) for reducing the data 
                                             (Optional --> Default = ‘’)
            ParOrderBy   – VarChar(1024)   – Order by clause (without leading ORDER BY) for sorting the result 
                                             (Optional --> Default = ‘’)
            ParRoot      – VarChar(128)    - Name of the Root Element (Optional --> Default = ‘”rowset”’)
            ParRow       – VarChar(128)    – Name of the Row Element (Optional --> Default = ‘”row”’)
            ParAsAttributes - VarChar(1)   – Y = single empty element per row, 
                                             all column data are passed as attributes (Optional  Default = ‘’)

Description:
For the passed table a list of all columns separated by a comma is generated with the LIST_AGG Aggregate function 
from the SYSCOLUMS view.
With this information and the passed parameter information a XMLGROUP Statement is performed that returns the XML data.

Example:             
<pre>Values(Table2XML('ADDRESSX', 'HSCOMMON05'));</pre>    

<pre>
Values(Table2XML('ADDRESSX', 'HSCOMMON05',
                 ParWhere       => 'ZipCode between ''70000'' and ''80000''',
                 ParOrderBy     => 'ZipCode, CustNo'));</pre>  
 
<pre>
Call WrtXML2IFS_Create(Table2XML('Umsatz', 'HSCOMMON05', 
                                 ParWhere        => 'Year(VerkDatum) = 2005', 
                                 ParOrderBy      => 'VerkDatum, KundeNr Desc',
                                 ParRoot         => '"Sales"',
                                 ParRow          => '"SalesRow"' --,
                                 ParAsAttributes => 'Y'),
                        '/home/Hauser/Umsatz20180127.xml'); </pre> 
                 
### TABLE2JSON – Create JSON Data for a table containing all columns
Parameter: ParTable        – VarChar(128)    – Table (SQL Name) to be converted into XML
           ParSchema       – VarChar(128)    – Schema (SQL Name) of  the table to be converted into XML
           ParWhere        – VarChar(4096)   – Additional Where Conditions 
                                              (without leading WHERE) for reducing the data (Optional => Default = ‘’)
           ParOrderBy      – VarChar(1024)   – Order by clause (without leading ORDER BY) 
                                              for sorting the result (Optional => Default = ‘’)
               
 Description:
 For the passed table a list containing with columns separated by a comma is generated with the ListAgg Aggregate function 
 from the SYSCOLUMS view.
 With this information and the passed parameter information and a composition of the JSON_ArrayAgg and JSON_Object functions
 the JSON Data is created.

 Example:             
 <pre>Values(Table2JSON('ADDRESSX', 'HSCOMMON05'));</pre>    


<pre>
Values(Table2JSON('ADDRESSX', 'HSCOMMON05',
                  ParWhere       => 'ZipCode between ''70000'' and ''80000''',
                  ParOrderBy     => 'ZipCode, CustNo'));</pre>   
 
<pre>
Call WrtJSON2IFS_Create(Table2JSON('Umsatz', 'HSCOMMON05', 
                                   ParWhere    => 'Year(VerkDatum) = 2005', 
                                   ParOrderBy  => 'VerkDatum, KundeNr Desc',
                                   ParRoot     => '"Sales"'),         
                        '/home/Hauser/Umsatz20180224.json');</pre>             

