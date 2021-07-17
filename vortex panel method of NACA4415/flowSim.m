function [] = flowSim(n,a,V,u,x_ctrl,y_ctrl,x_surf,y_surf,length)
%�������ӷ���

    %���ǵ���
    [x_surf,y_surf]=angleChange(x_surf,y_surf,a);
    [x_ctrl,y_ctrl]=angleChange(x_ctrl,y_ctrl,a);	

%     ----------------------ʸ����������֤����>>>-----------------------
    %����ģ��box�߽�
%     x_l=-0.5;x_r=1.5;
%     y_l=-0.5;y_u=0.5;
%     %����ϸ�������С
%     div_size=0.05;
%     %xy��ƫ��
%     x_shift=0;
%     y_shift=0;
%     
%     for x_shift=-0.5:0.01:0.5
%         X=[x_l:div_size:x_r]+x_shift;
%         Y=[y_l:div_size:y_u]+y_shift;
%         v=zeros((x_r-x_l)/div_size+1,(y_u-y_l)/div_size+1);
%         for j=1:(x_r-x_l)/div_size+1
%             for k=1:(y_u-y_l)/div_size+1
%                 x=X(j);y=Y(k);
%                 %���������ж���һ��������յ��ٶ�
%                 length=zeros(1,2*(n-1));
%                 for i=1:2*(n-1)
%                     length(i)=sqrt((x_surf(i+1)-x_surf(i))^2+(y_surf(i+1)-y_surf(i))^2);
%                 end
%                 vector0=-x_ctrl+x+1i*(-y_ctrl+y);
%                 dist=abs(vector0);
%                 v_u=u.*length./(2*pi*dist);
%                 vector=vector0./1i./dist.*v_u;
%                 %���������е�j�е�i�е��ٶ�ʸ��
%                 v(j,k)=sum(vector)+V;
%             end
%         end
%     
%         clf;
%         plot(x_surf,y_surf)
%         axis equal
%         hold on
%         quiver(X,Y,real(v)',imag(v)','MaxHeadSize',0.1,'AutoScaleFactor',1)
%         pause(0.01)
%     end
%     ----------------------<<<ʸ����������֤����-----------------------

    % ����ϸ������
    div_y=0.04;
    % ����ģ��box�߽�
    x_l=-0.3;x_r=1.3;
    y_l=-0.5;y_u=0.5;
    % ʱ�䲽���ֶ�
    dt=0.003;
    % y����ƫ�Ʊܿ���ģ
    y_shift=0.03;

    % �������ӷ���Դ
    N=round((y_u-y_l)/div_y+1);
    y_l=y_l+y_shift;y_u=y_u+y_shift;
    x_emit=zeros(1,N)+x_l;
    y_emit=[y_u:-1*div_y:y_l];

    % ��������������Ϣ
    X=x_emit';Y=y_emit';
    i=1;
    while min(X(:,i))<x_r
        for j=1:N
            x=X(j,i);y=Y(j,i);      
            % ���Ƶ�ָ��x��y����ʸ��
            vector0=-x_ctrl+x+1i*(-y_ctrl+y);
            % ���Ƶ㵽��x��y���ľ���
            dist=abs(vector0);
            v_u=u.*length./(2*pi*dist);
            % �յ��ٶ�ʸ��
            vector=vector0./1i./dist.*v_u;
            % ���жԣ�x��y����������յ��ٶ�v
            v=sum(vector)+V;
            X(j,i+1)=X(j,i)+real(v)*dt;
            Y(j,i+1)=Y(j,i)+imag(v)*dt;
        end 
        i=i+1;
    end

    % �����˶����ӻ�
    % �Զ��嶯������ʱ�䣨ʵ��ʱ�佫�ۼӻ��������ʱ����֡�ʣ���ʵʱ����֡�ʾ�����Ϊ������ʼ֡��ʱ��ֶ�
    t=3;fps=30;frame=1;div_time=7;
    Frame=frame;
    figure(2);
    while(t>=0)
        clf;
        plot(x_surf,y_surf)
        axis equal
        axis([x_l x_r y_l y_u])
        hold on
        if ~frame 
            frame=1;
        end
        if ~Frame 
            Frame=1;
        end
        plot(X(:,frame:div_time:end),Y(:,frame:div_time:end),'b.','MarkerSize',13,'color',[77/255 190/255 238/255])
        plot(X(:,Frame:div_time*5:end),Y(:,Frame:div_time*5:end),'.','MarkerSize',13,'color',[217/255 83/255 25/255])
        t=t-1/fps;
        frame=mod(frame+1,div_time+1);
        Frame=mod(Frame+1,div_time*5+1);
        pause(1/2/fps);
    end
    
end

