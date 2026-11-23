(*=y+,s0,s7*)
(*=L1*) PROGRAM AMOCAR (*AM:KAPTЫ *)
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
    150: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='Д';BUF.M[4]:='C';
      BUF.M[5]:='X';BUF.M[6]:='E';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='X';BUF.M[10]:='-';BUF.M[11]:='A';BUF.M[12]:='M';
      BUF.M[13]:='0';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    151: begin
      BUF.LEN:=67;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='H';
      BUF.M[9]:='B';BUF.M[10]:=';';BUF.M[11]:=' ';BUF.M[12]:='H';
      BUF.M[13]:='A';BUF.M[14]:='Й';BUF.M[15]:='T';BUF.M[16]:='И';
      BUF.M[17]:=' ';BUF.M[18]:='B';BUF.M[19]:='Л';BUF.M[20]:='A';
      BUF.M[21]:='Д';BUF.M[22]:='E';BUF.M[23]:='Л';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='П';BUF.M[28]:='P';
      BUF.M[29]:='-';BUF.M[30]:='И';BUF.M[31]:='H';BUF.M[32]:='B';
      BUF.M[33]:=';';BUF.M[34]:='B';BUF.M[35]:='З';BUF.M[36]:='Я';
      BUF.M[37]:='T';BUF.M[38]:='Ь';BUF.M[39]:=';';BUF.M[40]:=' ';
      BUF.M[41]:='H';BUF.M[42]:='A';BUF.M[43]:='Й';BUF.M[44]:='T';
      BUF.M[45]:='И';BUF.M[46]:=' ';BUF.M[47]:='B';BUF.M[48]:='Л';
      BUF.M[49]:='A';BUF.M[50]:='Д';BUF.M[51]:='E';BUF.M[52]:='Л';
      BUF.M[53]:=' ';BUF.M[54]:='B';BUF.M[55]:=' ';BUF.M[56]:='Ш';
      BUF.M[57]:='И';BUF.M[58]:='-';BUF.M[59]:='П';BUF.M[60]:='P';
      BUF.M[61]:='И';BUF.M[62]:=';';BUF.M[63]:='B';BUF.M[64]:='З';
      BUF.M[65]:='Я';BUF.M[66]:='T';BUF.M[67]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    152: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='П';
      BUF.M[17]:='P';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='O';
      BUF.M[21]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    153: begin
      BUF.LEN:=113;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='B';BUF.M[8]:='Л';
      BUF.M[9]:='A';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='Л';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='M';
      BUF.M[17]:='E';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='O';
      BUF.M[21]:='Д';BUF.M[22]:=';';BUF.M[23]:=' ';BUF.M[24]:=' ';
      BUF.M[25]:=' ';BUF.M[26]:='B';BUF.M[27]:='З';BUF.M[28]:='Я';
      BUF.M[29]:='T';BUF.M[30]:='Ь';BUF.M[31]:=' ';BUF.M[32]:='M';
      BUF.M[33]:='E';BUF.M[34]:='T';BUF.M[35]:='A';BUF.M[36]:='Л';
      BUF.M[37]:='.';BUF.M[38]:='H';BUF.M[39]:='A';BUF.M[40]:='З';
      BUF.M[41]:='B';BUF.M[42]:=' ';BUF.M[43]:='H';BUF.M[44]:='A';
      BUF.M[45]:=' ';BUF.M[46]:='Д';BUF.M[47]:='P';BUF.M[48]:='!';
      BUF.M[49]:='.';BUF.M[50]:='H';BUF.M[51]:='A';BUF.M[52]:='З';
      BUF.M[53]:='B';BUF.M[54]:=';';BUF.M[55]:=' ';BUF.M[56]:=' ';
      BUF.M[57]:=' ';BUF.M[58]:='B';BUF.M[59]:='З';BUF.M[60]:='Я';
      BUF.M[61]:='T';BUF.M[62]:='Ь';BUF.M[63]:=' ';BUF.M[64]:='C';
      BUF.M[65]:='O';BUF.M[66]:='Д';BUF.M[67]:='E';BUF.M[68]:='P';
      BUF.M[69]:='Ж';BUF.M[70]:='.';BUF.M[71]:='K';BUF.M[72]:='O';
      BUF.M[73]:='Л';BUF.M[74]:='И';BUF.M[75]:='Ч';BUF.M[76]:=' ';
      BUF.M[77]:='H';BUF.M[78]:='A';BUF.M[79]:=' ';BUF.M[80]:='Д';
      BUF.M[81]:='P';BUF.M[82]:='!';BUF.M[83]:='.';BUF.M[84]:='K';
      BUF.M[85]:='O';BUF.M[86]:='Л';BUF.M[87]:='И';BUF.M[88]:='Ч';
      BUF.M[89]:=';';BUF.M[90]:=' ';BUF.M[91]:=' ';BUF.M[92]:=' ';
      BUF.M[93]:='H';BUF.M[94]:='A';BUF.M[95]:='Й';BUF.M[96]:='T';
      BUF.M[97]:='И';BUF.M[98]:=' ';BUF.M[99]:='C';BUF.M[100]:='Л';
      BUF.M[101]:='E';BUF.M[102]:='Д';BUF.M[103]:='Y';BUF.M[104]:='Ю';
      BUF.M[105]:=' ';BUF.M[106]:='B';BUF.M[107]:=' ';BUF.M[108]:='П';
      BUF.M[109]:='P';BUF.M[110]:='-';BUF.M[111]:='C';BUF.M[112]:='O';
      BUF.M[113]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    154: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='M';BUF.M[20]:='E';
      BUF.M[21]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    155: begin
      BUF.LEN:=18;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='C';BUF.M[14]:='Л';BUF.M[15]:='E';BUF.M[16]:='Д';
      BUF.M[17]:='Y';BUF.M[18]:='Ю';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    156: begin
      BUF.LEN:=30;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Д';BUF.M[15]:='P';BUF.M[16]:='!';
      BUF.M[17]:='.';BUF.M[18]:='H';BUF.M[19]:='A';BUF.M[20]:='З';
      BUF.M[21]:='B';BUF.M[22]:=' ';BUF.M[23]:='B';BUF.M[24]:=' ';
      BUF.M[25]:='S';BUF.M[26]:='Y';BUF.M[27]:='-';BUF.M[28]:='M';
      BUF.M[29]:='E';BUF.M[30]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    157: begin
      BUF.LEN:=13;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='O';BUF.M[10]:='Д';BUF.M[11]:='E';BUF.M[12]:='P';
      BUF.M[13]:='Ж';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    158: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    159: begin
      BUF.LEN:=33;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=';';BUF.M[7]:='H';BUF.M[8]:='A';
      BUF.M[9]:='Й';BUF.M[10]:='T';BUF.M[11]:='И';BUF.M[12]:=' ';
      BUF.M[13]:='B';BUF.M[14]:='Л';BUF.M[15]:='A';BUF.M[16]:='Д';
      BUF.M[17]:='E';BUF.M[18]:='Л';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='O';BUF.M[23]:='T';BUF.M[24]:='-';
      BUF.M[25]:='C';BUF.M[26]:='T';BUF.M[27]:='O';BUF.M[28]:=';';
      BUF.M[29]:='B';BUF.M[30]:='З';BUF.M[31]:='Я';BUF.M[32]:='T';
      BUF.M[33]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    160: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    161: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    162: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    163: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    164: begin
      BUF.LEN:=71;
      BUF.M[1]:='B';BUF.M[2]:='З';BUF.M[3]:='Я';BUF.M[4]:='T';
      BUF.M[5]:='Ь';BUF.M[6]:=' ';BUF.M[7]:='И';BUF.M[8]:='H';
      BUF.M[9]:='B';BUF.M[10]:='.';BUF.M[11]:='H';BUF.M[12]:='O';
      BUF.M[13]:='M';BUF.M[14]:='E';BUF.M[15]:='P';BUF.M[16]:=' ';
      BUF.M[17]:='H';BUF.M[18]:='A';BUF.M[19]:=' ';BUF.M[20]:='F';
      BUF.M[21]:='I';BUF.M[22]:='R';BUF.M[23]:='S';BUF.M[24]:='T';
      BUF.M[25]:=';';BUF.M[26]:=' ';BUF.M[27]:='H';BUF.M[28]:='A';
      BUF.M[29]:='Й';BUF.M[30]:='T';BUF.M[31]:='И';BUF.M[32]:=' ';
      BUF.M[33]:='П';BUF.M[34]:='O';BUF.M[35]:='C';BUF.M[36]:='Л';
      BUF.M[37]:='E';BUF.M[38]:='Д';BUF.M[39]:=' ';BUF.M[40]:='B';
      BUF.M[41]:=' ';BUF.M[42]:='S';BUF.M[43]:='Y';BUF.M[44]:='-';
      BUF.M[45]:='И';BUF.M[46]:='H';BUF.M[47]:='B';BUF.M[48]:=';';
      BUF.M[49]:='B';BUF.M[50]:='З';BUF.M[51]:='Я';BUF.M[52]:='T';
      BUF.M[53]:='Ь';BUF.M[54]:=' ';BUF.M[55]:='И';BUF.M[56]:='H';
      BUF.M[57]:='B';BUF.M[58]:='.';BUF.M[59]:='H';BUF.M[60]:='O';
      BUF.M[61]:='M';BUF.M[62]:='E';BUF.M[63]:='P';BUF.M[64]:=' ';
      BUF.M[65]:='H';BUF.M[66]:='A';BUF.M[67]:=' ';BUF.M[68]:='L';
      BUF.M[69]:='A';BUF.M[70]:='S';BUF.M[71]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    165: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    166: begin
      BUF.LEN:=28;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';BUF.M[19]:=' ';BUF.M[20]:='И';
      BUF.M[21]:='H';BUF.M[22]:='B';BUF.M[23]:='.';BUF.M[24]:='H';
      BUF.M[25]:='O';BUF.M[26]:='M';BUF.M[27]:='E';BUF.M[28]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    167: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    168: begin
      BUF.LEN:=18;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='P';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Ы';BUF.M[12]:='Д';
      BUF.M[13]:=';';BUF.M[14]:='B';BUF.M[15]:='З';BUF.M[16]:='Я';
      BUF.M[17]:='T';BUF.M[18]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    169: begin
      BUF.LEN:=21;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='C';BUF.M[8]:='Л';
      BUF.M[9]:='E';BUF.M[10]:='Д';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='S';
      BUF.M[17]:='Y';BUF.M[18]:='-';BUF.M[19]:='И';BUF.M[20]:='H';
      BUF.M[21]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    170: begin
      BUF.LEN:=32;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='Ш';BUF.M[15]:='И';BUF.M[16]:='Ф';
      BUF.M[17]:='P';BUF.M[18]:='.';BUF.M[19]:='H';BUF.M[20]:='O';
      BUF.M[21]:='M';BUF.M[22]:='E';BUF.M[23]:='P';BUF.M[24]:=' ';
      BUF.M[25]:='B';BUF.M[26]:=' ';BUF.M[27]:='S';BUF.M[28]:='Y';
      BUF.M[29]:='-';BUF.M[30]:='Ш';BUF.M[31]:='И';BUF.M[32]:='Ф';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    171: begin
      BUF.LEN:=11;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='Ш';
      BUF.M[9]:='И';BUF.M[10]:='Ф';BUF.M[11]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    172: begin
      BUF.LEN:=37;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';BUF.M[11]:='Б';BUF.M[12]:='O';
      BUF.M[13]:='P';BUF.M[14]:=';';BUF.M[15]:='П';BUF.M[16]:='O';
      BUF.M[17]:='C';BUF.M[18]:='T';BUF.M[19]:='A';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='И';BUF.M[23]:='H';BUF.M[24]:='B';
      BUF.M[25]:=';';BUF.M[26]:='П';BUF.M[27]:='O';BUF.M[28]:='C';
      BUF.M[29]:='T';BUF.M[30]:='A';BUF.M[31]:='B';BUF.M[32]:=' ';
      BUF.M[33]:='C';BUF.M[34]:='T';BUF.M[35]:='O';BUF.M[36]:='И';
      BUF.M[37]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    173: begin
      BUF.LEN:=23;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';BUF.M[11]:=';';BUF.M[12]:='П';
      BUF.M[13]:='O';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='A';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:='И';BUF.M[23]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    174: begin
      BUF.LEN:=27;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='E';
      BUF.M[9]:='P';BUF.M[10]:='B';BUF.M[11]:='Y';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    175: begin
      BUF.LEN:=23;
      BUF.M[1]:='П';BUF.M[2]:='O';BUF.M[3]:='C';BUF.M[4]:='T';
      BUF.M[5]:='A';BUF.M[6]:='B';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';BUF.M[11]:=';';BUF.M[12]:='П';
      BUF.M[13]:='O';BUF.M[14]:='C';BUF.M[15]:='T';BUF.M[16]:='A';
      BUF.M[17]:='B';BUF.M[18]:=' ';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:='И';BUF.M[23]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    176: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='И';BUF.M[6]:='H';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    177: begin
      BUF.LEN:=10;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    178: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='П';BUF.M[6]:='P';BUF.M[7]:='-';BUF.M[8]:='И';
      BUF.M[9]:='H';BUF.M[10]:='B';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    179: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='П';BUF.M[6]:='P';BUF.M[7]:='-';BUF.M[8]:='C';
      BUF.M[9]:='O';BUF.M[10]:='Д';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    180: begin
      BUF.LEN:=13;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';BUF.M[11]:='Б';BUF.M[12]:='O';
      BUF.M[13]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    181: begin
      BUF.LEN:=10;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Б';BUF.M[4]:=' ';
      BUF.M[5]:='Ш';BUF.M[6]:='И';BUF.M[7]:='-';BUF.M[8]:='П';
      BUF.M[9]:='P';BUF.M[10]:='И';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    182: begin
      BUF.LEN:=11;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='Ш';
      BUF.M[9]:='И';BUF.M[10]:='Ф';BUF.M[11]:='P';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    183: begin
      BUF.LEN:=55;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='T';
      BUF.M[49]:='O';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    184: begin
      BUF.LEN:=14;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:='T';BUF.M[8]:='Ь';
      BUF.M[9]:=' ';BUF.M[10]:='C';BUF.M[11]:='T';BUF.M[12]:='O';
      BUF.M[13]:='И';BUF.M[14]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    185: begin
      BUF.LEN:=55;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='C';BUF.M[10]:='Л';BUF.M[11]:='E';BUF.M[12]:='Д';
      BUF.M[13]:=' ';BUF.M[14]:='B';BUF.M[15]:=' ';BUF.M[16]:='И';
      BUF.M[17]:='H';BUF.M[18]:='-';BUF.M[19]:='C';BUF.M[20]:='T';
      BUF.M[21]:='O';BUF.M[22]:=';';BUF.M[23]:='B';BUF.M[24]:='З';
      BUF.M[25]:='Я';BUF.M[26]:='T';BUF.M[27]:='Ь';BUF.M[28]:=';';
      BUF.M[29]:='H';BUF.M[30]:='A';BUF.M[31]:='Й';BUF.M[32]:='T';
      BUF.M[33]:='И';BUF.M[34]:=' ';BUF.M[35]:='B';BUF.M[36]:='Л';
      BUF.M[37]:='A';BUF.M[38]:='Д';BUF.M[39]:='E';BUF.M[40]:='Л';
      BUF.M[41]:=' ';BUF.M[42]:='B';BUF.M[43]:=' ';BUF.M[44]:='O';
      BUF.M[45]:='T';BUF.M[46]:='-';BUF.M[47]:='C';BUF.M[48]:='T';
      BUF.M[49]:='O';BUF.M[50]:=';';BUF.M[51]:='B';BUF.M[52]:='З';
      BUF.M[53]:='Я';BUF.M[54]:='T';BUF.M[55]:='Ь';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    186: begin
      BUF.LEN:=12;
      BUF.M[1]:='Y';BUF.M[2]:='Б';BUF.M[3]:='P';BUF.M[4]:='A';
      BUF.M[5]:='T';BUF.M[6]:='Ь';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';BUF.M[11]:='И';BUF.M[12]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    187: begin
      BUF.LEN:=12;
      BUF.M[1]:='З';BUF.M[2]:='A';BUF.M[3]:='M';BUF.M[4]:='E';
      BUF.M[5]:='H';BUF.M[6]:='И';BUF.M[7]:=' ';BUF.M[8]:='C';
      BUF.M[9]:='T';BUF.M[10]:='O';BUF.M[11]:='И';BUF.M[12]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
    188: begin
      BUF.LEN:=40;
      BUF.M[1]:='H';BUF.M[2]:='A';BUF.M[3]:='Й';BUF.M[4]:='T';
      BUF.M[5]:='И';BUF.M[6]:=' ';BUF.M[7]:='П';BUF.M[8]:='O';
      BUF.M[9]:='-';BUF.M[10]:='K';BUF.M[11]:='Л';BUF.M[12]:='Ю';
      BUF.M[13]:=' ';BUF.M[14]:='H';BUF.M[15]:='O';BUF.M[16]:='B';
      BUF.M[17]:='O';BUF.M[18]:='T';BUF.M[19]:=' ';BUF.M[20]:='B';
      BUF.M[21]:=' ';BUF.M[22]:='S';BUF.M[23]:='Y';BUF.M[24]:='-';
      BUF.M[25]:='O';BUF.M[26]:='T';BUF.M[27]:='Д';BUF.M[28]:=';';
      BUF.M[29]:='П';BUF.M[30]:='O';BUF.M[31]:='C';BUF.M[32]:='T';
      BUF.M[33]:='A';BUF.M[34]:='B';BUF.M[35]:=' ';BUF.M[36]:='C';
      BUF.M[37]:='T';BUF.M[38]:='O';BUF.M[39]:='И';BUF.M[40]:='T';
      BUF.M[BUF.LEN+1]:=chr(255)
    end;
  end;
  BUF.D:=1; BUF.I:=0; BUF.H:=0; C:=' ';
  DML(TRUE)
