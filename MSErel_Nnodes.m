function f=MSErel_Nnodes(x,h_process,sigma_process,iterat,N) % x = N x 1 vector of learning rates


sigma0_process=100;
mu0=150;

Ttot=5*10^3;


load(['all_samples/process_s',num2str(sigma_process*100),'_s0',num2str(sigma0_process*100),'_h',num2str(h_process*10^6),'_it',num2str(iterat)]) % process(:,1)=datapoints at all times; process(:,2)=real_mean at all times

nup=(sigma_process/sigma0_process)^2;


mul=mu0*ones(N,1);
sigmal=zeros(N,1);
runlength=zeros(N,1);
logLH=zeros(N,1);
pl=(1/N)*ones(N,1);
mu_pred=zeros(Ttot-1,1);

log_num=zeros(N,1);
logA=zeros(N,1);


x=sort(x,'descend');
for indl=1:N
    runlength(indl,1)=(1/x(indl,1))-nup;
    sigmal(indl,1)=sigma_process*sqrt(1+1/(runlength(indl,1)+nup));
end
for tp=1:Ttot-1
   
    
    for indl=1:N
        mul(indl,1)=mul(indl,1)+x(indl,1)*(process(tp,1)-mul(indl,1));
        logLH(indl,1)= - log(sigmal(indl,1)*sqrt(2*pi)) - (((process(tp,1)-mul(indl,1))^2)/(2*sigmal(indl,1)^2));
    
        if(indl==1)
            pc=ones(N,1);
        else
            pc=zeros(N,1);
        end
        
        pnc=zeros(N,1);
        if(indl==1)
            pnc(1,1)=(runlength(2,1)-runlength(1,1)-1)/(runlength(2,1)-runlength(1,1));
        elseif(runlength(indl,1)>runlength(indl-1,1)+1)
            pnc(indl-1,1)=1/(runlength(indl,1)-runlength(indl-1,1));
        else
            pnc(indl-1,1)=1;
        end
        if(indl==N)
            pnc(indl,1)=1;
        elseif(runlength(indl+1,1)>runlength(indl,1)+1)
            pnc(indl,1)=(runlength(indl+1,1)-runlength(indl,1)-1)/(runlength(indl+1,1)-runlength(indl,1));
        else
            pnc(indl,1)=0;
        end
        
        log_num(indl,1)=logLH(indl,1)+log(sum((h_process*pc+(1-h_process)*pnc).*pl));
    end
    
    for indl=1:N
        logA(indl,1)=log_num(indl,1)-log_num(N,1); 
    end
    [logA_max,Ind_max]=max(logA);
    
    if((1/exp(logA_max))==0)
        pl=zeros(N,1);
        pl(Ind_max,1)=1;
    else
        for indl=1:N
            pl(indl,1)= (exp(logA(indl,1)))/(sum(exp(logA)));
        end
    end
    
    mu_pred(tp,1)=pl'*mul;
    
    
end

   

f=mean((mu_pred-process([2:Ttot],2)).^2)/(sigma0_process^2);



end

