%'m seeing this is your function (maybe call is 
%like map builder or something) will take in an
%input which will just be the belief.
%And it'll output the map with the locations of the input
%input is belief

map = dlmread("OccupancyMapNew.dat");
     
  
        function occupancymap=assignment2(particles)
%             if(>0)
                occupancymap.particles=particles;
                occupancymap.x=rand()*particles;
                occupancymap.y=rand()*particles;
              
%             end
        end
        function obj=Set(obj,newX,newY,newOrientation)
            if(newX<0 || newX>obj.worldSize)
                display('X Coordinate out of bound');
            end
            if(newY<0 || newY>obj.worldSize)
                display('Y Coordinate out of bound');
            end
            if(newOrientation<0 || newOrientation >2*pi)
                display('Orientation must be in [0-2*Pi]');
            end
            obj.x=newX;
            obj.y=newY;
            obj.orientation=newOrientation;
        end
        
        