end;
(*=L0 DMLCALL(150)*)
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
(* EDITOR !INCLU:STEP*)



(* SECTION ? .BB *)
(*BЗЯTЬ ПPИБOP И BЛAДEЛ B SY-OTД И SY-ШИФ*)
PROCEDURE BЗЯTЬBCE;
BEGIN
DMLCALL(151)
END;



(* SECTION ? .RШ *)
PROCEDURE REGIS;
CONST
      MINИHBN=100  ; MAXИHBN=99999;
      MINШИФP=10000; MAXШИФP=110001;
      MINMEC=1;      MAXMEC=12;
      MINПPOЦ=0.01;  MAXПPOЦ=50.0;
      MINЦEHA=0.0;  MAXЦEHA=5000000.0;
VAR ДP:FILE OF RECORD HAЗB:CTPOKA;KOЛИЧ:REAL END;



(* SECTION ? .BЗЯMET *)
(*BЗЯTЬ METAЛЛЫ*)
PROCEDURE BЗЯMET;
BEGIN
DMLCALL(152);REWRITE(ДP);
WHILE MOЖHO DO(
  DMLCALL(153);PUT(ДP));
END;



(* SECTION ? .ДAЙMET *)
(*ДAЙ METAЛЛЫ*)
PROCEDURE ДAЙMET;
BEGIN
DMLCALL(154);REWRITE(ДP);
WHILE MOЖHO DO(
  DMLCALL(155)
  WCTP(OUT,METAЛ.HAЗB,8);WRITE(OUT,':');
  ДP!.HAЗB:=METAЛ.HAЗB;
  ДP!.KOЛИЧ:=RBEЩ(0.0,9999.0);IF HAЧ THEN EXIT;
  IF ДP!.KOЛИЧ>0.00000001 THEN PUT(ДP));
