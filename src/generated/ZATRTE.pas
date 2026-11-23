(*=y+,s0,s7*)
(*=L1*) PROGRAM ZATRTE (*ЗT:PEГИC.TEM (YCEЧEHHAЯ)*)
type
  alfa = packed array[1..6] of char;
  TYPEM = packed array[1..1344] of char;
  ZZBUFT = record LEN,H,D,I:integer; M,MV:TYPEM end;
var
  BUF: ZZBUFT;
  C: char;
procedure DML(B:boolean); external;
procedure DmlCall(N:integer);
var J:integer;
begin
  for J:=1 to 1344 do BUF.M[J]:=' ';
  case N of
    299: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='З';BUF.M[12]:='T';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    300: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='T';BUF.M[20]:='E';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    301: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='T';
      BUF.M[9]:='E';BUF.M[10]:='M';BUF.M[11]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    302: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    303: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='Э';
      BUF.M[9]:='T';BUF.M[10]:='A';BUF.M[11]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    304: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    305: begin
      BUF.LEN:=38;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    306: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    307: begin
      BUF.LEN:=54;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';BUF.M[39]:=';';BUF.M[40]:='B';
      BUF.M[41]:='K';BUF.M[42]:='Л';BUF.M[43]:='Ю';BUF.M[44]:='Ч';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:=' ';
      BUF.M[49]:='И';BUF.M[50]:='C';BUF.M[51]:='-';BUF.M[52]:='И';
      BUF.M[53]:='C';BUF.M[54]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    308: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    309: begin
      BUF.LEN:=54;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='И';BUF.M[34]:='C';BUF.M[35]:='П';BUF.M[36]:='O';
      BUF.M[37]:='Л';BUF.M[38]:='H';BUF.M[39]:=';';BUF.M[40]:='B';
      BUF.M[41]:='K';BUF.M[42]:='Л';BUF.M[43]:='Ю';BUF.M[44]:='Ч';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:=' ';
      BUF.M[49]:='И';BUF.M[50]:='C';BUF.M[51]:='-';BUF.M[52]:='И';
      BUF.M[53]:='C';BUF.M[54]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    310: begin
      BUF.LEN:=70;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='O';BUF.M[30]:='T';BUF.M[31]:='Д';BUF.M[32]:='E';
      BUF.M[33]:='Л';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='З';BUF.M[38]:='B';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:=' ';BUF.M[43]:='C';BUF.M[44]:='!';
      BUF.M[45]:='.';BUF.M[46]:='A';BUF.M[47]:='!';BUF.M[48]:=';';
      BUF.M[49]:=' ';BUF.M[50]:='H';BUF.M[51]:='A';BUF.M[52]:='Й';
      BUF.M[53]:='T';BUF.M[54]:='И';BUF.M[55]:=' ';BUF.M[56]:='П';
      BUF.M[57]:='E';BUF.M[58]:='P';BUF.M[59]:='B';BUF.M[60]:='Y';
      BUF.M[61]:='Ю';BUF.M[62]:=' ';BUF.M[63]:='B';BUF.M[64]:=' ';
      BUF.M[65]:='И';BUF.M[66]:='C';BUF.M[67]:='-';BUF.M[68]:='И';
      BUF.M[69]:='C';BUF.M[70]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    311: begin
      BUF.LEN:=29;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='Б';BUF.M[8]:='Д';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='И';BUF.M[15]:='C';BUF.M[16]:='П';
      BUF.M[17]:='O';BUF.M[18]:='Л';BUF.M[19]:='H';BUF.M[20]:=' ';
      BUF.M[21]:='H';BUF.M[22]:='A';BUF.M[23]:=' ';BUF.M[24]:='T';
      BUF.M[25]:='E';BUF.M[26]:='K';BUF.M[27]:='З';BUF.M[28]:='A';
      BUF.M[29]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    312: begin
      BUF.LEN:=52;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='Б';
      BUF.M[9]:='Д';BUF.M[10]:='-';BUF.M[11]:='K';BUF.M[12]:='Л';
      BUF.M[13]:='Ю';BUF.M[14]:=' ';BUF.M[15]:='И';BUF.M[16]:='C';
      BUF.M[17]:='П';BUF.M[18]:='O';BUF.M[19]:='Л';BUF.M[20]:='H';
      BUF.M[21]:=' ';BUF.M[22]:='H';BUF.M[23]:='A';BUF.M[24]:=' ';
      BUF.M[25]:='T';BUF.M[26]:='E';BUF.M[27]:='K';BUF.M[28]:='З';
      BUF.M[29]:='A';BUF.M[30]:='П';BUF.M[31]:=';';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='C';BUF.M[39]:='Л';BUF.M[40]:='E';
      BUF.M[41]:='Д';BUF.M[42]:='Y';BUF.M[43]:='Ю';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='И';BUF.M[48]:='C';
      BUF.M[49]:='-';BUF.M[50]:='И';BUF.M[51]:='C';BUF.M[52]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    313: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    314: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    315: begin
      BUF.LEN:=38;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='Э';BUF.M[8]:='T';
      BUF.M[9]:='A';BUF.M[10]:='П';BUF.M[11]:='.';BUF.M[12]:='H';
      BUF.M[13]:='O';BUF.M[14]:='M';BUF.M[15]:='E';BUF.M[16]:='P';
      BUF.M[17]:=' ';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:=' ';
      BUF.M[21]:='C';BUF.M[22]:='!';BUF.M[23]:='.';BUF.M[24]:='Ц';
      BUF.M[25]:='!';BUF.M[26]:=';';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Й';BUF.M[30]:='T';BUF.M[31]:='И';BUF.M[32]:=' ';
      BUF.M[33]:='C';BUF.M[34]:='Л';BUF.M[35]:='E';BUF.M[36]:='Д';
      BUF.M[37]:='Y';BUF.M[38]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    316: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    317: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ц';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='T';BUF.M[23]:='E';BUF.M[24]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    318: begin
      BUF.LEN:=24;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='A';BUF.M[15]:='!';BUF.M[16]:=' ';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='S';BUF.M[20]:='Y';
      BUF.M[21]:='-';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    319: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    320: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='Э';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='З';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    321: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='Э';BUF.M[20]:='T';
      BUF.M[21]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    322: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='T';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='C';
      BUF.M[21]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    323: begin
      BUF.LEN:=37;
      BUF.M[1]:='И';BUF.M[2]:='C';BUF.M[3]:='K';BUF.M[4]:='Л';
      BUF.M[5]:='Ю';BUF.M[6]:='Ч';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='И';BUF.M[11]:='C';BUF.M[12]:='-';
      BUF.M[13]:='И';BUF.M[14]:='C';BUF.M[15]:='П';BUF.M[16]:=';';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:='Й';BUF.M[20]:='T';
      BUF.M[21]:='И';BUF.M[22]:=' ';BUF.M[23]:='C';BUF.M[24]:='Л';
      BUF.M[25]:='E';BUF.M[26]:='Д';BUF.M[27]:='Y';BUF.M[28]:='Ю';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='T';
      BUF.M[33]:='E';BUF.M[34]:='-';BUF.M[35]:='И';BUF.M[36]:='C';
      BUF.M[37]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    324: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='T';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='Э';
      BUF.M[9]:='T';BUF.M[10]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    325: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='T';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='И';
      BUF.M[9]:='C';BUF.M[10]:='П';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    326: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='T';
      BUF.M[9]:='E';BUF.M[10]:='M';BUF.M[11]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(299)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:ЧИCДAT*)
