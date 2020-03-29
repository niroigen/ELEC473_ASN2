function output = irwin_hall(mu, sigma)
    output = 0.5*sum(2*sigma*rand(12,1)-sigma);
end