END;



(* SECTION ? .ПOCMET *)
(*ПOCTAB METAЛЫ*)
PROCEDURE ПOCMET;
BEGIN
RESET(ДP);
WHILE NOT EOF(ДP) DO(
  DMLCALL(156)
  COДEPЖ.KOЛИЧ:=ДP!.KOЛИЧ;
  DMLCALL(157);GET(ДP));
END;



(* SECTION ? .WMET *)
(*ПEЧATЬ METAЛOB*)
PROCEDURE WMET;
VAR I:INT;
BEGIN
RESET(ДP);I:=0;
IF EOF(ДP) THEN EXIT;
WHILE NOT EOF(ДP) DO(
  IF (I MOD 4)=0 THEN WRITE(OUT,'       ');
  I:=I+1;WCTP(OUT,ДP!.HAЗB,6);
  WRITE(OUT,'=',ДP!.KOЛИЧ:0:25);
  IF (I MOD 4)=0 THEN PUTT ELSE WRITE(OUT,'  ');
  GET(ДP));
IF (I MOD 4)!0 THEN PUTT;
END;



(* SECTION ? .WCTO *)
PROCEDURE WCTO;
BEGIN
  WRITE(OUT,'       OTДEЛ=',OTДEЛ.HAЗB);
  IF CTOИT.ПPИHЯЛ!0 THEN WRITE(OUT,' ПPИ=',CTOИT.ПPИHЯЛ:2);
  IF CTOИT.CПИCAЛ!0 THEN WRITE(OUT,' CПИ=',CTOИT.CПИCAЛ:2);
  PUTT;
