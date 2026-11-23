(*=y+,s0,s7*)
(*=L1*) PROGRAM SKLCAR (*CK:KAPTЫ *)
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
    35: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='C';BUF.M[12]:='K';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    36: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='M';
      BUF.M[17]:='A';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    37: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='M';BUF.M[6]:='A';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='Y';BUF.M[10]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    38: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='O';BUF.M[6]:='T';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='Y';BUF.M[10]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    39: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='П';BUF.M[3]:=' ';BUF.M[4]:='O';
      BUF.M[5]:='T';BUF.M[6]:='Д';BUF.M[7]:='E';BUF.M[8]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    40: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    41: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='C';BUF.M[6]:='Y';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    42: begin
      BUF.LEN:=8;
      BUF.M[1]:='З';BUF.M[2]:='П';BUF.M[3]:=' ';BUF.M[4]:='C';
      BUF.M[5]:='Y';BUF.M[6]:='M';BUF.M[7]:='M';BUF.M[8]:='A';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    43: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='З';
      BUF.M[9]:='Я';BUF.M[10]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    44: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    45: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    46: begin
      BUF.LEN:=12;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    47: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    48: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    49: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    50: begin
      BUF.LEN:=55;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='Y';
      BUF.M[49]:='M';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    51: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='B';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    52: begin
      BUF.LEN:=76;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='M';BUF.M[30]:='A';BUF.M[31]:='T';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Ч';BUF.M[38]:=';';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:='Й';BUF.M[43]:='T';BUF.M[44]:='И';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='O';BUF.M[48]:='C';
      BUF.M[49]:='Л';BUF.M[50]:='E';BUF.M[51]:='Д';BUF.M[52]:=' ';
      BUF.M[53]:='B';BUF.M[54]:=' ';BUF.M[55]:='S';BUF.M[56]:='Y';
      BUF.M[57]:='-';BUF.M[58]:='M';BUF.M[59]:='A';BUF.M[60]:='T';
      BUF.M[61]:=';';BUF.M[62]:='B';BUF.M[63]:='З';BUF.M[64]:='Я';
      BUF.M[65]:='T';BUF.M[66]:='Ь';BUF.M[67]:=' ';BUF.M[68]:='M';
      BUF.M[69]:='A';BUF.M[70]:='T';BUF.M[71]:='E';BUF.M[72]:='P';
      BUF.M[73]:='.';BUF.M[74]:='K';BUF.M[75]:='O';BUF.M[76]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    53: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    54: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    55: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    56: begin
      BUF.LEN:=82;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='E';
      BUF.M[9]:='Щ';BUF.M[10]:='Ь';BUF.M[11]:='.';BUF.M[12]:='H';
      BUF.M[13]:='O';BUF.M[14]:='M';BUF.M[15]:='E';BUF.M[16]:='P';
      BUF.M[17]:=' ';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:=' ';
      BUF.M[21]:='M';BUF.M[22]:='A';BUF.M[23]:='T';BUF.M[24]:='E';
      BUF.M[25]:='P';BUF.M[26]:='.';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Ч';BUF.M[30]:=';';BUF.M[31]:=' ';BUF.M[32]:='H';
      BUF.M[33]:='A';BUF.M[34]:='Й';BUF.M[35]:='T';BUF.M[36]:='И';
      BUF.M[37]:=' ';BUF.M[38]:='П';BUF.M[39]:='O';BUF.M[40]:='C';
      BUF.M[41]:='Л';BUF.M[42]:='E';BUF.M[43]:='Д';BUF.M[44]:=' ';
      BUF.M[45]:='B';BUF.M[46]:=' ';BUF.M[47]:='S';BUF.M[48]:='Y';
      BUF.M[49]:='-';BUF.M[50]:='B';BUF.M[51]:='E';BUF.M[52]:='Щ';
      BUF.M[53]:=';';BUF.M[54]:='B';BUF.M[55]:='З';BUF.M[56]:='Я';
      BUF.M[57]:='T';BUF.M[58]:='Ь';BUF.M[59]:=' ';BUF.M[60]:='B';
      BUF.M[61]:='E';BUF.M[62]:='Щ';BUF.M[63]:='Ь';BUF.M[64]:='.';
      BUF.M[65]:='H';BUF.M[66]:='O';BUF.M[67]:='M';BUF.M[68]:='E';
      BUF.M[69]:='P';BUF.M[70]:=' ';BUF.M[71]:='H';BUF.M[72]:='A';
      BUF.M[73]:=' ';BUF.M[74]:='M';BUF.M[75]:='A';BUF.M[76]:='T';
      BUF.M[77]:='E';BUF.M[78]:='P';BUF.M[79]:='.';BUF.M[80]:='K';
      BUF.M[81]:='O';BUF.M[82]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    57: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    58: begin
      BUF.LEN:=18;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    59: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='M';BUF.M[23]:='A';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='E';BUF.M[27]:='Щ';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    60: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    61: begin
      BUF.LEN:=76;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='A';
      BUF.M[21]:='T';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=' ';
      BUF.M[29]:='M';BUF.M[30]:='A';BUF.M[31]:='T';BUF.M[32]:='E';
      BUF.M[33]:='P';BUF.M[34]:='.';BUF.M[35]:='H';BUF.M[36]:='A';
      BUF.M[37]:='Ч';BUF.M[38]:=';';BUF.M[39]:=' ';BUF.M[40]:='H';
      BUF.M[41]:='A';BUF.M[42]:='Й';BUF.M[43]:='T';BUF.M[44]:='И';
      BUF.M[45]:=' ';BUF.M[46]:='П';BUF.M[47]:='O';BUF.M[48]:='C';
      BUF.M[49]:='Л';BUF.M[50]:='E';BUF.M[51]:='Д';BUF.M[52]:=' ';
      BUF.M[53]:='B';BUF.M[54]:=' ';BUF.M[55]:='S';BUF.M[56]:='Y';
      BUF.M[57]:='-';BUF.M[58]:='M';BUF.M[59]:='A';BUF.M[60]:='T';
      BUF.M[61]:=';';BUF.M[62]:='B';BUF.M[63]:='З';BUF.M[64]:='Я';
      BUF.M[65]:='T';BUF.M[66]:='Ь';BUF.M[67]:=' ';BUF.M[68]:='M';
      BUF.M[69]:='A';BUF.M[70]:='T';BUF.M[71]:='E';BUF.M[72]:='P';
      BUF.M[73]:='.';BUF.M[74]:='K';BUF.M[75]:='O';BUF.M[76]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    62: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    63: begin
      BUF.LEN:=5;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    64: begin
      BUF.LEN:=14;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='B';BUF.M[12]:='E';
      BUF.M[13]:='Щ';BUF.M[14]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    65: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Д';BUF.M[14]:='B';BUF.M[15]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    66: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Б';BUF.M[14]:='E';BUF.M[15]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    67: begin
      BUF.LEN:=15;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Ц';BUF.M[14]:='E';BUF.M[15]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    68: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    69: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    70: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='E';BUF.M[12]:='Щ';
      BUF.M[13]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    71: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    72: begin
      BUF.LEN:=37;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='K';
      BUF.M[25]:='Л';BUF.M[26]:='Ю';BUF.M[27]:='Ч';BUF.M[28]:='И';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Д';BUF.M[36]:='B';
      BUF.M[37]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    73: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='З';BUF.M[12]:='Я';
      BUF.M[13]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    74: begin
      BUF.LEN:=14;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:='И';BUF.M[8]:='T';
      BUF.M[9]:='Ь';BUF.M[10]:=' ';BUF.M[11]:='B';BUF.M[12]:='З';
      BUF.M[13]:='Я';BUF.M[14]:='Л';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    75: begin
      BUF.LEN:=13;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='B';BUF.M[11]:='E';BUF.M[12]:='Щ';
      BUF.M[13]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    76: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    77: begin
      BUF.LEN:=37;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='E';
      BUF.M[21]:='Щ';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='K';
      BUF.M[25]:='Л';BUF.M[26]:='Ю';BUF.M[27]:='Ч';BUF.M[28]:='И';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Д';BUF.M[36]:='B';
      BUF.M[37]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    78: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    79: begin
      BUF.LEN:=43;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';BUF.M[12]:=';';
      BUF.M[13]:='И';BUF.M[14]:='C';BUF.M[15]:='K';BUF.M[16]:='Л';
      BUF.M[17]:='Ю';BUF.M[18]:='Ч';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='S';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='Б';BUF.M[26]:='E';BUF.M[27]:='З';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='K';BUF.M[31]:='Л';BUF.M[32]:='Ю';
      BUF.M[33]:='Ч';BUF.M[34]:='И';BUF.M[35]:=' ';BUF.M[36]:='B';
      BUF.M[37]:=' ';BUF.M[38]:='S';BUF.M[39]:='Y';BUF.M[40]:='-';
      BUF.M[41]:='Ц';BUF.M[42]:='E';BUF.M[43]:='H';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    80: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    81: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='O';
      BUF.M[17]:='T';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='Y';
      BUF.M[21]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    82: begin
      BUF.LEN:=27;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='П';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:='B';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    83: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='B';BUF.M[23]:='E';BUF.M[24]:='-';
      BUF.M[25]:='B';BUF.M[26]:='З';BUF.M[27]:='Я';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    84: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='C';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='B';BUF.M[20]:='З';
      BUF.M[21]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    85: begin
      BUF.LEN:=36;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='C';BUF.M[11]:='Y';BUF.M[12]:='M';
      BUF.M[13]:='M';BUF.M[14]:='A';BUF.M[15]:=';';BUF.M[16]:='H';
      BUF.M[17]:='A';BUF.M[18]:='Й';BUF.M[19]:='T';BUF.M[20]:='И';
      BUF.M[21]:=' ';BUF.M[22]:='C';BUF.M[23]:='Л';BUF.M[24]:='E';
      BUF.M[25]:='Д';BUF.M[26]:='Y';BUF.M[27]:='Ю';BUF.M[28]:=' ';
      BUF.M[29]:='B';BUF.M[30]:=' ';BUF.M[31]:='O';BUF.M[32]:='T';
      BUF.M[33]:='-';BUF.M[34]:='C';BUF.M[35]:='Y';BUF.M[36]:='M';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    86: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='O';BUF.M[20]:='T';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    87: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Д';BUF.M[20]:='B';
      BUF.M[21]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    88: begin
      BUF.LEN:=10;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='E';
      BUF.M[9]:='Щ';BUF.M[10]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    89: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='B';BUF.M[6]:='E';BUF.M[7]:='-';BUF.M[8]:='B';
      BUF.M[9]:='З';BUF.M[10]:='Я';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    90: begin
      BUF.LEN:=11;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:='E';BUF.M[10]:='Щ';BUF.M[11]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    91: begin
      BUF.LEN:=38;
      BUF.M[1]:='И';BUF.M[2]:='C';BUF.M[3]:='K';BUF.M[4]:='Л';
      BUF.M[5]:='Ю';BUF.M[6]:='Ч';BUF.M[7]:='И';BUF.M[8]:=' ';
      BUF.M[9]:='B';BUF.M[10]:=' ';BUF.M[11]:='S';BUF.M[12]:='Y';
      BUF.M[13]:='-';BUF.M[14]:='Д';BUF.M[15]:='B';BUF.M[16]:='И';
      BUF.M[17]:=';';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:='Й';
      BUF.M[21]:='T';BUF.M[22]:='И';BUF.M[23]:=' ';BUF.M[24]:='П';
      BUF.M[25]:='E';BUF.M[26]:='P';BUF.M[27]:='B';BUF.M[28]:='Y';
      BUF.M[29]:='Ю';BUF.M[30]:=' ';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='S';BUF.M[34]:='Y';BUF.M[35]:='-';BUF.M[36]:='Д';
      BUF.M[37]:='B';BUF.M[38]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    92: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='Б';BUF.M[20]:='E';
      BUF.M[21]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    93: begin
      BUF.LEN:=37;
      BUF.M[1]:='B';BUF.M[2]:='K';BUF.M[3]:='Л';BUF.M[4]:='Ю';
      BUF.M[5]:='Ч';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='B';
      BUF.M[9]:=' ';BUF.M[10]:='S';BUF.M[11]:='Y';BUF.M[12]:='-';
      BUF.M[13]:='Д';BUF.M[14]:='B';BUF.M[15]:='И';BUF.M[16]:=';';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:='Й';BUF.M[20]:='T';
      BUF.M[21]:='И';BUF.M[22]:=' ';BUF.M[23]:='C';BUF.M[24]:='Л';
      BUF.M[25]:='E';BUF.M[26]:='Д';BUF.M[27]:='Y';BUF.M[28]:='Ю';
      BUF.M[29]:=' ';BUF.M[30]:='B';BUF.M[31]:=' ';BUF.M[32]:='S';
      BUF.M[33]:='Y';BUF.M[34]:='-';BUF.M[35]:='Б';BUF.M[36]:='E';
      BUF.M[37]:='З';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(35)*)
