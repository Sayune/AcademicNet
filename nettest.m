function [er, bad, preds] = nettest(net,x,y)
    net = netfp(net,x,y);
    [~, preds] = max(net.layers{net.numlayers}.a); %predictions of net
    [~, a] = max(y);
    bad = find(preds ~= a); %bad contains indexes of images incorrectly guessed
    er = numel(bad) /net.layers{1}.numimages; %error rate
end