END;



(* SECTION ? .WC *)
(*BЫBOД "CTOИT ПO OTДEЛAM"*)
PROCEDURE WCTOИT;
BEGIN
DMLCALL(158)
WHILE MOЖHO DO(
  DMLCALL(159)
  WCTO;
  DMLCALL(160));
END;



(* SECTION ? .WK *)
(*BЫBOД ПPИБOPA*)
PROCEDURE WKAPT;
BEGIN
WITH ПPИБOP DO(
WRITE(OUT,ИHB.HOMEP:5,') Ш=',ШИФP.HOMEP:6,
          ' Ц=',ЦEHA:6:22,' !B=',BOC:5:22,' !K=',KAП:5:22,' ');
WCTP(OUT,HAЗB,0);PUTT;WMET;
)END;



(* SECTION ? .KAPTA *)
FUNCTION KAPTA:BOOL;
BEGIN
KAPTA:=FALSE;
WRITE(OUT,'ИHBEHTAPHЫЙ HOMEP KAPTЫ:');
ИHB.HOMEP:=RЦEЛ(MINИHBN,MAXИHBN);
IF HAЧ THEN EXIT;
DMLCALL(161)
IF ПYCTO THEN(
  WRITE(OUT,'HET KAPTЫ C TAKИM ИHB.N');PUTT;EXIT);
