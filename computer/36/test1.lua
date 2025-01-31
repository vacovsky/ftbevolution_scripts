a = {[1]="a", [2]="b", [3]="c", [4]="d", [5]="e"}
b = {[1]="A", [2]="B", [3]="C", [4]="D", [5]="E"}

for k,v in pairs(a) do
    print(k,v)
    for x,y in pairs(b) do
        print(x,y)
        break
    end
end
