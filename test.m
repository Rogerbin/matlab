function code = coefficientencode(Stream)
[num2, num1] = size(Stream);
DictTable = zeros(4096,3);
InitEnd = 255;
for f=0:InitEnd 
    DictTable(f+1,1) = f;
    DictTable(f+1,2) = f;
    
end

DictCurAddr = InitEnd+1;
c=0;
code = zeros(255,1);
for s=1:num2
    for s2 = 1:num1
        if s==1 && s2 ==1
           PreCode = Stream(s,s2);
           TableInsert=1;
        else
            for DictAddr =256:DictCurAddr
                if DictTable(DictAddr,2:3) == [PreCode Stream(s,s2)]
                    PreCode =DictAddr;
                    TableInsert = 0;
                    if s==num2 & s2==num1
                        c=c+1;
                        code(c)=DictAddr;
                    end
                    break;
                end
                if TableInsert==1
                    DictCurAddr=DictCurAddr+1;
                    c=c+1;
                    code(c)=PreCode;
                    DictTable(DictAddr,1:3) = [DictCurAddr PreCode Stream(s,s2)];
                    PreCode = Stream(s,s2);
                    if s==num2 & s2==num1
                        c=c+1;
                        code(c)=PreCode;
                    end
                end
                TableInsert =1;
                
        end
    end
    end
code = uint16(code);
end