BЗЯTЬBCE;BЗЯMET;
WRITE(OUT,'BOT ЭTA KAPTA:');PUTT;WKAPT;WCTOИT;
KAPTA:=TRUE;
END;



(* SECTION ? .ИHB *)
FUNCTION ИHBHOM:BOOL;
BEGIN
ИHBHOM:=FALSE;
REPEAT
WRITE(OUT,'HOBЫЙ ИHBEHTAPHЫЙ HOMEP:');
ИHB.HOMEP:=RЦEЛ(MINИHBN,MAXИHBN);IF HAЧ THEN EXIT;
DMLCALL(162)
IF MOЖHO THEN(WRITE(OUT,
  'KAPTA C TAKИM ИHB.N YЖE ЗAPEГИCTPИPOBAHA, ПOBTOPИTE');PUTT);
UNTIL ПYCTO;
ИHBHOM:=TRUE;
END;




(* SECTION ? .ПPO *)
PROCEDURE ПPO;
VAR N,FIRST,LAST:INT;
BEGIN
DMLCALL(163)
IF ПYCTO THEN(WRITE(OUT,'HET KAPT');PUTT;EXIT);
DMLCALL(164)
WRITE(OUT,'C KAKOГO HOMEPA HAЧATЬ ПPOCMOTP (',FIRST:0,'-',LAST:0,'):');
N:=RЦEЛ(FIRST,LAST);IF HAЧ THEN EXIT;
(**)
IF N < (LAST-FIRST) DIV 2 THEN(
  DMLCALL(165)
  WHILE ИHB.HOMEP<N DO(
    DMLCALL(166)))
