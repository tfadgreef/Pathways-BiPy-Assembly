function dy = vanderPol(t,y,par)

dy = zeros(2,1);
dy(1) = y(2);
dy(2) = par(1) * (1 - (y(1) * y(1))) * y(2) - y(1);
