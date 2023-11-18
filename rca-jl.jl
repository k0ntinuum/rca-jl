function str(v)
    #out_alph = "abcdefghijklmnopqrstuvwxyz" * string('\u2586')    
    #out_alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" * string('\u25A0')
    out_alph = "O|23456789"
    join(map(i -> out_alph[i+1:i+1],v ))
end

rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"
red() = rgb(255,0,0)
yellow() = rgb(255,255,0)
white() = rgb(255,255,255)
gray(h) = rgb(h,h,h)

function key(b,n)
    rand(0:b-1,b^n)
end
    
function print_key(f)
    print("f = ")
    print(str(f),"\n")
end

function print_named_vec(s,v)
    print(s," = ", str(v),"\n")
end
function print_vec(v)
    print(str(v),"\n")
end

function val(v,f,b)
    j = 0
    for i in length(v):-1:1 j += v[i]*b^(i-1) end
    f[j+1]
end

function zone(p,i,n)
    map(i -> p[mod1(i, length(p))], i:i+n-1)
end
        

function encode!(p,f,b,n)
    s = deepcopy(f[1:n])
    c = zeros(Int64,length(p)) 
    for i in eachindex(p)
        c[i] = mod(val(zone(f,i,n),f,b)+p[i],b)
        #c[i] = mod(val(s[end-n+1:end],f,b)+p[i],b)
        push!(s,p[i])
        f[1] = mod(f[1] + c[i],b)
        f = circshift(f, c[i] + 1 )
    end
    c
end
function decode!(c,f,b,n)
    s = deepcopy(f[1:n])
    p = zeros(Int64,length(c))
    for i in eachindex(p)
        p[i] = mod(c[i] - val(zone(f,i,n),f,b),b) 
        #p[i] = mod(c[i] - val(s[end-n+1:end],f,b),b)
        push!(s,p[i])
        f[1] = mod(f[1] + c[i],b)
        f = circshift(f, c[i] + 1)
    end
    p
end

function encrypt(p,q,b,n)
    l = length(q)
    for i in 1:l
        f = deepcopy(q)
        f = circshift(f,i)
        p = encode!(p,f,b,n)
        p = reverse(p)
    end
    p
end

function decrypt(c,q,b,n)
    l = length(q)
    for i in 1:l
        f = deepcopy(q)
        f = circshift(f,l + 1 - i)
        c = reverse(c)
        c = decode!(c,f,b,n)
    end
    c
end
      
function demo(b,n)
    f = key(b,n)
    print_key(f)
    l = 25
    println()
    for i in 1:10
        p = rand(0:b-1,l)
        print(red())
        print_vec(p) 
        c = encrypt(p,f,b,n)
        print(yellow())
        print_vec(c)
        d = decrypt(c,f,b,n)
        println()
        if p != d print("\nERROR\n") end
    end
end