(* EDITOR !INCLU:HEADING*)

(* SECTION ? .EX *)
(* EDITOR !INCLU:FCOPY*)
(* EDITOR !INCLU:PUT*)
(* EDITOR !INCLU:GET*)
(* EDITOR !INCLU:ДA*)
(* EDITOR !INCLU:MOЖHO*)
(* EDITOR !INCLU:YCTMOД*)
(* EDITOR !INCLU:RЦEЛBEЩ*)
(* EDITOR !INCLU:CUTCTP*)
(* EDITOR !INCLU:RCTP*)
(* EDITOR !INCLU:ECTЬ*)
(* EDITOR !INCLU:ПШИK*)
(* EDITOR !INCLU:MENU*)
(* EDITOR !INCLU:ROTД*)
(* EDITOR !INCLU:WCTP*)
(* EDITOR !INCLU:STPUT*)
(* EDITOR !INCLU:STEP*)
(* EDITOR !INCLU:FINLIN2*)
(* EDITOR !INCLU:FCBЯ*)



(* SECTION ? .RШ *)
PROCEDURE REGIS;
CONST
      MINKOЛ=0.000;  MAXKOЛ=99999.000;
      MINMEC=1;      MAXMEC=12;
      MINЦEHA=0.01;  MAXЦEHA=300000.00;



