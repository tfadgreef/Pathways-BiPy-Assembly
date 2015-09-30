function dy = rigid(t,y,par)

dy = zeros(3,1);    % a column vector
dy(1) = y(2) * y(3);
dy(2) = -y(1) * y(3);
dy(3) = par(1) * y(1) * y(2);

