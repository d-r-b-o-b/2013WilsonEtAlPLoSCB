
it_i=1;
it_f=10;

sigma0=100;
mu0=150;

Ttot=5*10^3;


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



for q=1:length(R_all_sim)
    
    R=R_all_sim(1,q);
    sigma=R*sigma0;
    

for iterat=it_i:it_f

    for k=1:length(h_all_sim)
        
        h=h_all_sim(1,k);
                
        process=zeros(Ttot,2);
        
        process(1,2)=mu0+sigma0*randn;
        process(1,1)=process(1,2)+sigma*randn;
        
        for t=2:Ttot
            rand_nb=rand;
            if(rand_nb<h)
                process(t,2)=mu0+sigma0*randn;
            else
                process(t,2)=process(t-1,2);
            end
            process(t,1)=process(t,2)+sigma*randn;
        end
        
        save(['all_samples/process_s',num2str(sigma*100),'_s0',num2str(sigma0*100),'_h',num2str(h*10^6),'_it',num2str(iterat)],'process')
        
    end
    
end



end