(* SECTION ? .ЦB *)
(*ИHB.HOM. INT --> REAL *)
FUNCTION ЦB(I:INT):REAL;
BEGIN ЦB:=I/1000 END;

(* SECTION ? .BЦ *)
(*ИHB.HOM. REAL --> INT *)
FUNCTION BЦ(R:REAL):INT;
BEGIN BЦ:=ROUND(R*1000) END;



(* SECTION ? .EB *)
(*OTДEЛ+BEЩЬ --> CYMMA (+BЗЯЛ, ECЛИ ECTЬ)*)
FUNCTION ECTЬBЗЯЛ:BOOL;
BEGIN
DMLCALL(36)
FCBЯ(DMLCALL(37),DMLCALL(38),DMLCALL(39));
FCBЯ(DMLCALL(40),DMLCALL(41),DMLCALL(42));
IF MOЖHO THEN(DMLCALL(43);ECTЬBЗЯЛ:=TRUE)
         ELSE ECTЬBЗЯЛ:=FALSE;
END;



(* SECTION ? .HAЙMAT *)
(*HAЙДИ MAT ПO BEЩ*)
PROCEDURE HAЙMAT;
BEGIN
DMLCALL(44)
REPEAT
  DMLCALL(45)
  IF (BEЩЬ.HOMEP>=MATEP.HAЧ) AND (BEЩЬ.HOMEP<=MATEP.KOH) THEN EXIT;
  DMLCALL(46)
  UNTIL FALSE;
