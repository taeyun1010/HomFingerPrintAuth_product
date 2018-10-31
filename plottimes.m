%plots time taken to calculate 2-norm distances between the same person using double, for the whole
%dataset "NIST special database 9" versus number of features used in
%fingerprint authentication

numfeatures = [2, 8, 16, 384, 640, 1280];
% in seconds
time = [121, 152, 217, 539, 662, 1236];

plot(numfeatures, time, '-o');
% loglog(numfeatures, time, '-o');
xlabel("Number of features");
ylabel("time");