ELSE(
  DMLCALL(167)
  WHILE ИHB.HOMEP>N DO(
    DMLCALL(168)));
ШAГ:=1;
REPEAT
  BЗЯTЬBCE;BЗЯMET;
  WKAPT;WCTOИT;DMLCALL(169)
UNTIL STEP OR ПYCTO;
END;



(* SECTION ? .HOB *)
PROCEDURE HOB;
BEGIN
WITH ПPИБOP DO REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(OUT,'ШИФP OБOPYДOBAHИЯ:');
ШИФP.HOMEP:=RЦEЛ(MINШИФP,MAXШИФP);IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'HAИMEHOBAHИE:');RCTP;IF HAЧ THEN EXIT;
READ(INP,HAЗB);
(**)
WRITE(OUT,'ЦEHA:');
ЦEHA:=RBEЩ(MINЦEHA,MAXЦEHA);IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'ECTЬ ЛИ ДPAГ.METAЛЛЫ!');
IF ДA AND NOT HAЧ THEN ДAЙMET ELSE REWRITE(ДP);
IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'! HA BOCCTAHOBЛEHИE:');
BOC:=RBEЩ(MINПPOЦ,MAXПPOЦ);IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'! HA KAП.PEMOHT:');
KAП:=RBEЩ(0.0,MAXПPOЦ);IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'MECЯЦ ПPИOБPETEHИЯ:');
CTOИT.ПPИHЯЛ:=RЦEЛ(MINMEC,MAXMEC);IF HAЧ THEN EXIT;
(**)
CTOИT.CПИCAЛ:=0;
(**)
WRITE(OUT,'BOT, ЧTO BЫ BBEЛИ:');PUTT;WKAPT;WCTO;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(170)
  IF ПYCTO THEN(DMLCALL(171));
  DMLCALL(172);ПOCMET;
  YCTMOД;
  WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .KOП *)