END;



(* SECTION ? .WOЦ *)
FUNCTION OЦEHEHO:BOOL;
VAR HAШЛИ:BOOL;I:INT;
BEGIN
I:=0;HAШЛИ:=FALSE;OЦEHEHO:=TRUE;ШAГ:=1;
DMLCALL(47);
(Ц) WHILE MOЖHO DO(
  DMLCALL(48)
  IF NOT HAШЛИ THEN(
    OЦEHEHO:=FALSE;HAШЛИ:=TRUE;
    WRITE(OUT,'HE OЦEHEHЫ CЛEДYЮЩИE HOMEPA:');PUTT);
  WRITE(OUT,' ',ЦB(BEЩЬ.HOMEP):9:23);I:=I+1;
  IF (I MOD 13)=0 THEN IF STPUT THEN EXIT Ц);
IF (I MOD 13)!0 THEN PUTT;
END;



(* SECTION ? .WK *)
(*BЫBOД KAPTЫ*)
PROCEDURE WKAPT;
BEGIN
WITH BEЩЬ DO(
WRITE(OUT,ЦB(HOMEP):9:23,') ');
WCTP(OUT,BEЩЬ.HAЗB,0);PUTT;
WRITE(OUT,'       ЦEHA=');
IF ЦEHA>0.0001 THEN WRITE(OUT,ЦEHA:5:22)
               ELSE WRITE(OUT,'!!!!!');
WRITE(OUT,'  OCT=',OCTAT:0:23,
  '   ПPИ=',ПPИXOД:0:23,' PAC=',PACXOД:0:23,'  EД=',EД[1],EД[2],'  (');
WCTP(OUT,MATEP.HAЗB,10);WRITE(OUT,')');
PUTT);
END;



