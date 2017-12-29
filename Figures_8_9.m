
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
N_tot=3;
nb_iterat=10;



for k=1:length(R_all_sim)
        
        R=R_all_sim(1,k);
        sigma_p=R*sigma0;
        
        
        figure
        
        for N=1:N_tot
            
            load(['outfiles_fmincon/BestAlpha_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            load(['outfiles_fmincon/Err_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            load(['outfiles_fmincon/StdErr_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            
            
            subplot(1,3,N)
            hold on
            
            mean_alpha=zeros(N,length(h_all_sim));
            std_alpha=zeros(N,length(h_all_sim));
            stderr=zeros(N,length(h_all_sim));
            
            for nb_node=1:N
                if(nb_node==1)
                    col='k';
                elseif(nb_node==2)
                    col=[102,102,102]./255;
                elseif(nb_node==3)
                    col=[204,204,204]./255;
                end
                
                mat_it_h=BestAlpha{N-nb_node+1,1};
                stderr_it_h=standard_err{N-nb_node+1,1};
                mean_alpha(nb_node,:)=mean(mat_it_h,1);
                std_alpha(nb_node,:)=std(mat_it_h,1);
                stderr(nb_node,:)=mean(stderr_it_h,1);

                semilogx(h_all_sim,mean_alpha(nb_node,:),'o','MarkerEdgeColor',col,'MarkerFaceColor',col,'MarkerSize',5)
            
            end
            hold off
            xlabel('hazard rate, h')
            ylabel('learning rate, \alpha')
            title(['Gaussian, N = ',num2str(N)])
            
        end
        
        figure
        
        for N=1:N_tot
            
            load(['outfiles_fmincon/BestAlpha_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            load(['outfiles_fmincon/Err_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            load(['outfiles_fmincon/StdErr_s',num2str(sigma_p*100),'_s0',num2str(sigma0*100),'_N',num2str(N),'_it',num2str(nb_iterat)])
            
            subplot(1,3,N)
            ylim([0,1.1])
            hold on
            semilogx(h_all_sim,mean(Err_matrix,1),'o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
            hold off
            xlabel('hazard rate')
            ylabel('relative error E^2/E_0^2')
            title(['Gaussian, N = ',num2str(N)])
            
        end
        
      
end
        
        








    

