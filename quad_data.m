function quad_data

    rosshutdown  
     setenv('ROS_IP','192.168.127.1')
     rosinit('ib-T440p')

     %rostopic('list');

    % rostopic('info','/tf');

    %Subscribe to each of the quadrotor topics
    uav1  = rossubscriber('/uav1/ground_truth_to_tf/pose');
    uav6  = rossubscriber('/uav6/ground_truth_to_tf/pose');
    uav8  = rossubscriber('/uav8/ground_truth_to_tf/pose');
    uav10 = rossubscriber('/uav10/ground_truth_to_tf/pose');

    wind_pub = rospublisher('/wind');
    wind_msg = rosmessage(wind_pub);

    sld = uicontrol('Style', 'slider',...
            'Min',-4,'Max',4,'Value',0,...
            'Position', [400 10 120 20],...
            'Callback', @wind); 

    txt = uicontrol('Style','text',...
            'Position',[400 35 120 20],...
            'String','X Wind speed in m/s');    
   tic;
    while toc < 60
        uav1_pose = receive(uav1);
        uav6_pose = receive(uav6);
        uav8_pose = receive(uav8);
        uav10_pose = receive(uav10);
        hold on;
        grid on;
        axis([-1.5 1.5 -1.5 1.5 0 1.5])
        scatter3(uav1_pose.Pose.Position.X,uav1_pose.Pose.Position.Y,uav1_pose.Pose.Position.Z,1,'r')
        scatter3(uav6_pose.Pose.Position.X,uav6_pose.Pose.Position.Y,uav6_pose.Pose.Position.Z,1,'g')
        scatter3(uav8_pose.Pose.Position.X,uav8_pose.Pose.Position.Y,uav8_pose.Pose.Position.Z,1,'blue')
        scatter3(uav10_pose.Pose.Position.X,uav10_pose.Pose.Position.Y,uav10_pose.Pose.Position.Z,1,'black')
    end

    function wind(source,callbackdata)
        wind_msg.X = source.Value;
        send(wind_pub,wind_msg);
    end
    rosshutdown
end