(* SECTION ? .WP *)
PROCEDURE WPACX;
VAR I:INT;
BEGIN
I:=0;
DMLCALL(49)
WHILE MOЖHO DO(
  I:=I+1;IF ((I-1) MOD 3)=0 THEN WRITE(OUT,'    ');
  DMLCALL(50)
  WRITE(OUT,'   ',OTДEЛ.HAЗB,'=',BЗЯЛ.KOЛИЧ:0:23);
  IF (I MOD 3)=0 THEN PUTT;
  DMLCALL(51));
IF (I MOD 3)!0 THEN PUTT;
END;



(* SECTION ? .KAP *)
FUNCTION KAPTA:BOOL;
BEGIN KAPTA:=FALSE;
DMLCALL(52)
WRITE(OUT,'HOMEHKЛATYPHЫЙ HOMEP KAPTЫ:');
BEЩЬ.HOMEP:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));
IF HAЧ THEN EXIT;
DMLCALL(53)
IF ПYCTO THEN(
  WRITE(OUT,'HET KAPTЫ C TAKИM HOMEPOM');PUTT;EXIT);
DMLCALL(54)
WRITE(OUT,'BOT ЭTA KAPTA:');PUTT;WKAPT;
KAPTA:=TRUE;
END;



(* SECTION ? .ПPO *)
PROCEDURE ПPO(PACX:BOOL);
VAR N:INT;
BEGIN
DMLCALL(55)
IF ПYCTO THEN(WRITE(OUT,'HET KAPT');PUTT;EXIT);
DMLCALL(56)
WRITE(OUT,'C KAKOГO HOMEPA HAЧATЬ ПPOCMOTP (',
         ЦB(MATEP.HAЧ):0:21,'-',ЦB(MATEP.KOH):0:21,'):');
N:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));
IF HAЧ THEN EXIT;
DMLCALL(57)
WHILE BEЩЬ.HOMEP<N DO(
  DMLCALL(58));
ШAГ:=1;
REPEAT
  DMLCALL(59)
  WKAPT;IF PACX THEN WPACX;
  DMLCALL(60)
UNTIL STEP OR ПYCTO;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
VAR EДИЗM:ALFA;
BEGIN
WITH BEЩЬ DO REPEAT
DMLCALL(61)
REPEAT
WRITE(OUT,'HOMEHKЛATYPHЫЙ HOMEP:');
HOMEP:=BЦ(RBEЩ(ЦB(MATEP.HAЧ),ЦB(MATEP.KOH)));IF HAЧ THEN EXIT;
DMLCALL(62)
IF MOЖHO THEN(WRITE(OUT,
  'KAPTA C TAKИM HOMEPOM YЖE ЗAPEГИCTPИPOBAHA, ПOBTOPИTE');PUTT);
UNTIL ПYCTO;
(**)
WRITE(OUT,'HAЗBAHИE:');RCTP;
IF HAЧ THEN EXIT;
READ(INP,BEЩЬ.HAЗB);
(**)
WRITE(OUT,'ЦEHA ИЗBECTHA!');
IF ДA THEN(IF HAЧ THEN EXIT;
  WRITE(OUT,'ЦEHA:');ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA))
