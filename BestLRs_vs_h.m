

N=2; % nb. of learning rates
nb_restarts=5;
nb_iterat=10;

nb_points_fig=100;
h_all_sim=zeros(1,nb_points_fig);
h_all_sim(1,1)=0.001;
h_max=1;

for k=2:nb_points_fig
    w=((log((h_max)/(h_all_sim(1,1))))/(log(10)))/(nb_points_fig-1);
    h_all_sim(1,k)=h_all_sim(1,k-1)*( 10^(w) );
end
h_all_sim=round(h_all_sim.*10^6)./(10^6);


R_all_sim=[0.1];
sigma0=100;



A=[];
b=[];
Aeq=[];
beq=[];
lb=0*ones(N,1);
ub=1*ones(N,1);

nonlcon=[];


options = optimset('Algorithm','interior-point','Display', 'off');



for q=1:length(R_all_sim)
    
    R=R_all_sim(1,q);
    sigma_p=R*sigma0;
    
    
    for nb_node=1:N
        BestAlpha{nb_node,1}=zeros(nb_iterat,length(h_all_sim));
        standard_err{nb_node,1}=zeros(nb_iterat,length(h_all_sim));
    end
    Err_matrix=zeros(nb_iterat,length(h_all_sim));
    StopCond=zeros(nb_iterat,length(h_all_sim));
                    
    for restarts=1:nb_restarts
        
        x_start= rand(N,1);
        
        for iterat=1:nb_iterat
            
            for axisxind=1:length(h_all_sim)
                h_p=h_all_sim(1,axisxind);
                
                if(N==1)
                    funfminconNnodes = @(x)MSErel_1node(x,h_p,sigma_p,iterat);
                elseif(N==2)
                    funfminconNnodes = @(x)MSErel_2nodes(x,h_p,sigma_p,iterat);
                else
                    funfminconNnodes = @(x)MSErel_Nnodes(x,h_p,sigma_p,iterat,N);
                end
                [xmin_f,f_min,exitflag,output,lambda,grad,hessian] = fmincon(funfminconNnodes,x_start,A,b,Aeq,beq,lb,ub,nonlcon,options);
               
                if((restarts==1)||(f_min<Err_matrix(iterat,axisxind)))
                    Err_matrix(iterat,axisxind)=f_min;
                    InfoOptim{iterat,axisxind}=output;
                    [xmin,Ind]=sort(xmin_f,1,'ascend');
                    stderr_col=sqrt(diag((hessian(Ind,Ind))^-1));
                    for nb_node=1:N
                        BestAlpha{nb_node,1}(iterat,axisxind)=xmin(nb_node,1);
                        standard_err{nb_node,1}(iterat,axisxind)=stderr_col(nb_node,1);
                    end   
                end
                
            end
            
        end
        
    end
    
    save(['outfiles_fmincon/BestAlpha_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)],'BestAlpha')
    save(['outfiles_fmincon/StdErr_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)],'standard_err')
    save(['outfiles_fmincon/Err_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)],'Err_matrix')
    save(['outfiles_fmincon/InfoOptim_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)],'InfoOptim')




end









