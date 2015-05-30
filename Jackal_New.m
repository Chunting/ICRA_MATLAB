 rosshutdown  
 setenv('ROS_IP','192.168.127.1')
 rosinit('ib-T440p')
 


spinVelocity = 0.4;       % Angular velocity (rad/s)
forwardVelocity = 0.3;    % Linear velocity (m/s)
backwardVelocity = -0.3; % Linear velocity (reverse) (m/s)
distanceThreshold = 0.4;  % Distance threshold (m) for turning

robot = rospublisher('/cmd_vel');
velmsg = rosmessage(robot);
laser = rossubscriber('/scan');

tic;
while toc < 60
    % Collect information from laser scan
    scan = receive(laser,1);
    plot(scan);
    data = readCartesian(scan);
    x = data(:,1);
    y = data(:,2);
    % Compute distance of the closest obstacle
    dist = sqrt(x.^2 + y.^2);
    minDist = min(dist);
    % Command robot action
    if minDist < distanceThreshold
        % If close to obstacle, back up slightly and spin
        velmsg.Angular.Z = spinVelocity;
        velmsg.Linear.X = backwardVelocity;
    else
        velmsg.Linear.X = forwardVelocity;
        velmsg.Angular.Z = 0;
    end
      send(robot,velmsg);
end

  rosshutdown  