(* EDITOR !INCLU:ЧИCMEC*)
(* EDITOR !INCLU:ЧИCKBA*)
(* EDITOR !INCLU:ДATЧИC*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:APИФM*)
(* EDITOR !INCLU:WINT*)
(* EDITOR !INCLU:WREAL*)
(* EDITOR !INCLU:WДAT*)
(* EDITOR !INCLU:WMEC*)
(* EDITOR !INCLU:WKBA*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:RSEP*)
(* EDITOR !INCLU:RINT*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)



(* SECTION ? .RШ *)
(*БЛOK PEГИCTPAЦИИ KAPT*)
PROCEDURE REGIS;
(* EDITOR !INCLU:LIST*)



(* SECTION ? .ПOC *)
(*ПOCTABИTЬ KAPTY*)
PROCEDURE ПOCTAB;
VAR TEKИCП,TEKCOИ:INT;
BEGIN
RESETCON;WITH ИCПOЛH DO(HOMEP:=-1;YPOB:=-1);
REPEAT WITH CUL!.CUC! DO SELECT
BOS!.NAM='THOMK ':(TEMA.HOMEP:=Ц!;
  DMLCALL(300);IF ПYCTO THEN(DMLCALL(301)));
BOS!.NAM='TЭTAП ':(ЭTAП.HOMEP:=Ц!;
  DMLCALL(302);IF ПYCTO THEN(DMLCALL(303)));
BOS!.NAM='TИCП  ':(WITH ИCПOЛH DO(HOMEP:=HOMEP+1;TEKИCП:=HOMEP);
  DMLCALL(304);IF ПYCTO THEN(
    DMLCALL(305)));
BOS!.NAM='TCOИ  ':(WITH ИCПOЛH DO(HOMEP:=HOMEP+1;TEKCOИ:=HOMEP);
  ЦEЛ.ЗH:=TEKИCП;
  DMLCALL(306);IF ПYCTO THEN(
    DMLCALL(307)));
BOS!.NAM='TПOД  ':(WITH ИCПOЛH DO HOMEP:=HOMEP+1;
  ЦEЛ.ЗH:=TEKCOИ;
  DMLCALL(308);IF ПYCTO THEN(
    DMLCALL(309))));
