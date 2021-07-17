function [r,T1,T2]=rSolver(n,a,v,x_surf,y_surf,x_ctrl,y_ctrl,length,l)
%��ǿ�����
%���ηֱ�Ϊ����ֶ���n��������a�������ٶ�v��һ����Ϣ
    
    %���ǵ���
    [x_surf,y_surf]=angleChange(x_surf,y_surf,a);
    [x_ctrl,y_ctrl]=angleChange(x_ctrl,y_ctrl,a);	

    %�������������
    A=zeros(2*n-1,2*n-2+1);
    B=zeros(2*n-1,1);
    for i=1:2*(n-1)
        B(i)=v*y_ctrl(i);
        for j=1:2*(n-1)           
            A(i,j)=Calc(x_ctrl(i),y_ctrl(i),x_surf(j),y_surf(j),x_surf(j+1),y_surf(j+1));
        end
        A(i,2*(n-1)+1)=1;
    end
    A(2*(n-1)+1,n-1:n)=1;
    A(2*(n-1)+1,2*(n-1)+1)=0;

    %�����Դ��ǿ
    r=(-1)*A\B;
    
    %��������
    for i=1:2*(n-1)
    T1(i)=r(i)*length(i);
    end
    T1=sum(T1);
    
    %��������ϵ������
    for i=1:2*(n-1)
    T2(i)=l(i)*r(i)*length(i);
    end
    T2=-sum(T2);
    
 end