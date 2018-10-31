% % distances between same person
% sdistances = ds_sameperson2d{4,4};
% % distances between diff person
% ddistances = ds_diffperson2d{4,4};
% 
% maxthreshold = max(max(sdistances), max(ddistances));
% % maxthreshold = int32(maxthreshold);
% thresholds = [0:0.1:maxthreshold];
% fns = zeros(1+maxthreshold);
% tps = zeros(1+maxthreshold);
% fps = zeros(1+maxthreshold);
% tns = zeros(1+maxthreshold);
% for i=1:0.1:(1+maxthreshold)
%      [fn,tp, fp, tn] = falsenegative(sdistances,ddistances,thresholds(i));
%      fns(i) = fn;
%      tps(i) = tp;
%      fps(i) = fp;
%      tns(i) = tn;
% end
% 
% figure
% plot(thresholds, fns);
% hold on;
%  plot(thresholds, tps);
%  plot(thresholds, fps);
%  plot(thresholds, tns);
% 
% xlabel('Threshold');
% ylabel('fn,tp,fp,tn');
% legend('False Negative','True Positive','False Positive','True Negative');

%   intbits     fracbits    EER
%   4           4           0.4845
%   8           4           0.3995
%   12          4           0.4045
%   16          4           0.4105
%   20          4           0.4040
%   24          4           0.4075
%   28          4           0.4030
%   32          4           0.4065
%   4           8           0.4885
%   8           8           0.4050
%   12          8           0.4020
%   16          8           0.4025
%   20          8           0.4005
%   24          8           0.4025
%   28          8           0.4085
%   32          8           0.4055
%   4           12          0.4970
%   8           12          0.4125
%   12          12          0.4050
%   16          12          0.4035
%   20          12          0.4000
%   24          12          0.4030
%   28          12          0.4015
%   32          12          0.3995
%   4           16          0.5005
%   8           16          0.4040
%   12          16          0.3985
%   16          16          0.4060
%   20          16          0.3995
%   24          16          0.3955
%   28          16          0.4030
%   32          16          0.4090
%   4           20          0.4905
%   8           20          0.3990
%   intbits =  [12,16,20,24,28,32,4,8,12,16,20,24,28,32]
%   fracbits = [20,20,20,20,20,20,24,24,24,24,24,24,24,24]
%   EERs =  [0.4075,0.4055,0.4055,0.4005,0.4055,0.4050,0.4920,0.3980,0.4110,0.4050,0.4050,0.4045,0.4110,0.4055]
%   4           28          0.4855
%   8           28          0.4035
%   12          28          0.4040
%   16          28          0.4050
%   20          28          0.4080
%   24          28          0.4060
%   28          28          0.3980
%   32          28          0.3990
%   1           32
%   2           32          0.5120
%   3           32          0.5030
%   4           32          0.4935
%   5           32          0.4725
%   6           32          0.4490
%   7           32          0.3995
%   8           32          0.4055
%   12          32          0.4035
%   16          32          0.3985
%   20          32          0.4030
%   24          32          0.4005
%   28          32          0.4000
%   32          32          0.4130

%   2           4           0.5040
%   3           4           0.5030
%   5           4           0.4645
%   6           4           0.4550
%   7           4           0.4015
%   2           8           0.5095
%   3           8           0.5010
%   5           8           0.4670
%   6           8           0.4535
%   7           8           0.4015
%   2           12          0.5060
%   3           12          0.5030
%   5           12          0.4595
%   6           12          0.4580
%   7           12          0.4045
%   2           16          0.5085
%   3           16          0.5140
%   5           16          0.4680
%   6           16          0.4515
%   7           16          0.4045
%   2           20          0.5060
%   3           20          0.5100
%   5           20          0.4675
%   6           20          0.4620
%   7           20          0.3985
%   2           24          0.5120
%   3           24          0.5040
%   5           24          0.4615
%   6           24          0.4645
%   7           24          0.4065
%   2           28          0.5000
%   3           28          0.5030
%   5           28          0.4630
%   6           28          0.4600
%   7           28          0.4035
intbit = 7;
fracbit = 20;

clear fns;
clear fps;
clear tps;
clear tns;
clear thresholds;
clear maxthreshold;
clear sdistances;
clear ddistances;

% distances between same person
% sdistances = ds_sameperson2d{intbit,fracbit};
% sdistances = d32_sameperson{intbit};
sdistances = ds_sameperson2ddifffb{intbit,fracbit};

% distances between diff person
% ddistances = ds_diffperson2d{intbit,fracbit};
% ddistances = ds_diffperson32{intbit};
ddistances = ds_diffperson2ddifffb{intbit,fracbit};

maxthreshold = max(max(sdistances), max(ddistances));
% maxthreshold = int32(maxthreshold);
thresholds = [0:0.01:maxthreshold];
% fns = zeros(length(thresholds));
% tps = zeros(length(thresholds));
% fps = zeros(length(thresholds));
% tns = zeros(length(thresholds));
for i=1:length(thresholds)
     [fn,tp, fp, tn] = falsenegative(sdistances,ddistances,thresholds(i));
     fns(i) = fn;
     tps(i) = tp;
     fps(i) = fp;
     tns(i) = tn;
end

fns = fns(1:length(fns));
tps = tps(1:length(tps));
fps = fps(1:length(fps));
tns = tns(1:length(tns));

d = fns ./ (fps + eps);
ix = find(d > .99 & d < 1.01);
thresholds_sol = thresholds(ix)
fns_sol = fns(ix)
fps_sol = fps(ix) 



% for i=1:length(fns)
%     thisfn = fns(i);
%     thisfp = fps(i);
%     if 
% end

% figure
% plot(thresholds, fns);
% hold on;
% % plot(thresholds, tps);
% plot(thresholds, fps);
% % plot(thresholds, tns);
% 
% xlabel('Threshold');
% ylabel('fn,tp,fp,tn');
% legend('False Negative','False Positive');