UNTIL NEXTCON;
YCTMOД;
WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA');PUTT;
END;



(* SECTION ? .GT *)
(*ПPOCMOTP ДEPEBA ПOДЧИHEHHOCTИ ИCПOЛHИTEЛEЙ*)
PROCEDURE GTREE(YPOB:INT);
VAR TEKЗAП:ZZBDKEY;C:!CONTENT;
BEGIN
CASE YPOB OF
1:FINDPAR('TИCП  ');
2:FINDPAR('TCOИ  ');
3:FINDPAR('TПOД  '));
NEWCONT(C);
DMLCALL(310)
WHILE MOЖHO DO(
  DMLCALL(311);GTREE(YPOB+1);
  DMLCALL(312));
END;



(* SECTION ? .BЗЯ *)
(*BЗЯTЬ KAPTY*)
PROCEDURE BЗЯTЬ;
VAR C:!CONTENT;
BEGIN
RESETCON;
(S)REPEAT WITH CUL!.CUC! DO SELECT
BOS!.NAM='THOMK ':EXIT S);
UNTIL NEXTCON;
(**)
DMLCALL(313);IF MOЖHO THEN GTREE(1);
(**)
DMLCALL(314)
WHILE MOЖHO DO(
  FINDPAR('TЭTAП ');NEWCONT(C);
  DMLCALL(315));
END;



(* SECTION ? .HAЙ *)
(*HAЙTИ KAPTY*)
PROCEDURE HAЙTИ;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='THOMK ':(DMLCALL(316)
  IF MOЖHO THEN EXIT ELSE(
    WRITE(OUT,'HET TAKOЙ TEMЫ');PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
END;



(* SECTION ? .HOB *)
(*BBOД HOBOЙ KAPTЫ*)
PROCEDURE HOB;
BEGIN
RESETPAR;CLEANCON;
REPEAT
NEXT:=TRUE;
WITH CUL!.CUP! DO REPEAT
READCON(NEXT);IF HAЧ THEN EXIT;
NEXT:=TRUE;
WITH CUL!.CUC! DO SELECT
NAM='THOMK ':(
  DMLCALL(317);
  IF NOT ПYCTO THEN(
    WRITE(OUT,'YЖE ECTЬ ЭTA TEMA');
    PUTT;NEXT:=FALSE));
(NAM='TИCП  ')OR(NAM='TCOИ  ')OR(NAM='TПOД  '):(
  DMLCALL(318);
  IF ПYCTO THEN(
    WRITE(OUT,'HET TAKOГO OTДEЛA');
    PUTT;NEXT:=FALSE)));
UNTIL NEXT;UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
END;



(* SECTION ? .ЭTA *)
(*BBOД HOBЫX ЭTAПOB*)
PROCEDURE ЭTA;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WRITELIST;
REPEAT
NEXT:=TRUE;
READCON(NEXT);IF HAЧ THEN EXIT;
UNTIL NEXTPAR;
(**)
IF CONFIRM THEN ПOCTAB;
END;



(* SECTION ? .ПPO *)
(*ПPOCMOTP KAPTЫ*)
PROCEDURE ПPO;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;WRITELIST;
END;



(* SECTION ? .ИCK *)
(*ИCKЛЮЧEHИE KAPTЫ*)
PROCEDURE ИCK;
PROCEDURE YHAP(H:INT);EXTERNAL;
BEGIN
HAЙTИ;IF HAЧ THEN EXIT;BЗЯTЬ;
DMLCALL(319)
WHILE MOЖHO DO(
  DMLCALL(320)
  IF NOT ПYCTO THEN(WRITE(OUT,
    'CHAЧAЛA HAДO ИCKЛЮЧИTЬ BCE ЗATPATЫ ПO TEME');PUTT;EXIT);
  DMLCALL(321));
IF NOT CONFIRM THEN EXIT;
DMLCALL(322)
WHILE MOЖHO DO(DMLCALL(323));
YHAP(DMLCALL(324));YHAP(DMLCALL(325));DMLCALL(326)
YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
FIL:=NIL;LOADLIST('CП-TEM');FINDLIST('CП-TEM');
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ TEM...');PUTT;
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP ЗAPEГИCTPИPOBAHHЫX KAPT/',
          'HOB - PEГИCTPAЦИЯ HOBЫX KAPT/',
          'ЭTA - ДOБABЛEHИE B TEMY HOBЫX ЭTAПOB/',
          'ИCK - ИCKЛЮЧEHИE KAPTЫ/');
MENU;
SELECT
  'ЭTA'=ДИP:ЭTA;
  'ПPO'=ДИP:ПPO;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'KOH'=ДИP:(KYДA:='HAPYЖY';CLEANALL;EXIT);
  'BЫX'=ДИP:(CLEANALL;EXIT));
);
END;



(* SECTION ? .B *)
BEGIN
REGIS;
END.
(* SECTION ? .ЗTTЗ *)
