function []=NACA4415(n,a,v)
%����NACA4415�������
%�������Ϊ����ֶ���n(����ʱ����С��100��ʡ������ʱ��ʵ�ʼ��㽨�����100)��������a���Ƕ��ƣ��������ٶ�v����Ʋ���Ϊ2��

    close all;clc;    
    %NACA4415���Ͷ�Ӧ100m=4��10p=4��100t=15
    m=0.04;p=0.4;t=0.15;
    %�趨�����ҳ�c
    c=1;
    x=linspace(0,c,n);

    %�������͵ķֶ��л��߷���
    syms X
    Yc_u(X)=m.*X./power(p,2).*(2*p-X./c);
    Yc_l(X)=m.*(c-X)./power(1-p,2).*(1-2*p+X./c);
    %�����л�����X�����϶�Ӧ�ĵ�Yֵ
    y_c=subs(Yc_u,X,x).*(0<=x & x<p*c)+...
        subs(Yc_l,X,x).*(p*c<=x & x<=c);
    %�������ͺ����X�����϶�Ӧ��ֵ
    y_t=t/0.2*c.*(0.2969.*sqrt(x./c)-0.126.*(x./c)-0.3516.*power(x./c,2)+0.2843.*power(x./c,3)-0.1036.*power(x./c,4));
    %�ֶ��л��߷��̶�x��
    dYc_udx=diff(Yc_u(X));
    dYc_ldx=diff(Yc_l(X));
    %y_c�󵼺���X�����϶�Ӧ��ֵ
    dy_cdx=subs(dYc_udx,X,x).*(0<=x & x<p*c)+...
           subs(dYc_ldx,X,x).*(p*c<=x & x<=c);
    %�л����϶�Ӧ��н�
    theta=atan(dy_cdx);
    %���滮�ֵ�
    x_u=double(x-y_t.*sin(theta));
    y_u=double(y_c+y_t.*cos(theta));
    x_l=double(x+y_t.*sin(theta));
    y_l=double(y_c-y_t.*cos(theta));
    
    %�������滮�ֵ�ϲ�Ϊ��ǰԵ����˳ʱ�뻷�Ƶ�������
    x_surf=[x_u x_l(end-1:-1:1)];
    y_surf=[y_u y_l(end-1:-1:1)];
    
    %����Java�ײ���󻯴��ڣ���������޷���������ע�͵��ͺã�
    h = figure(1);
    jFrame = get(h,'JavaFrame');	
    set(jFrame,'Maximized',1);				
    pause(1);	
    
    %��������
    subplot(2,2,1);
    plot(x_u,y_u,x_l,y_l)
    axis equal
    title('2D NACA4415 Airfoil Profile')
    xlabel('x')
    ylabel('y')
    legend('������','������')

    %ȡ����ֶ��е�Ϊ���Ƶ�
    x_control_up=zeros(0,n-1);
    y_control_up=zeros(0,n-1);
    x_control_low=zeros(0,n-1);
    y_control_low=zeros(0,n-1);
   
    for i=1:n-1
        %��������Ƶ�
        x_control_up(i)=(x_u(i)+x_u(i+1))/2;
        y_control_up(i)=(y_u(i)+y_u(i+1))/2;
        %��������Ƶ�
        x_control_low(i)=(x_l(i)+x_l(i+1))/2;
        y_control_low(i)=(y_l(i)+y_l(i+1))/2;
    end
    %����������Ƶ�ϲ�Ϊ��ǰԵ����˳ʱ�뻷�Ƶ�������
    x_ctrl=[x_control_up x_control_low(end:-1:1)];
    y_ctrl=[y_control_up y_control_low(end:-1:1)];
    for i=1:2*(n-1)
        l(i)=sqrt(x_ctrl(i)^2+y_ctrl(i)^2);
    end
    
    length=zeros(1,2*(n-1));
    for i=1:2*(n-1)
        % ÿ������΢Ԫ�ĳ���
        length(i)=sqrt((x_surf(i+1)-x_surf(i))^2+(y_surf(i+1)-y_surf(i))^2);
    end
    
    [r,~,~]=rSolver(n,a,v,x_surf,y_surf,x_ctrl,y_ctrl,length,l);
    
    %�����ٶ�������
    u=(r(1:2*(n-1),1))';
    %��ѹ��ϵ��������
    Cp=1-(u./v).^2;
    
    %ѹ��ϵ������
    subplot(2,2,2);
    plot(x_control_up,Cp(1:n-1),'.',x_control_low(1:(n-2)),Cp(2*n-2-1:-1:n),'.')
    title('Pressure Coefficient')
    xlabel('x')
    ylabel('ѹ��ϵ��Cp')
    legend('������','������')
    set(gca,'YDir','reverse'); 
    
    %����ϵ������
    subplot(2,2,3);
    cl=[];
    cmle=[];
    bb=[-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10];

    for q=-5:10
       [~,T1,T2]=rSolver(n,q,v,x_surf,y_surf,x_ctrl,y_ctrl,length,l);
       Cl=2*T1/(v*c);
       Cmle=2*T2/(v*c);
       cl(q+6)=Cl;
       cmle(q+6)=Cmle;
    end

    %��������
    syms z;
    q=int((0.25*cos(z)-0.05)*(cos(z)-1),0,acos(0.2));
    b=int((5/45*cos(z)-1/45)*(cos(z)-1),acos(0.2),pi);
    q0=-1/pi*(q+b);
    e=int((0.25*cos(z)-0.05)*(cos(2*z)-cos(z)),0,acos(0.2));
    f=int((5/45*cos(z)-1/45)*(cos(2*z)-cos(z)),acos(0.2),pi);
    cml0=(1/2)*(e+f);
    z=-5:1:10;
    cmle1=-(2*pi*(z/180*pi-q0))/4+cml0;
    cl1=2*pi*(z/180*pi-q0);

    plot(z,cl1)
    hold on;
    plot(bb,cl); 
    hold off
    title("����ϵ������")  
    legend('��������','��������')

    %����ϵ������
    subplot(2,2,4);
    plot(z,cmle1);
    hold on 
    plot(bb,cmle);
    title("����ϵ������")  
    hold off
    legend('��������','��������')

     %����ʱ����
    flowSim(n,a,v,u,x_ctrl,y_ctrl,x_surf,y_surf,length)
end
