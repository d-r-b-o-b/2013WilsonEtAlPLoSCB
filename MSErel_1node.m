function f=MSErel_1node(x,h_process,sigma_process,iterat) % x = learning rate


sigma0_process=100;
mu0=150;

Ttot=5*10^3;


load(['all_samples/process_s',num2str(sigma_process*100),'_s0',num2str(sigma0_process*100),'_h',num2str(h_process*10^6),'_it',num2str(iterat)]) % process(:,1)=datapoints at all times; process(:,2)=real_mean at all times


mu_pred0=mu0;

mu_pred=zeros(Ttot-1,1);
for tp=1:Ttot-1
    if(tp==1)
        mu_pred(tp,1)=mu_pred0+x*(process(tp,1)-mu_pred0);
    else
        mu_pred(tp,1)=mu_pred(tp-1,1)+x*(process(tp,1)-mu_pred(tp-1,1));
    end  
end

f = (mean((mu_pred-process([2:Ttot],2)).^2))/(sigma0_process^2);


  

end