ELSE(IF HAЧ THEN EXIT;ЦEHA:=0.0);
(**)
(ЦE) WHILE TRUE DO(
WRITE(OUT,'EДИHИЦA ИЗMEPEHИЯ (ШT,KГ,M,M2,M3,П,Л,T,ГP,K):');GETHAЧ;
IF HAЧ THEN EXIT;READ(INP,EД);WRITE(OUT,
'ШT    KГ    M     M2    M3    П     Л     T     ГP    K     ');
RESET(OUT);
WHILE NOT EOF(OUT) DO(
  READ(OUT,EДИЗM);IF EДИЗM=EД THEN(REWRITE(OUT);EXIT ЦE));
REWRITE(OUT);
WRITE(OUT,'TAKOЙ EДИHИЦЫ HET, ПOBTOPИTE');PUTT);
(**)
WRITE(OUT,'ПPИXOД:');
ПPИXOД:=RBEЩ(MINKOЛ,MAXKOЛ);OCTAT:=ПPИXOД;PACXOД:=0;
IF HAЧ THEN EXIT;
(**)
HAЙMAT;DMLCALL(63)
WRITE(OUT,'BOT, ЧTO BЫ BBEЛИ:');PUTT;WKAPT;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(64);ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
  DMLCALL(65)
  IF BEЩЬ.ЦEHA<0.01 THEN(DMLCALL(66))
                    ELSE(DMLCALL(67));
  YCTMOД;
  WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSEWRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ');
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
PROCEDURE YHAP(I:INT);EXTERNAL;
BEGIN
IF NOT KAPTA THEN EXIT;
WRITE(OUT,'ПOДTBEPДИTE EE ИCKЛЮЧEHИE:');
IF ДA AND NOT HAЧ THEN(
  YHAP(DMLCALL(68));ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
  DMLCALL(69);YCTMOД;
  WRITE(OUT,'KAPTA AHYЛИPOBAHA'))
ELSE WRITE(OUT,'KAPTA OCTABЛEHA');PUTT;
END;



(* SECTION ? .ПPИ *)
PROCEDURE ПPИ;
VAR N:REAL;
BEGIN WITH BEЩЬ DO(
IF NOT KAPTA THEN EXIT;
WRITE(OUT,'CKOЛЬKO ПPИШЛO:');
N:=RBEЩ(MINKOЛ,MAXKOЛ);ПPИXOД:=ПPИXOД+N;OCTAT:=OCTAT+N;
IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(OUT,'ПOДTBEPДИTE ПPИXOД ');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ПPИXOД OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(70);ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
DMLCALL(71)
IF ПYCTO THEN(DMLCALL(72));
YCTMOД;ECTЬ);
END;



(* SECTION ? .PAC *)
PROCEDURE PAC;
VAR N:REAL;ЗAMEHA:BOOL;
BEGIN WITH BEЩЬ DO(
IF NOT KAPTA THEN EXIT;WPACX;
REPEAT
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
WRITE(OUT,'CKOЛЬKO YШЛO:');
N:=RBEЩ(MINKOЛ,OCTAT);IF HAЧ THEN EXIT;
PACXOД:=PACXOД+N;OCTAT:=OCTAT-N;
(**)
ЗAMEHA:=ECTЬBЗЯЛ;
IF NOT ЗAMEHA THEN BЗЯЛ.KOЛИЧ:=0;
(**)
WRITE(OUT,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(OUT,'       ',OTДEЛ.HAЗB,
  ': ',BЗЯЛ.KOЛИЧ:0:23,'+',N:0:23,'=',BЗЯЛ.KOЛИЧ+N:0:23);PUTT;
WRITE(OUT,'ПOДTBEPДИTE PACXOД ');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'PACXOД OTMEHЯETCЯ');PUTT;EXIT);
BЗЯЛ.KOЛИЧ:=BЗЯЛ.KOЛИЧ+N;
IF ЗAMEHA THEN(DMLCALL(73))
ELSE(DMLCALL(74));
ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];
DMLCALL(75);
DMLCALL(76)
IF ПYCTO THEN(DMLCALL(77));
YCTMOД;ECTЬ;
UNTIL NOT EЩE('EЩE!  ');
)END;



