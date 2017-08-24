function TrMat = makeTransitionMatrix_2017(l, h)


TrMat(1,1:length(l)) = h;
for i = 1:length(l)-1
    
    if (i == 1) | ( abs(l(i)-l(i-1))<1 )
        TrMat(1, i) = h + (1-h) * (l(i+1)-l(i)-1)/(l(i+1)-l(i));;
        TrMat(i+1, i) = (1-h) * 1/(l(i+1)-l(i));
    else
        TrMat(1, i) = h;
        TrMat(i, i) = (1-h) * (l(i+1)-l(i)-1)/(l(i+1)-l(i));
        TrMat(i+1, i) = (1-h) * 1/(l(i+1)-l(i));
    end
end
i = length(l);
TrMat(i,i) = (1-h);

end
