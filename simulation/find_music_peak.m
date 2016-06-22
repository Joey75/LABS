function [estimated_aoas, estimated_tofs]=find_music_peak(Pmusic,theta,tau)
    [m,n]=size(Pmusic);
    l=1;
    for i=2:m-1
        for j=2:n-1
            if(Pmusic(i,j)>Pmusic(i-1,j)&&Pmusic(i,j)>Pmusic(i+1,j)&&Pmusic(i,j)>Pmusic(i,j-1)&&Pmusic(i,j)>Pmusic(i,j+1)&&Pmusic(i,j)>Pmusic(i-1,j-1)&&Pmusic(i,j)>Pmusic(i-1,j+1)&&Pmusic(i,j)>Pmusic(i+1,j-1)&&Pmusic(i,j)>Pmusic(i+1,j+1))
                estimated_aoas(l)=theta(i);
                estimated_tofs(l)=tau(j);
                l=l+1;
            end
        end
    end
end