PROCEDURE KOП;
BEGIN
IF NOT KAPTA THEN EXIT;
REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(OUT,'HAЗBAHИE OTДEЛA:');OTДEЛ.HAЗB:=ROTД;IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'MECЯЦ ПPИOБPETEHИЯ:');
CTOИT.ПPИHЯЛ:=RЦEЛ(MINMEC,MAXMEC);
IF HAЧ THEN EXIT;
(**)
CTOИT.CПИCAЛ:=0;
(**)
WRITE(OUT,'BOT, ЧTO ПOЛYЧИЛOCЬ:');PUTT;WKAPT;WCTO;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(173)YCTMOД;
  WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .ПOB *)
PROCEDURE ПOB;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(174)
IF CTOИT.CПИCAЛ!0 THEN(WRITE(OUT,
  'ПOBTOPЯTЬ MOЖHO TOЛЬKO HИ PAЗY HE CПИCAHHЫE HAИMEHOBAHИЯ');
  PUTT;EXIT);
REPEAT
(**)
IF NOT ИHBHOM THEN EXIT;
(**)
WRITE(OUT,'BOT, ЧTO ПOЛYЧИЛOCЬ:');PUTT;WKAPT;WCTO;
WRITE(OUT,'ПOДTBEPДИTE ПPABИЛЬHOCTЬ KAPTЫ');
IF ДA AND NOT HAЧ THEN(
  DMLCALL(175)YCTMOД;
  WRITE(OUT,'KAPTA ЗAPEГИCTPИPOBAHA'))
ELSE WRITE(OUT,'KAPTA AHYЛИPOBAHA');PUTT;
UNTIL NOT EЩE('EЩE!  ') OR HAЧ;
END;



(* SECTION ? .ИCK *)
PROCEDURE ИCK;
VAR OTД:ALFA;DEL:BOOL;
PROCEDURE YHAP(I:INT);EXTERNAL;
FUNCTION COUNT(I:INT):INT;EXTERNAL;
BEGIN
IF NOT KAPTA THEN EXIT;
WRITE(OUT,'ПOДTBEPДИTE EE ИCKЛЮЧEHИE:');
IF ДA AND NOT HAЧ THEN(
  YHAP(DMLCALL(176));DMLCALL(177)
  IF COUNT(DMLCALL(178))=0 THEN(
    YHAP(DMLCALL(179));DMLCALL(180));
  IF COUNT(DMLCALL(181))=0 THEN(DMLCALL(182));
  YCTMOД;WRITE(OUT,'KAPTA AHYЛИPOBAHA'))
ELSE WRITE(OUT,'KAPTA OCTABЛEHA');PUTT;
END;



(* SECTION ? .CПИ *)
PROCEDURE CПИ;
VAR N:INT;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(183)
IF CTOИT.CПИCAЛ!0 THEN(
  WRITE(OUT,'ЭTO HAИMEHOBAHИE YЖE CПИCAHO');PUTT;EXIT);
(**)
WRITE(OUT,'MECЯЦ CПИCAHИЯ:');
N:=CTOИT.ПPИHЯЛ;IF N=0 THEN N:=MINMEC;
CTOИT.CПИCAЛ:=RЦEЛ(N,MAXMEC);
IF HAЧ THEN EXIT;
(**)
WRITE(OUT,'BOT, ЧTO Y BAC ПOЛYЧИЛOCЬ:');PUTT;WCTO;
WRITE(OUT,'ПOДTBEPДИTE CПИCAHИE');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'CПИCAHИE OTMEHЯETCЯ');PUTT;EXIT);
DMLCALL(184);YCTMOД;ECTЬ;
END;



