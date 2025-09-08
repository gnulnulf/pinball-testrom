start=0x1000
size=0x800
with open('u1_1000_81.bin', 'wb') as f:
#    for i in hexList:
#        f.write(hex(i))
  value=(start % 251)+1
  for i in range(size):
      #print(i,value)
      f.write(bytes((value,)))
      value+=1
      if value>252:
          value=1


start=0x5000
size=0x800
with open('u2_5000.bin', 'wb') as f:
#    for i in hexList:
#        f.write(hex(i))
  value=(start % 251)+1
  for i in range(size):
      #print(i,value)
      f.write(bytes((value,)))
      value+=1
      if value>252:
          value=1


