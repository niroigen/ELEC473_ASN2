%'m seeing this is your function (maybe call is 
%like map builder or something) will take in an
%input which will just be the belief.
%And it'll output the map with the locations of the input
%input is belief

map = dlmread("OccupancyMapNew.dat");
     
    properties
        x=0;
        y=0;
        orientation=0;
        mapsize=800;
    end
        function occupancymap=assignment2(particles)
%             if(>0)
                occupancymap.particles=particles;
                occupancymap.x=rand()*particles;
                occupancymap.y=rand()*particles;
              
%             end
        end
        function obj=Set(obj,newX,newY,newOrientation)
            if(newX<0 || newX>obj.mapsize)
                display('X Coordinate out of bound');
            end
            if(newY<0 || newY>obj.mapsize)
                display('Y Coordinate out of bound');
            end
            if(newOrientation<0 || newOrientation >2*pi)
                display('Orientation must be in [0-2*Pi]');
            end
            obj.x=newX;
            obj.y=newY;
            obj.orientation=newOrientation;
        end
        
        