(* SECTION ? .ПEP *)
PROCEDURE ПEP;
VAR N,KYП,ПPOД,MECПEP:INT;HOBOT:ALFA;HECTOЯЛ:BOOL;
BEGIN
IF NOT KAPTA THEN EXIT;
DMLCALL(185)
IF CTOИT.CПИCAЛ!0 THEN(
  WRITE(OUT,'ЭTO HAИMEHOBAHИE YЖE CПИCAHO');PUTT;EXIT);
(**)
WRITE(OUT,'HAЗBAHИE OTДEЛA:');HOBOT:=ROTД;IF HAЧ THEN EXIT;
IF HOBOT=OTДEЛ.HAЗB THEN(
  WRITE(OUT,'ЭTO HAИMEHOBAHИE YЖE ЧИCЛИTCЯ B ЭTOM OTДEЛE');
  PUTT;EXIT);
WRITE(OUT,'MECЯЦ ПEPEДAЧИ:');
N:=CTOИT.ПPИHЯЛ;IF N=0 THEN N:=MINMEC;
MECПEP:=RЦEЛ(N+1,MAXMEC);
IF HAЧ THEN EXIT;
(**)
IF MECПEP=1 THEN CTOИT.CПИCAЛ:=12
            ELSE CTOИT.CПИCAЛ:=MECПEP-1;
HECTOЯЛ:=CTOИT.ПPИHЯЛ>CTOИT.CПИCAЛ;
WRITE(OUT,'CПИCAH:');WCTO;
KYП:=CTOИT.ПPИHЯЛ;ПPOД:=CTOИT.CПИCAЛ;
CTOИT.ПPИHЯЛ:=MECПEP;CTOИT.CПИCAЛ:=0;OTДEЛ.HAЗB:=HOBOT;
WRITE(OUT,'ПPИHЯT:');WCTO;
IF HECTOЯЛ THEN(WRITE(OUT,
  'ПEPEДAЮЩИЙ OTДEЛ БYДET ИCKЛЮЧEH ИЗ CПИCKOB ЭTOГO HAИMEHOBAHИЯ');
  PUTT);
WRITE(OUT,'ПOДTBEPДИTE ПEPEBOД');
IF NOT ДA OR HAЧ THEN(
  WRITE(OUT,'ПEPEBOД OTMEHЯETCЯ');PUTT;EXIT);
CTOИT.ПPИHЯЛ:=KYП;CTOИT.CПИCAЛ:=ПPOД;
IF HECTOЯЛ THEN(DMLCALL(186))
           ELSE(DMLCALL(187));
CTOИT.ПPИHЯЛ:=MECПEP;CTOИT.CПИCAЛ:=0;
DMLCALL(188);YCTMOД;ECTЬ;
END;



(* SECTION ? .R *)
BEGIN
WRITE(OUT,'      ...BЫ B БЛOKE PEГИCTPAЦИИ KAPT...');PUTT;
KYДA:='HAPYЖY';
WHILE TRUE DO(
WRITE(OUT,'ПPO - ПPOCMOTP XPAHЯЩИXCЯ KAPT/',
          'HOB - BBOД HOBЫX KAPT/',
          'ПOB - ПOBTOPEHИE KAPTЫ B OTДEЛE/',
          'KOП - KOПИPOBAHИE KAPTЫ ИЗ OTДEЛA B OTДEЛ/',
          'ИCK - ИCKЛЮЧEHИE KAPT/',
          'ПEP - ПEPEДAЧA HAИM.B ДPYГOЙ OTДEЛ/',
          'CПИ - CПИCAHИE HAИMEHOBAHИЙ/');
MENU;
SELECT
  'ПPO'=ДИP:ПPO;
  'ПOB'=ДИP:ПOB;
  'KOП'=ДИP:KOП;
  'ПEP'=ДИP:ПEP;
  'HOB'=ДИP:HOB;
  'ИCK'=ДИP:ИCK;
  'CПИ'=ДИP:CПИ;
  'KOH'=ДИP:EXIT;
  'BЫX'=ДИP:EXIT));
END;



(* SECTION ? .B *)
BEGIN REGIS END.
(* SECTION ? .AMOT *)
