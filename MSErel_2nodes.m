function f=MSErel_2nodes(x,h_process,sigma_process,iterat) % x = 2 X 1 vector = [learning rate 1; learning rate 2]


sigma0_process=100;
mu0=150;

Ttot=5*10^3;


load(['all_samples/process_s',num2str(sigma_process*100),'_s0',num2str(sigma0_process*100),'_h',num2str(h_process*10^6),'_it',num2str(iterat)]) % process(:,1)=datapoints at all times; process(:,2)=real_mean at all times

N=2;
nup=(sigma_process/sigma0_process)^2;



mul=mu0*ones(N,1);
sigmal=zeros(N,1);
runlength=zeros(N,1);
logLH=zeros(N,1);
pl=(1/N)*ones(N,1); 
mu_pred=zeros(Ttot-1,1);

x=sort(x,'descend');
for indl=1:N
    runlength(indl,1)=(1/x(indl,1))-nup;
    sigmal(indl,1)=sigma_process*sqrt(1+1/(runlength(indl,1)+nup));
end
for tp=1:Ttot-1
    for indl=1:N
        mul(indl,1)=mul(indl,1)+x(indl,1)*(process(tp,1)-mul(indl,1));
        logLH(indl,1)= - log(sigmal(indl,1)*sqrt(2*pi)) - (((process(tp,1)-mul(indl,1))^2)/(2*sigmal(indl,1)^2));
    end
    
    if(runlength(2,1)<1+runlength(1,1))
        log_num1= logLH(1,1) + log(h_process) ;
        log_num2= logLH(2,1) + log(1-h_process) ;
    else
        log_num1= logLH(1,1) + log( h_process*pl(2,1) + (h_process+(1-h_process)*((runlength(2,1)-runlength(1,1)-1)/(runlength(2,1)-runlength(1,1))))*pl(1,1)) ;
        log_num2= logLH(2,1) + log( (1-h_process)*pl(2,1) + ((1-h_process)/(runlength(2,1)-runlength(1,1)))*pl(1,1) ) ;
    end
    
    logA=log_num1-log_num2;
    
    if((1/exp(logA))==0)
        pl(1,1)=1;
        pl(2,1)=0;
    else
        pl(1,1)= exp(logA)/(exp(logA)+1);
        pl(2,1)= 1/(exp(logA)+1);
    end
   
    mu_pred(tp,1)=pl'*mul;
    
end

f = (mean((mu_pred-process([2:Ttot],2)).^2))/(sigma0_process^2); 


  


end