(* SECTION ? .ЦEH *)
PROCEDURE ЦEH;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(78)
IF ПYCTO THEN(
  WRITE(OUT,'ЭTO ИЗДEЛИE YЖE OЦEHEHO');PUTT;EXIT);
(**)
WRITE(OUT,'COOБЩИTE ЦEHY:');
BEЩЬ.ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA);
IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WKAPT;
WRITE(OUT,'ПOДTBEPДИTE OЦEHKY');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'OЦEHKA OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(79)
YCTMOД;ФЛAГИ:=ФЛAГИ-[OTЧOTД,OTЧCKЛ];ECTЬ;
END;



(* SECTION ? .ЧИC *)
(*ИTOГOBAЯ ЧИCTKA*)
PROCEDURE ЧИC;
PROCEDURE YHAP(I:INT);EXTERNAL;
BEGIN
IF NOT (OTЧCKЛ IN ФЛAГИ) THEN(
  WRITE(OUT,'CHAЧAЛA HAДO BЫДATЬ OTЧET ПO CKЛAДY');PUTT;EXIT);
IF NOT (OTЧOTД IN ФЛAГИ) THEN(
  WRITE(OUT,'CHAЧAЛA HAДO BЫДATЬ OTЧET ПO OTДEЛAM');PUTT;EXIT);
IF NOT OЦEHEHO THEN(
  WRITE(OUT,'ПO ЭTИM HOMEPAM ЧИCTKA ПPOИЗBOДИTCЯ HE БYДET');
  PUTT);
WRITE(OUT,'ПOДTBEPДИTE ИTOГOBYЮ ЧИCTKY');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ЧИCTKA OTMEHЯETCЯ');PUTT;EXIT);
(**)
WRITE(OUT,'ЖДИTE, ИДET ЧИCTKA...');PUTT;
DMLCALL(80)
WHILE MOЖHO DO(
  DMLCALL(81)
  WHILE MOЖHO DO(
    DMLCALL(82)
    WHILE MOЖHO DO(
      DMLCALL(83)
      CYMMA.ЦEHA:=CYMMA.ЦEHA+BEЩЬ.ЦEHA*BЗЯЛ.KOЛИЧ;
      DMLCALL(84));
    DMLCALL(85));
  DMLCALL(86));
(**)
DMLCALL(87)
WHILE MOЖHO DO(
  DMLCALL(88)
  IF BEЩЬ.ЦEHA>0.001 THEN(
    BEЩЬ.ПPИXOД:=0;BEЩЬ.PACXOД:=0;
    YHAP(DMLCALL(89));DMLCALL(90));
  DMLCALL(91));
(**)
DMLCALL(92)
WHILE MOЖHO DO(
  DMLCALL(93));
(**)
ФЛAГИ:=ФЛAГИ-[OTЧCKЛ,OTЧOTД];
SYSTEM.ДATЧИC:=CEГOДHЯ;YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KAPT...');PUTT;
KYДA:='HAPYЖY';
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP XPAHЯЩИXCЯ KAPT/',
          'OTД - ПPOCMOTP KAPT C PACXOДOM ПO OTДEЛAM/',
          'HOB - BBOД HOBЫX KAPT/',
          'ЦEH - OЦEHKA HAИMEHOBAHИЙ/',
          'ИCK - ИCKЛЮЧEHИE KAPT/',
          'ПPИ - ПPИXOД HAИMEHOBAHИЙ/',
          'PAC - PACXOД HAИMEHOBAHИЙ/',
          'ЧИC - ИTOГOBAЯ ЧИCTKA/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO(FALSE);
  'OTД'=ДИP:ПPO(TRUE);
  'ЧИC'=ДИP:ЧИC;
  'ЦEH'=ДИP:ЦEH;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'ПPИ'=ДИP:ПPИ;
  'PAC'=ДИP:PAC;
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT));
END;



(* SECTION ? .B *)
BEGIN REGIS END.
(* SECTION ? .CKOT *)
