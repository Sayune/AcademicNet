function [er, bad] = nettest(net,x,y)
    net = netfp(net,x,y);
    [~, h] = max(net.layers{net.numlayers}.a);
    [~, a] = max(y);
    bad = find(h ~= a);
    er = numel(bad) /net.layers{1}.numimages; %error rate
end