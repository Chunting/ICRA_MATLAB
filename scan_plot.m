
% File path to your bagfile
filePath = 'C:\Users\ibaranov\ownCloud\PROWORK\Matlab-ROS work\laserAvoid_Real.bag';
% Load bagfile into MATLAB
bag = rosbag(filePath);

% Select the /scan topic only, from start to end of bag times
selectOptions = {'Time', [1426875681.40891,1426875709.18983], 'MessageType', {'sensor_msgs/LaserScan', '/scan'}};
laser = select(bag,selectOptions{:});

filePath = 'C:\Users\ibaranov\ownCloud\PROWORK\Matlab-ROS work\laserAvoid_Real.bag';

% read /scan messages from selected bagfile
msgs = readMessages (laser);

for idx = 1:numel(msgs)
    plot(msgs{idx})
    M(idx) = getframe;
end

%Generate movie file you can share
figure
movie(M,5)